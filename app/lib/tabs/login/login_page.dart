import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kumi/config/fire_auth.dart';
import 'package:kumi/tabs/login/register.dart';
import 'package:kumi/config/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _hasFailed = false;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          decoration: pageDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: largeTitleStyle,
                ),
              ),
              quadSpacing,
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value!,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                        errorBorder: errorBorder
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
                        errorBorder: errorBorder
                      ),
                    ),
                    halfSpacing,
                    _isProcessing
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                _focusEmail.unfocus();
                                _focusPassword.unfocus();

                                if (_formKey.currentState!
                                    .validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  try {
                                    await FireAuth
                                        .signInUsingEmailPassword(
                                        email: _emailTextController.text,
                                        password:
                                        _passwordTextController.text,
                                        context: context
                                    );
                                  } on FirebaseAuthException {
                                    setState(() {
                                      _hasFailed = true;
                                    });
                                  }

                                  setState(() {
                                    _isProcessing = false;
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
                              child: const Text(
                                'Sign In',
                                style: ordinaryWhiteStyle,
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigoAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: regularRadius,
                                ),
                                padding: allSidesTenInsets,
                              ),
                              child: const Text(
                                'Register',
                                style: ordinaryWhiteStyle,
                              ),
                            ),
                          ),
                    quadSpacing,
                    _hasFailed
                      ? const Text('Login failed, please try again.',)
                      : const Text ('')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}