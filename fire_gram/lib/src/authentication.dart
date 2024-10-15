import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class Authentication extends StatelessWidget {
  const Authentication({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          //Login/Logout button
          child: StyledButton(
            onPressed: () {
              if (!loggedIn) {
                context.push('/sign-in');
              } else {
                signOut();
                // Redirect to login screen after sign out
                context.pushReplacement('/sign-in');
              }
            },
            child: Text(loggedIn ? 'Logout' : 'Login/Register'),
          ),
        ),
        if (loggedIn)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            //Profile button
            child: StyledButton(
              onPressed: () {
                context.push('/profile');
              },
              child: const Text('Profile'),
            ),
          ),
      ],
    );
  }
}
