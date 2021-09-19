import 'package:brew_crew/services/authService.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});
    
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: Text('Register for Brew Crew'),
        actions: [TextButton.icon(onPressed: () => widget.toggleView(), icon: Icon(Icons.person), label: Text('Sign In'))],
      ),
      body: loading? Loading() : Column(
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
                    decoration: textInputDecoration.copyWith(hintText:'Email'),
                    validator: (val1) => val1!.isEmpty? 'Enter Email Please':null,
                    onChanged: (val1) => email = val1,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText:'Password'),
                    validator: (val2) => val2!.length < 6? 'Enter a longer password':null,
                    onChanged: (val2) => password = val2,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(error,style: TextStyle(color: Colors.red,fontSize:12)),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: Text('Register', style: TextStyle()),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.registerWithEmailandPassword(email, password);
                          if (result == null){
                            setState(() =>error = 'Please Try Again, with a valid emai and password');
                            loading = false;
                          }
                          print(result);
                          // print(email);
                          // print(password);
                        }
                      }),
                ],
              )),
            ),
          ),
          ElevatedButton(
                  child: Text('Register with Google', style: TextStyle()),
                  onPressed: () async {
                    if(true){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithGoogle();
                      if (result == null){
                        setState(() =>error = 'Please Try Again, idk whats up');
                        loading = false;
                      }
                      print(result);
                    }
                  })
        ],
      ),
    );
  }
}