// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'archive.dart';
import 'downloads.dart';
import 'explore.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final body = [
    const ExplorePageWidget(),
    const ArchivePageWidget(),
    const DownloadPageWidget(),
  ];
  late PageController _pageController;
  late String matric;

  void navTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matric = prefs.getString('matric')!;

    var url = Uri.parse('https://toopasty.com.ng/inception/get.php');
    var response = await http.post(url, body: {
      'sql': "SELECT matric, name, level FROM user WHERE matric = '$matric'",
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      prefs.setString('name', data[0]["name"]);
      prefs.setString('level', data[0]["level"]);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: body,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        iconSize: 25.0,
        currentIndex: selectedIndex,
        onTap: navTap,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: selectedIndex == 0
                  ? const Icon(Icons.library_books)
                  : const Icon(Icons.library_books_outlined),
              label: 'Library'),
          BottomNavigationBarItem(
              icon: selectedIndex == 1
                  ? const Icon(Icons.folder)
                  : const Icon(Icons.folder_open_outlined),
              label: 'Archives'),
          BottomNavigationBarItem(
              icon: selectedIndex == 2
                  ? const Icon(Icons.download)
                  : const Icon(Icons.download_outlined),
              label: 'Downloads'),
        ],
      ),
    );
  }
}
