import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  //update user Data
  Future updateUserData(String name, String sugars, int strength) async {
    return await brewCollection
        .doc(uid)
        .set({'sugars': sugars, 'name': name, 'strength': strength});
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user stream
  Stream<UserData> get appUserStream{
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get Brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Brew(
            name: doc.get('name') ?? '',
            sugars: doc.get('sugars') ?? '0',
            strength: doc.get('strength') ?? 0))
        .toList();
  }

  //get user list from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
            uid: uid!,
            name: snapshot.get('name') ?? '',
            sugars: snapshot.get('sugars') ?? '0',
            strength: snapshot.get('strength') ?? 0);
  }
}
