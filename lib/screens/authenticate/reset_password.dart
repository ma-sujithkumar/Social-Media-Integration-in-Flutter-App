import 'package:login/services/auth.dart';
import 'package:login/shared/constants.dart';
import 'package:login/shared/loading.dart';
import 'package:flutter/material.dart';

class Reset extends StatefulWidget {
  /* final Function toggleView;
  Reset({this.toggleView});*/

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  final snackBar = SnackBar(content: Text('Link has been sent to your email'));

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Reset Password'),
            ),
            body: Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
            )),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'email'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.blue[400],
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.resetPassword(email);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Incorrect email ID';
                              });
                            } else {
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                          setState(() {
                            Scaffold.of(context).showSnackBar(snackBar);
                            Navigator.of(context).pop();
                          });
                        }),
                    SizedBox(height: 12.0),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
