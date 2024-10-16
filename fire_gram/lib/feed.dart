import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_gram/comment.dart';
import 'package:fire_gram/like_selection.dart';
import 'package:flutter/material.dart';
import 'new_post.dart';

import 'src/widgets.dart';

class Feed extends StatefulWidget {
  const Feed({
    super.key, 
    required this.posts,
    required this.comments
  });

  

  final List<PostonFeed> posts;

  final List<Comment> comments; // new

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_FeedState');
  final _controller = TextEditingController();
  final _comment_controller = TextEditingController();

  @override
  // Modify from here...
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ...to here.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a Post',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your post to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    
                    if (_formKey.currentState!.validate()) {
                      await widget.addPost(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('POST'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Modify from here...
        const SizedBox(height: 8),
        for (var message in widget.posts)
        Column(children: [
          Paragraph('${message.name}: ${message.message}'),
          LikeSelection(
                  state: appState.liked,
                  onSelection: (liked) => appState.liked = liked,
                  ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _comment_controller,
                    decoration: const InputDecoration(
                      hintText: 'Comment',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your Comment to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addComment(_comment_controller.text);
                      _comment_controller.clear();
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('Comment'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          

        const SizedBox(height: 8),
        ],)
      ],
      // ...to here.
    );
  }
}
 