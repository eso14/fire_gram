import 'package:flutter/material.dart';

import 'app_state.dart';
import 'src/widgets.dart';

import 'package:flutter/src/services/text_formatter.dart';

class LikeSelection extends StatelessWidget {
  const LikeSelection(
      {super.key, required this.state, required this.onSelection});
  final Liked state;
  final void Function(Liked selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Liked.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FilledButton(
                onPressed: () => onSelection(Liked.yes),
                child: const Icon(Icons.favorite),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => onSelection(Liked.yes),
                child: const Icon(Icons.favorite),
              ),
             
            ],
          ),
        );
    }
  }
}