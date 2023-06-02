import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jash/pages/notepad/notepad_message.dart';

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
        _notepadSubscription = FirebaseFirestore.instance
            .collection('notepad')
            .doc('messages')
            .collection('messages')
            .orderBy('order')
            .snapshots()
            .listen((snapshot) {
          _notepadMessages = [];
          for (final document in snapshot.docs) {
            Map<String, dynamic> data = document.data();
            _notepadMessages.add(
              NotepadMessage(
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
        _notepadMessages = [];
        _notepadSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  void updateNotepadMessagesOrder(List<NotepadMessage> messages) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.runTransaction((_) async {
      for (var (i, message) in messages.indexed) {
        FirebaseFirestore.instance
            .doc("notepad/messages/messages/${message.dbId}")
            .update({'order': i});
      }
    });
  }

  void updateNotepadMessage(NotepadMessage message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var messageDoc = FirebaseFirestore.instance
        .doc('notepad/messages/messages/${message.dbId}');
    messageDoc.update({
      'text': message.text,
      'timestamp': message.timePosted.millisecondsSinceEpoch,
      'name': message.username,
      'userId': message.userId
    });
  }

  void deleteNotepadMessage(NotepadMessage message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var messageDoc = FirebaseFirestore.instance
        .doc('notepad/messages/messages/${message.dbId}');
    messageDoc.delete();
  }

  Future<NotepadMessage> addNotepadMessage(String message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var messagesCollection =
        FirebaseFirestore.instance.collection('notepad/messages/messages');

    int currentHighestOrder =
        (await messagesCollection.count().get()).count - 1;

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

    return NotepadMessage(
        dbId: addedDoc.id,
        text: message,
        timePosted: timestamp,
        username: username,
        userId: userId);
  }

  StreamSubscription<QuerySnapshot>? _notepadSubscription;
  List<NotepadMessage> _notepadMessages = [];

  List<NotepadMessage> get notepadMessages => _notepadMessages;
}
