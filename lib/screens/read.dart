import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:project_inception/utilities/constants.dart';

class Read extends StatefulWidget {
  final String title;
  final bool isDownloaded;
  final Directory dir;
  const Read(
      {Key? key,
      required this.title,
      required this.isDownloaded,
      required this.dir})
      : super(key: key);

  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  late String title;
  late bool isDownloaded;
  late File file;

  @override
  initState() {
    title = widget.title;
    isDownloaded = widget.isDownloaded;
    file = File(widget.dir.path + '/' + title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        title: Text(
          title.substring(0, widget.title.length - 4),
          style: appBarStyle,
        ),
      ),
      body: isDownloaded
          ? SfPdfViewer.file(file)
          : SfPdfViewer.network(
              'https://toopasty.com.ng/inception/books/$title'),
    );
  }
}
