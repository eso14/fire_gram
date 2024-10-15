import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

//Visual Screen for authentication
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  
  String _username = '';
  String _password = '';
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.pushReplacement('/');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('FireGram Login/Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: _isRegistering ? 'New Username:' : 'Username:',
                ),
                onChanged: (value) => _username = value,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: _isRegistering ? 'New Password:' : 'Password:',
                ),
                //Hides password
                obscureText: true,
                onChanged: (value) => _password = value,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_isRegistering) {
                  //Register new user
                  await _auth.createUserWithEmailAndPassword(
                      email: _username, password: _password);
                } else {
                  //Login previous user
                  await _auth.signInWithEmailAndPassword(
                      email: _username, password: _password);
                }
                context.pushReplacement('/');
              },
              child: Text(_isRegistering ? 'Create Account' : 'Log In'),
            ),
            const SizedBox(height: 10),
            //Button for switching between login and register
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(
                _isRegistering
                    ? 'Previous user? Log in:'
                    : 'New user? Register:',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
