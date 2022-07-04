import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:project_inception/utilities/constants.dart';

class Read extends StatefulWidget {
  final title;
  Read({required this.title});

  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  late String title;

  @override
  void initState() {
    title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        title: Text(
          title,
          style: appBarStyle,
        ),
      ),
      body: SfPdfViewer.network(
          'https://projectinception.000webhostapp.com/books/test1.pdf'),
    );
  }
}
