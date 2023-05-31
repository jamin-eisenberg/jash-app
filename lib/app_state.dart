import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

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
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> addWhiteboardMessage(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    var whiteboardCollection =
        FirebaseFirestore.instance.collection('whiteboard');
    var highestOrderDoc = whiteboardCollection.doc('highestOrder');

    return highestOrderDoc.get().then((currentHighestOrderDoc) {
      int currentHighestOrder = currentHighestOrderDoc.data()?['value'] ?? 0;

      return whiteboardCollection.add(<String, dynamic>{
        'text': message,
        'order': highestOrderDoc
            .set(<String, dynamic>{'value': currentHighestOrder + 1}),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      }).then((_) => highestOrderDoc
          .set(<String, dynamic>{'value': currentHighestOrder + 1}));
    });
  }

  StreamSubscription<QuerySnapshot>? _whiteboardSubscription;
  List<String> _whiteboardMessages = [];

  List<String> get whiteboardMessages => _whiteboardMessages;
}
