import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate
    final appUser = Provider.of<AppUser?>(context);
    print('App User: ' + appUser.toString());
    if(appUser ==null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}