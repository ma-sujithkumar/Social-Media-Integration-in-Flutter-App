import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/wrapper.dart';
import 'package:login/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:login/models/user.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NewUser>.value(
      value: AuthService().user,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper()),
    );
  }
}
