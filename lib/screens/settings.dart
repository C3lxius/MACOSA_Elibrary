import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_inception/utilities/constants.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_left),
          color: backgroundColor,
          iconSize: 35.0,
        ),
        title: const Text(
          'Settings',
          style: appBarStyle,
        ),
      ),
      body: const SettingsPageWidget(),
    );
  }
}
