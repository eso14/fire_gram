import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
              onPressed: () {
                context.push('/sign-in');
              },
              child: !loggedIn ? const Text('Log In') : const Text('Logout')),
        ),
        Visibility(
          visible: loggedIn,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: StyledButton(
                onPressed: () {
                  context.push('/');
                },
                child: const Text('Home')),
          ),
        )
      ],
    );
  }
}
