// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:project_inception/utilities/constants.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final body = [
    const ExplorePageWidget(),
    ArchivePageWidget(),
    DownloadPageWidget(),
  ];

  void navTap(int index) {
    if (index == 1) {
      isArchive = true;
    } else {
      isArchive = false;
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        iconSize: 25.0,
        currentIndex: selectedIndex,
        onTap: navTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: selectedIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: 'Explore'),
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
