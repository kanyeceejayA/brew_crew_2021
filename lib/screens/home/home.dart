import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/authService.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettings() {
      showModalBottomSheet(context: context, builder: (context){
        return Container(child: SettingsForm() ,padding: EdgeInsets.all(20),);
      });
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService().brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(onPressed: _showSettings, icon: Icon(Icons.settings), label: Text('Settings')),
          ],
        ),
        body:Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/coffee_bg.png'),fit: BoxFit.cover)),child: BrewList()),
      ),
    );

  }
    
}