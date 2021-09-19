import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];  
  String? _currentName;  
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: appUser!.uid).appUserStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data as UserData;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Edit your Settings', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _currentName?? userData.name,
                  decoration: textInputDecoration.copyWith(hintText: 'name'),
                  validator: (val1) => val1!.isEmpty ? 'Please enter your name' : null,
                  onChanged: (val1) => _currentName = val1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                    value: _currentSugars?? userData.sugars,
                    onChanged: (val2)=> _currentSugars = val2 as String,
                    items: sugars
                        .map((sugar) => DropdownMenuItem(
                            value: sugar, child: Text('$sugar Sugars')))
                        .toList()),
                SizedBox(
                  height: 20,
                ),
                Slider(
                    max: 900,
                    min: 100,
                    divisions: 8,
                    activeColor: Colors.brown[_currentStrength?? userData.strength],
                    inactiveColor: Colors.brown[_currentStrength?? userData.strength],
                    value: (_currentStrength?? userData.strength).toDouble(),
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round())
                ),
                ElevatedButton(
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        await DatabaseService(uid: appUser.uid).updateUserData(_currentName?? userData.name, _currentSugars?? userData.sugars, _currentStrength?? userData.strength);
                        Navigator.pop(context);
                        print('updated');
                      }
                      
                    },
                    child: Text('Update'))
              ],
            ));
        }else{
          return Loading();
        }
      }
    );
  }
}
