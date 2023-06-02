import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jash/pages/whiteboard/whiteboard_message.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _whiteboardSubscription = FirebaseFirestore.instance
            .collection('whiteboard')
            .doc('messages')
            .collection('messages')
            .orderBy('order')
            .snapshots()
            .listen((snapshot) {
          _whiteboardMessages = [];
          for (final document in snapshot.docs) {
            Map<String, dynamic> data = document.data();
            _whiteboardMessages.add(
              WhiteboardMessage(
                dbId: document.id,
                text: data['text'] as String,
                userId: data['userId'] as String,
                username: data['name'] as String,
                timePosted: DateTime.fromMillisecondsSinceEpoch(
                    data['timestamp'] as int),
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _whiteboardMessages = [];
        _whiteboardSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  void updateWhiteboardMessagesOrder(List<WhiteboardMessage> messages) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.runTransaction((_) async {
      for (var (i, message) in messages.indexed) {
        FirebaseFirestore.instance
            .doc("whiteboard/messages/messages/${message.dbId}")
            .update({'order': i});
      }
    });
  }

  void updateWhiteboardMessage(WhiteboardMessage message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var messageDoc = FirebaseFirestore.instance
        .doc('whiteboard/messages/messages/${message.dbId}');
    messageDoc.update({'text': message.text});
  }

  void deleteWhiteboardMessage(WhiteboardMessage message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var messageDoc = FirebaseFirestore.instance
        .doc('whiteboard/messages/messages/${message.dbId}');
    messageDoc.delete();
  }

  Future<WhiteboardMessage> addWhiteboardMessage(String message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // TODO allow deletion/editing/info

    var messagesCollection =
        FirebaseFirestore.instance.collection('whiteboard/messages/messages');

    int currentHighestOrder = (await messagesCollection.count().get()).count - 1;

    int order = currentHighestOrder + 1;
    DateTime timestamp = DateTime.now();
    String username = FirebaseAuth.instance.currentUser!.displayName ?? "";
    String userId = FirebaseAuth.instance.currentUser!.uid;

    var addedDoc = await messagesCollection.add(<String, dynamic>{
      'text': message,
      'order': order,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'name': username,
      'userId': userId,
    });

    return WhiteboardMessage(
        dbId: addedDoc.id,
        text: message,
        timePosted: timestamp,
        username: username,
        userId: userId);
  }

  StreamSubscription<QuerySnapshot>? _whiteboardSubscription;
  List<WhiteboardMessage> _whiteboardMessages = [];

  List<WhiteboardMessage> get whiteboardMessages => _whiteboardMessages;
}
