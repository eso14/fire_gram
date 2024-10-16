import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_gram/new_post.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

enum Liked { yes, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = true;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _userSubscription;

  List<PostonFeed> _postsOnFeed = [];
  List<PostonFeed> get postsonFeed => _postsOnFeed;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
    FirebaseFirestore.instance
        .collection('likes')
        .where('liked', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      notifyListeners();
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _userSubscription = FirebaseFirestore.instance
            .collection('users')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _postsOnFeed = [];
          for (final document in snapshot.docs) {
            _postsOnFeed.add(
              PostonFeed(
                name: document.data()['name'] as String,
                message: document.data()['text'] as String,
              ),
            );
          }
          notifyListeners();
        });
        _likedSubscription = FirebaseFirestore.instance
            .collection('likes')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot.data()!['liked'] as bool) {
              _liked = Liked.yes;
            } else {
              _liked = Liked.unknown;
            }
          } else {
            _liked = Liked.unknown;
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _postsOnFeed = [];
        _userSubscription?.cancel();
        _likedSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addPostToFeed(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('posts').add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Liked _liked = Liked.unknown;
  StreamSubscription<DocumentSnapshot>? _likedSubscription;
  Liked get liked => _liked;
  set liked(Liked liked) {
    final userDoc = FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (liked == Liked.yes) {
      userDoc.set(<String, dynamic>{'liked': true});
    } else {
      userDoc.set(<String, dynamic>{'liked': false});
    }
  }
}
