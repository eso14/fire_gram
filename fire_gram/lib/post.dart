import 'dart:async';

import 'package:flutter/material.dart';
import 'new_post.dart';

import 'src/widgets.dart';

class Post extends StatefulWidget {
  const Post({
    super.key, 
    required this.addComment, 
    required this.comments,
  });

  final FutureOr<void> Function(String textPost) addComment;
  final List<PostonFeed> comments; // new

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PostState');
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
                    controller: _comment_controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a Comment',
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
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Modify from here...
        const SizedBox(height: 8),
        for (var message in widget.comments)
          Paragraph('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
      ],
      // ...to here.
    );
  }
}