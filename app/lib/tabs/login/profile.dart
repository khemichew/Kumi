import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app/config/fire_auth.dart';
import 'package:app/config/style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  final emailButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: regularRadius,
    ),
    padding: allSidesTenInsets,
  );

  late User _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  AppBar getTitleBar(BuildContext context) {
    return AppBar(
        backgroundColor: skyBlue,
        elevation: 10,
        title: const Text("My account", style: titleStyle),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.chevron_left, color: Colors.black,),
          )
    );
  }

  Widget get userName => Align(
    alignment: Alignment.topLeft,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Name",
          style: emphStyle,
        ),
        Text(
          '${_currentUser.displayName}',
          style: ordinaryStyle,
        ),
      ]
    )
  );

  Widget get userEmail => Align(
    alignment: Alignment.topLeft,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email Address",
          style: emphStyle,
        ),
        Text(
          '${_currentUser.email}',
          style: ordinaryStyle,
        ),
      ]
    )
  );

  Widget getVerifyEmailButton(void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: emailButtonStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Verify email',
            style: (onPressed == null)
              ? ordinaryStyle.copyWith(color: Colors.black45)
              : ordinaryStyle.copyWith(color: Colors.white),
          ),
          halfSpacing,
          const Icon(Icons.email_outlined)
        ]
      )
    );
  }

  Widget get signOutButton => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        setState(() {
          _isSigningOut = true;
        });
        await FirebaseAuth.instance.signOut();
        setState(() {
          _isSigningOut = false;
        });

        if (!mounted) return;
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: regularRadius,
        ),
        padding: allSidesTenInsets,
      ),
      child: Text(
        'Sign out',
        style: ordinaryStyle.copyWith(color: Colors.white),
      ),
    ),
  );

  Widget get refreshButton => ElevatedButton(
    onPressed: () async {
      User? user = await FireAuth.refreshUser(_currentUser);

      if (user != null) {
        setState(() {
          _currentUser = user;
        });
      }
    },
    style: ElevatedButton.styleFrom(
      primary: Colors.indigoAccent,
      shape: RoundedRectangleBorder(
        borderRadius: regularRadius,
      ),
      padding: allSidesTenInsets,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Refresh',
          style: ordinaryStyle.copyWith(color: Colors.white),
        ),
        halfSpacing,
        const Icon(Icons.refresh)
      ]
    )
  );

  Widget get profile => Container(
    decoration: pageDecoration,
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        userName,
        halfSpacing,
        userEmail,
        Align(
          alignment: Alignment.topLeft,
          child: _currentUser.emailVerified
              ? quadSpacing
              : Text(
            'Email not verified',
            style: smallStyle.copyWith(color: Colors.red),
          ),
        ),
        halfSpacing,
        _isSendingVerification
            ? const CircularProgressIndicator()
            : SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentUser.emailVerified
                  ? getVerifyEmailButton(null)
                  : getVerifyEmailButton (() async {
                    setState(() {
                      _isSendingVerification = true;
                    });

                    await _currentUser.sendEmailVerification();

                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                ),
              refreshButton
            ],
          ),
        ),
        quadSpacing,
        _isSigningOut
            ? const CircularProgressIndicator()
            : signOutButton
      ],
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profile,
      appBar: getTitleBar(context),
    );
  }
}