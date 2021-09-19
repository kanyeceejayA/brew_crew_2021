
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {

  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final _brews = Provider.of<List<Brew>?>(context);
    if(_brews != null){

      return ListView.builder(
        itemCount: _brews.length,
        itemBuilder: (BuildContext context, int index) {
        return BrewTile(brew: _brews[index]);
       },
      );
    }
    return Loading();
  }
}