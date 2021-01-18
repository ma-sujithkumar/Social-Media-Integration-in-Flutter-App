import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // create user obj based on firebase user
  NewUser _userFromFirebaseUser(User user) {
    if (user != null) {
      return NewUser(uid: user.uid, email: user.email);
    } else {
      return null;
    }
  }

  // auth change user stream
  Stream<NewUser> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign in with google
  Future<User> LoginWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    print(user);
    /*name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;*/
    return user;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  Future<LinkedHashMap> fbLogin() async {
    User currentUser;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
      final result = await facebookLogin.logIn(['email']);
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${token}');
      final profile = jsonDecode(graphResponse.body);
      return profile;
      /*if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(facebookAccessToken.token);
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User user = authResult.user;
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        return currentUser;*/
    } catch (e) {
      print(e);
    }
  }

  Future<void> fbLogOut() async {
    await _auth.signOut();
    await facebookLogin.logOut();
  }
}
