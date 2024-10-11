import 'dart:async';

import 'package:flutter/material.dart';
import 'new_post.dart';

import 'src/widgets.dart';

class Feed extends StatefulWidget {
  const Feed({
    super.key, 
    required this.addPost, 
    required this.posts,
  });

  final FutureOr<void> Function(String textPost) addPost;
  final List<PostonFeed> posts; // new

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_FeedState');
  final _controller = TextEditingController();

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
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
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
        for (var message in widget.posts)
          Paragraph('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
      ],
      // ...to here.
    );
  }
}