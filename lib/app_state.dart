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
            _whiteboardMessages.add(
              WhiteboardMessage(
                  dbId: document.id,
                  message: document.data()['text'] as String),
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

  void updateWhiteboardMessageOrder(List<WhiteboardMessage> messages) {
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

  Future<WhiteboardMessage> addWhiteboardMessage(String message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // TODO allow deletion/editing/info

    var highestOrderDoc = FirebaseFirestore.instance.doc('whiteboard/highestOrder');
    var messagesCollection = FirebaseFirestore.instance.collection('whiteboard/messages/messages');

    var currentHighestOrderDoc = await highestOrderDoc.get();
    int currentHighestOrder = currentHighestOrderDoc.data()?['value'] ?? 0;

    var addedDoc = await messagesCollection.add(<String, dynamic>{
      'text': message,
      'order': currentHighestOrder + 1,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    await highestOrderDoc
        .set(<String, dynamic>{'value': currentHighestOrder + 1});

    return WhiteboardMessage(dbId: addedDoc.id, message: message);
  }

  StreamSubscription<QuerySnapshot>? _whiteboardSubscription;
  List<WhiteboardMessage> _whiteboardMessages = [];

  List<WhiteboardMessage> get whiteboardMessages => _whiteboardMessages;
}
