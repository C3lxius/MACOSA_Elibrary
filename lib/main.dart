import 'package:flutter/material.dart';
import 'package:project_inception/screens/landing_page.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Jocefin'),
    home: LandingPage(),
  ));
}
