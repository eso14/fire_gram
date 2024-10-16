import 'package:fire_gram/like_selection.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
//import 'package:gtk_flutter/feed.dart';
//import 'package:gtk_flutter/like_selection.dart';

import 'package:provider/provider.dart';

import 'app_state.dart';
import 'feed.dart';
import 'post.dart';
import 'src/authentication.dart';
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
        children:<Widget>[
          SizedBox(height: 8),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Header('Feed'),
                  
                    Feed(
                    addPost: (message) =>
                        appState.addPostToFeed(message),
                        posts: appState.postsonFeed, 
                  ),
                  LikeSelection(
                  state: appState.liked,
                  onSelection: (liked) => appState.liked = liked,
                  ),
                 
                ],
            ),
          ),
          
        ],
      ),
    );
  }
}
