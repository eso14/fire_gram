import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
//import 'package:gtk_flutter/feed.dart';
//import 'package:gtk_flutter/like_selection.dart';

import 'package:provider/provider.dart';          // new

import 'app_state.dart';                          // new
import 'feed.dart'; 
import 'post.dart';
import 'src/authentication.dart';                 // new
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireGram'),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 8),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          ],
          ),
          );
          }

          }