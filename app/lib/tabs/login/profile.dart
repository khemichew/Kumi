import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app/tabs/login/login_page.dart';
// import 'package:app/tabs/login/register.dart';
import 'package:app/config/fire_auth.dart';
import 'package:app/config/style.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'NAME: ${_currentUser.displayName}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        quadSpacing,
        Text(
          'EMAIL: ${_currentUser.email}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        quadSpacing,
        _currentUser.emailVerified
            ? Text(
          'Email verified',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.green),
        )
            : Text(
          'Email not verified',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.red),
        ),
        quadSpacing,
        _isSendingVerification
            ? const CircularProgressIndicator()
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSendingVerification = true;
                });
                await _currentUser.sendEmailVerification();
                setState(() {
                  _isSendingVerification = false;
                });
              },
              child: const Text('Verify email'),
            ),
            const SizedBox(width: 8.0),
            TextButton(
              child: const Icon(Icons.refresh),
              onPressed: () async {
                User? user = await FireAuth.refreshUser(_currentUser);

                if (user != null) {
                  setState(() {
                    _currentUser = user;
                  });
                }
              },
            ),
          ],
        ),
        quadSpacing,
        _isSigningOut
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            setState(() {
              _isSigningOut = true;
            });
            await FirebaseAuth.instance.signOut();
            setState(() {
              _isSigningOut = false;
            });
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}