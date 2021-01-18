import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/models/user.dart';
import 'package:login/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser>(context);
    return Container(
      child: Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            title: Text('Health Bot'),
            backgroundColor: Colors.blue[400],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
          body: Container(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "User ID: " + user.uid,
                    style: TextStyle(fontSize: 16.0,fontWeight:FontWeight.w300),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Email: " + user.email,
                    style: TextStyle(fontSize: 15.0,fontWeight:FontWeight.w300),
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}
