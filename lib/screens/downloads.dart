import 'package:flutter/material.dart';
import 'package:project_inception/utilities/constants.dart';

class DownloadPageWidget extends StatefulWidget {
  final books;
  const DownloadPageWidget({Key? key, this.books}) : super(key: key);

  @override
  State<DownloadPageWidget> createState() => _DownloadPageWidgetState();
}

class _DownloadPageWidgetState extends State<DownloadPageWidget> {
  @override
  void initState() {
    // TODO: sort this todo
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Downloads',
            style: appBarStyle,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tempDownload.isEmpty
                  ? Center(
                      child: Text('No Downloaded Files yet',
                          style: subBodyStyle.copyWith(color: textColor)))
                  : DownGridView(
                      myList: tempDownload,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
