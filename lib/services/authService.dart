import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService{

  final _auth = FirebaseAuth.instance;

  //create AppUser
  AppUser? _appUserFromUser(User? user){
    if(user != null){
    return AppUser(uid: user.uid);
    }else{
      return null;
    }
  } 

//sign in with google
Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn() as GoogleSignInAccount;

  try{
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential results = await FirebaseAuth.instance.signInWithCredential(credential);
    User user = results.user as User;
    print('we\'ve gotteen:$user.uid');
    return _appUserFromUser(user);
  }catch(e){
    print(e.toString());
  }
}


Future signInWithApple() async{
  try{
    // To prevent replay attacks with the credential returned from Apple, we include a nonce in the credential request. When signing in with Firebase, the nonce in the id token returned by Apple, is expected to match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }catch(e){
    print(e.toString());
  }
}

  //auth change user stream: tell if someone is logged in or out
  Stream<AppUser?> get user{
    // return _auth.authStateChanges().map((user) => _appUserFromUser(user));
    return _auth.authStateChanges().map(_appUserFromUser);
  }

  //sign in anon
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user as User;
      return _appUserFromUser(user);
    }catch(e){
      print(e.toString());
    }
  }

  //sign in with email and password
  Future signInWithEmailandPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user as User;
      return _appUserFromUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  //register with email and password
  Future registerWithEmailandPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user as User;
      //create new doc for new user
      await DatabaseService(uid: user.uid).updateUserData('0', email, 100);
      return _appUserFromUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  //signout
  Future signOut() async{
    try{
      print('signed out');
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }


//sign in with phone functions

Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, int? forceResnedingtoken) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(String verificationId, String smsCode,BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =await _auth.signInWithCredential(credential);
      

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// sign in whth apple extra functions
/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
  

}