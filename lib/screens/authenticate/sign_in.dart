import 'dart:io';

import 'package:brew_crew/services/authService.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  bool loading = false;
  //user deets
  String email = '';
  String password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
        actions: [
          TextButton.icon(
              onPressed: () => widget.toggleView(),
              icon: Icon(Icons.person),
              label: Text('Register'))
        ],
      ),
      body: loading? Loading() : ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration,
                        validator: (val1) =>
                            val1!.isEmpty ? 'Enter Email Please' : null,
                        onChanged: (val1) => email = val1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'password'),
                        validator: (val2) =>
                            val2!.length < 6 ? 'Enter a longer password' : null,
                        onChanged: (val2) => password = val2,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                      ElevatedButton(
                          child: Text('Sign In'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithEmailandPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error ='Please Try Again, with valid credentials';
                                  loading = false;
                                });
                              }
                            }
                          }),
                    ],
                  )),
            ),
          ),
          ElevatedButton(
            child: Text('Sign in with Google', style: TextStyle()),
            onPressed: () async {
              if(true){
                setState(() => loading = true);
                dynamic result = await _auth.signInWithGoogle();
                if (result == null){
                  setState(() =>error = 'Please Try Again');
                  loading = false;
                }
                print(result);
              }
            }),
          ElevatedButton(
            child: Text('Sign in with Google', style: TextStyle()),
            onPressed: () async {
              if(true){
                setState(() => loading = true);
                dynamic result = await _auth.signInWithGoogle();
                if (result == null){
                  setState(() =>error = 'Please Try Again');
                  loading = false;
                }
                print(result);
              }
            }),
          if(Platform.isIOS)
          ElevatedButton(
            child: Text('Sign in with Apple', style: TextStyle()),
            onPressed: () async {
              if(true){
                setState(() => loading = true);
                dynamic result = await _auth.signInWithApple();
                if (result == null){
                  setState(() =>error = 'Please Try Again');
                  loading = false;
                }
                print(result);
              }
            }),

        ],
      ),
    );
  }
}
