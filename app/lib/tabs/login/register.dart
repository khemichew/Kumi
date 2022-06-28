import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kumi/config/style.dart';
import 'package:kumi/config/fire_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _hasFailed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          decoration: pageDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign up',
                    style: largeTitleStyle,
                  ),
                ),
                quadSpacing,
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: errorBorder,
                        ),
                      ),
                      quadSpacing,
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorBorder: errorBorder,
                        ),
                      ),
                      quadSpacing,
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) => Validator.validatePassword(
                          password: value!,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorBorder: errorBorder,
                        ),
                      ),
                      halfSpacing,
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      _isProcessing = true;
                                    });

                                    User? user;
                                    try {
                                      user = await FireAuth
                                          .registerUsingEmailPassword(
                                        name: _nameTextController.text,
                                        email: _emailTextController.text,
                                        password:
                                        _passwordTextController.text,
                                      );
                                    } on FirebaseAuthException {
                                      setState(() {
                                        _hasFailed = true;
                                      });
                                    }

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    if (!mounted) {
                                      return;
                                    }

                                    if (user != null) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: regularRadius,
                                  ),
                                  padding: allSidesTenInsets,
                                ),
                                child: Text(
                                  'Sign up',
                                  style: ordinaryStyle.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                      quadSpacing,
                      _isProcessing
                          ? quadSpacing
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigoAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: regularRadius,
                                  ),
                                  padding: allSidesTenInsets,
                                ),
                                child: const Text(
                                  'Back to login',
                                  style: ordinaryWhiteStyle,
                                ),
                              ),
                            ),
                      quadSpacing,
                      _hasFailed
                          ? const Text('Register failed, please try again.',)
                          : const Text ('')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}