import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String name,id;
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: formkey,
          child: buildTextFormField(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: createData,
              child: Text('Create', style: TextStyle(color: Colors.white)),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: id != null ? readData : null,
              child: Text('Read', style: TextStyle(color: Colors.white)),
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  void createData() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'name': '$name '});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }


  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }
}

