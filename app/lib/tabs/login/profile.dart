import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'My\naccount',
                style: largeTitleStyle,
              ),
              // Image(image: AssetImage('../asset/dingzhen_cute.jpeg'))
              CircleAvatar(
                backgroundImage: AssetImage('assets/dingzhen_cute.jpeg'),
                radius: 60,
              )
            ]
          ),
          halfSpacing,
          Align(
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
                  // 'Jim Brown',
                  '${_currentUser.displayName}',
                  style: ordinaryStyle,
                ),
              ]
            )
          ),
          halfSpacing,
          Align(
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
          ),
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
                        ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: regularRadius,
                              ),
                              padding: allSidesTenInsets,
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Verify email',
                                    style: ordinaryStyle.copyWith(color: Colors.black45),
                                  ),
                                  halfSpacing,
                                  const Icon(Icons.email_outlined)
                                ]
                            ))
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isSendingVerification = true;
                              });
                              await _currentUser.sendEmailVerification();
                              setState(() {
                                _isSendingVerification = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: regularRadius,
                              ),
                              padding: allSidesTenInsets,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Verify email',
                                  style: ordinaryStyle.copyWith(color: Colors.white),
                                ),
                                halfSpacing,
                                const Icon(Icons.email_outlined)
                              ]
                            )
                          ),
                      ElevatedButton(
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
                      ),
                    ],
                  ),
              ),
          quadSpacing,
          _isSigningOut
              ? const CircularProgressIndicator()
              : SizedBox(
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
                ),
        ],
      )
    );
  }
}