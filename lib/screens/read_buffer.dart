import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_inception/screens/read.dart';
import 'package:project_inception/utilities/constants.dart';

class ReadBufferPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final book;
  final bool isDownloaded;
  const ReadBufferPage(
      {Key? key, required this.book, required this.isDownloaded})
      : super(key: key);

  @override
  _ReadBufferPageState createState() => _ReadBufferPageState();
}

class _ReadBufferPageState extends State<ReadBufferPage> {
  late Map<String, dynamic> book;
  final ReceivePort _port = ReceivePort();
  late bool isDownloaded;

  @override
  void initState() {
    isDownloaded = widget.isDownloaded;
    book = widget.book;
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          book["title"].substring(0, book["title"].length - 4),
          style: appBarStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://toopasty.com.ng/inception/images/${book['image']!}',
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Text(
                          book["title"].substring(0, book["title"].length - 4),
                          style: bodyStyle)),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.6,
                    child: Text(book['author'] ?? '',
                        style: subBodyStyle.copyWith(color: textColor)),
                  ),
                  const SizedBox(height: 8.0),
                  Text(book['upload'],
                      style: subBodyStyle.copyWith(color: textColor)),
                ]),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        Directory permDir =
                            await getApplicationDocumentsDirectory();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Read(
                            title: book["title"],
                            isDownloaded: isDownloaded,
                            dir: permDir,
                          );
                        }));
                      },
                      icon: const Icon(FontAwesomeIcons.readme),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      label: const Text(
                        'Read',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: isDownloaded
                        ? OutlinedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            icon: const Icon(FontAwesomeIcons.checkToSlot),
                            label: const Text(
                              'Downloaded',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        : OutlinedButton.icon(
                            onPressed: () async {
                              tempDownload.add(book);
                              Directory permDir =
                                  await getApplicationDocumentsDirectory();
                              File file =
                                  File(permDir.path + '/' + 'downloads.json');
                              String url =
                                  'https://www.toopasty.com.ng/inception/books/${book['title']}';
                              final id = FlutterDownloader.enqueue(
                                  url: url,
                                  fileName: book['title'],
                                  savedDir: permDir.path,
                                  showNotification: false);
                              file.writeAsString(jsonEncode(tempDownload));
                              setState(() {
                                isDownloaded = true;
                              });
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            icon: const Icon(FontAwesomeIcons.download),
                            label: const Text(
                              'Download',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                  ),
                ]),
            const SizedBox(height: 10.0),
            const Text('Description', style: bodyStyle),
            const SizedBox(height: 8.0),
            Text(
              book['description'],
            ),
            const SizedBox(height: 20),
            // const Text('Comments', style: bodyStyle),
            // Expanded(
            //   child: Center(
            //       child: Text(
            //     'No comments yet...',
            //     style: subBodyStyle.copyWith(color: textColor),
            //   )),
            // ),
            // TextField(
            //   decoration: InputDecoration(
            //       labelText: 'Enter Comment here...',
            //       labelStyle: const TextStyle(color: lightTextColor),
            //       suffixIcon: IconButton(
            //         onPressed: () {},
            //         icon: const Icon(Icons.send),
            //         iconSize: 24,
            //         color: primaryColor,
            //       ),
            //       isDense: true,
            //       enabledBorder: OutlineInputBorder(
            //           borderSide:
            //               BorderSide(color: lightTextColor.withOpacity(0.6)),
            //           borderRadius: BorderRadius.circular(10)),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: const BorderSide(color: primaryColor),
            //           borderRadius: BorderRadius.circular(10))),
            // ),
          ],
        ),
      ),
    );
  }
}
