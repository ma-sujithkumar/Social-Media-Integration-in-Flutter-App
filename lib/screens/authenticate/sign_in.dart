import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/screens/authenticate/reset_password.dart';
import 'package:login/services/auth.dart';
import 'package:login/shared/constants.dart';
import 'package:login/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  //google
  String name = '';
  String gmail = '';
  String imageUrl = '';
  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Sign in to the App'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue[100], Colors.blue[400]],
                  )),
              height: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.blue[400],
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                    'Could not sign in with those credentials';
                              });
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('New to App? Register'),
                      onPressed: () => widget.toggleView(),
                    ),
                    SizedBox(height: 12.0),
                    FlatButton.icon(
                      icon: Icon(Icons.text_format),
                      label: Text('Forgot Password?'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => Reset()));
                      },
                    ),
                    SizedBox(height: 20.0),
                    OutlineButton(
                      splashColor: Colors.black,
                      onPressed: () {
                        setState(() async {
                          User user = await _auth.LoginWithGoogle();
                          name = user.displayName;
                          gmail = user.email;
                          imageUrl = user.photoURL;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => GoogleScreen(
                                  name: name,
                                  gmail: gmail,
                                  imageUrl: imageUrl)));
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 30.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    OutlineButton(
                      splashColor: Colors.black,
                      onPressed: () {
                        setState(() async {
                          Map user = await _auth.fbLogin();
                          name = user['name'];
                          gmail = user['email'];
                          imageUrl = user['picture']['data']['url'];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FacebookScreen(
                                  name: name,
                                  gmail: gmail,
                                  imageUrl: imageUrl)));
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                image: AssetImage("assets/facebook-logo-.png"),
                                height: 30.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign in with Facebook',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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

class GoogleScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  String name, gmail, imageUrl;
  GoogleScreen({Key key, @required this.name, this.gmail, this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Google Account")
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                gmail,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  _auth.signOutGoogle();
                  /* Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return SignIn();
                  }), ModalRoute.withName('/'));*/
                  Navigator.of(context).pop();
                },
                color: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FacebookScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  String name, gmail, imageUrl;
  FacebookScreen({Key key, @required this.name, this.gmail, this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Facebook Account")
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                gmail,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  _auth.fbLogOut();
                  /* Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return SignIn();
                  }), ModalRoute.withName('/'));*/
                  Navigator.of(context).pop();
                },
                color: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
