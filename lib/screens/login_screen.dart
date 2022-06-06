// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';
import '../data/http_helper.dart';
import '../utils/snackbar.dart';

enum Stage { LOGIN, REGISTER }

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.nav, required this.prefs})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final prefs;
  Function nav;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var currentStage = Stage.LOGIN;

  //state value for user login
  Map<String, dynamic> user = {};

  @override
  Widget build(BuildContext context) {
    return loadStage(currentStage);
  }

  Widget loadStage(Enum stage) {
    switch (stage) {
      case Stage.REGISTER:
        return _registerForm(context);
      default:
        return _loginForm(context);
    }
  }

  Widget _loginForm(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Login to GIFTR'),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 90),
                  children: [
                    Column(children: [
                      _buildEmail(),
                      const SizedBox(height: 20),
                      _buildPassword(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //validation has been passed so we can save the form
                                _formKey.currentState!.save();
                                _loginButtonPressed();
                              } else {
                                //form failed validation so exit
                                return;
                              }
                            },
                          ),
                          const SizedBox(width: 16.0),
                          TextButton(
                              child: const Text('Register'),
                              onPressed: () {
                                setState(() {
                                  // //if register button is pressed, clear all values and proceed
                                  // //
                                  // _formKey.currentState!.reset();
                                  currentStage = Stage.REGISTER;
                                });
                              }),
                        ],
                      ),
                    ]),
                  ],
                ),
              ))));
  }

  Widget _registerForm(BuildContext context) {
  return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register to GIFTR'),
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please fill in all the details below.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(height: 30),
                    _buildEmail(),
                    const SizedBox(height: 20),
                    _buildPassword(),
                    const SizedBox(height: 20),
                    _buildFirstName(),
                    const SizedBox(height: 20),
                    _buildLastName(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              registerUser();
                            }
                          },
                        ),
                        const SizedBox(width: 16.0),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            setState(() {
                              _formKey.currentState!.reset();
                              currentStage = Stage.LOGIN;
                            });
                          },
                        )
                      ]
                    )
                    ],
                  )
              ]
              ),
            )
          )
          )
        );
  }

  InputDecoration _styleField(String label, String hint) {
    return InputDecoration(
      labelText: label, // label
      hintText: hint, //placeholder
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      decoration: _styleField('Email', 'Email'),
      controller: emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email address';
          //becomes the new errorText value
        }
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['email'] = value;
        });
      },
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      decoration: _styleField('Password', ''),
      controller: passwordController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Please enter a password';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          user['password'] = value;
        });
      },
    );
  }

  TextFormField _buildFirstName() {
    return TextFormField(
      controller: firstNameController,
      decoration: _styleField('First Name', 'First Name'),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'First Name is required';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          user['firstName'] = value;
        });
      },
    );
  }

  TextFormField _buildLastName() {
    return TextFormField(
      controller: lastNameController,
      decoration: _styleField('Last Name', 'Last Name'),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Last Name is required';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          user['lastName'] = value;
        });
      },
    );
  }

  Future _loginButtonPressed() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> userData = {
      'data': {'attributes': user}
    };
    try {
      Map responseBody = await helper.loginUser(userData);
      String token = responseBody['data']['attributes']['accessToken'];
      await widget.prefs.setString('JWT', token);
      widget.nav('people');
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }

  void registerUser() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> userData = {
      'data': {'attributes': user}
    };
    //  move to login screen when registration is successful.
    try {
      bool registrationStatus = await helper.registerUser(userData);
      if (registrationStatus) {
        _loginButtonPressed();
      }
    }
    // catch the error and display it to the user in a snack bar.
    catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }
}
