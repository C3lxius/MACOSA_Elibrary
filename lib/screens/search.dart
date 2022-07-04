import 'package:flutter/material.dart';
import 'package:project_inception/utilities/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Search',
          style: appBarStyle,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Search...',
                          labelStyle: const TextStyle(color: lightTextColor),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                            iconSize: 24,
                            color: primaryColor,
                          ),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightTextColor.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Center(
                      child: Text(
                'search results show here',
                style: bodyStyle.copyWith(color: textColor),
              ))),
            ],
          ),
        ),
      ),
    );
  }
}
