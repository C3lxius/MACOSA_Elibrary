import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_inception/screens/read_buffer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

const backgroundColor = Color(0xfffafafa);
const primaryColor = Color(0xff63B19D);
const secondaryColor = Color(0xffFE6634);
const textColor = Color(0xFF8D8E98);
const lightTextColor = Color(0xFFA7A4AB);

const userNameStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w900);
const userSubnameStyle = TextStyle(
    fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.w500);
const settingSubStyle =
    TextStyle(color: textColor, fontStyle: FontStyle.italic, fontSize: 16);
const appBarStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const tabLabelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const bodyStyle = TextStyle(fontSize: 14);
const bigBodyStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
const subBodyStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

late int? isLoggedIn;
int selectedIndex = 0;
List search = [];
List<Map> downloads = [];
late List tempDownload;

findDownload(List download, String bookName) {
  // Find the index of the book. If not found, index = -1
  final index = download.indexWhere((element) => element['title'] == bookName);
  if (index >= 0) {
    return true;
  } else {
    return false;
  }
}

//CUSTOM WIDGETS

class Video extends StatefulWidget {
  final controller;
  const Video({Key? key, this.controller}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: controller.value.isInitialized
          ? Center(
              child: VideoPlayer(controller),
            )
          : const SizedBox(
              height: 200, child: Center(child: CircularProgressIndicator())),
    );
  }
}

class Gallery extends StatefulWidget {
  final List image;
  final PageController pageController;
  final int index;
  Gallery({required this.image, required this.index})
      : pageController = PageController(initialPage: index);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
        pageController: widget.pageController,
        itemCount: widget.image.length,
        builder: (context, index) {
          final imageUrl =
              "https://www.toopasty.com.ng/inception/archives/high_res/${widget.image[index]['title']}";
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(imageUrl),
          );
        });
  }
}

class MySearchDelegate extends SearchDelegate {
  List searchResults = [];
  Map searchResult = {};

  List ik = ['shapes', 'shilent', 'howwa', 'banana'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResults.clear();
    searchResults = search
        .where((element) => element.startsWith(query.toLowerCase()))
        .toList();

    return Container(
      margin: const EdgeInsets.all(20),
      child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResults.length, (index) {
            var item = searchResults[index];
            return Card(
              color: Colors.white,
              child: Container(
                  padding: const EdgeInsets.all(16), child: Text(item)),
            );
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}

class GridViewCard extends StatefulWidget {
  final List myList;
  final String? image;

  const GridViewCard({Key? key, required this.myList, this.image})
      : super(key: key);

  @override
  State<GridViewCard> createState() => _GridViewCardState();
}

class _GridViewCardState extends State<GridViewCard> {
  String? image;
  late List myList;

  @override
  void initState() {
    myList = widget.myList;
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, mainAxisSpacing: 7, crossAxisSpacing: 7),
          itemCount: myList.length,
          itemBuilder: (_, index) {
            return Card(
              elevation: 2.0,
              shadowColor: textColor,
              child: InkWell(
                onTap: () {
                  bool isDownloaded =
                      findDownload(tempDownload, myList[index]['title']);
                  Map<String, dynamic> map = myList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReadBufferPage(
                        book: map, isDownloaded: isDownloaded);
                  }));
                },
                splashColor: primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://www.toopasty.com.ng/inception/images/${myList[index]["image"]}"),
                                fit: BoxFit.contain,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                myList[index]["title"].substring(
                                    0, myList[index]["title"].length - 4),
                                style: bodyStyle.copyWith(fontSize: 14),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          BottomModal(myList: myList, index: index)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class DownGridView extends StatefulWidget {
  final List myList;
  final String? image;

  const DownGridView({Key? key, required this.myList, this.image})
      : super(key: key);

  @override
  State<DownGridView> createState() => _DownGridViewState();
}

class _DownGridViewState extends State<DownGridView> {
  String? image;
  late List myList;

  Future<void> removeDownload(List download, String bookName) async {
    final index =
        download.indexWhere((element) => element['title'] == bookName);
    if (index >= 0) {
      download.removeAt(index);
      Directory permDir = await getApplicationDocumentsDirectory();
      File file = File(permDir.path + '/' + download[index]['title']);
      File dFile = File(permDir.path + '/' + 'downloads.json');
      try {
        if (await file.exists()) {
          await file.delete();
          await dFile.delete();
          dFile.writeAsString(jsonEncode(download));
        }
      } catch (e) {
        // Error in getting access to the file.
      }
    }
  }

  @override
  void initState() {
    myList = widget.myList;
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, mainAxisSpacing: 7, crossAxisSpacing: 7),
          itemCount: myList.length,
          itemBuilder: (_, index) {
            return Card(
              elevation: 2.0,
              shadowColor: textColor,
              child: InkWell(
                onTap: () {
                  bool isDownloaded =
                      findDownload(tempDownload, myList[index]['title']);
                  Map<String, dynamic> map = myList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReadBufferPage(
                        book: map, isDownloaded: isDownloaded);
                  }));
                },
                splashColor: primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://www.toopasty.com.ng/inception/images/${myList[index]["image"]}"),
                                fit: BoxFit.contain,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                myList[index]["title"].substring(
                                    0, myList[index]["title"].length - 4),
                                style: bodyStyle.copyWith(fontSize: 14),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: ListTile(
                                                title: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            "https://toopasty.com.ng/inception/images/${myList[index]["image"]}"),
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                const SizedBox(width: 25.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.6,
                                                      child: Text(
                                                          myList[index]["title"]
                                                              .substring(
                                                                  0,
                                                                  myList[index][
                                                                              "title"]
                                                                          .length -
                                                                      4),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: bigBodyStyle),
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.6,
                                                      child: Text(
                                                          myList[index]
                                                              ["author"],
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: subBodyStyle),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                          ),
                                          const Divider(
                                              color: textColor, height: 0.3),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Details'),
                                                      content: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            2,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Name:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.6,
                                                                      child: Text(
                                                                          myList[index]["title"].substring(
                                                                              0,
                                                                              myList[index]["title"].length -
                                                                                  4),
                                                                          softWrap:
                                                                              true,
                                                                          style:
                                                                              bodyStyle),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Author:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.6,
                                                                      child: Text(
                                                                          myList[index]
                                                                              [
                                                                              'author'],
                                                                          style:
                                                                              bodyStyle),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Description:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.6,
                                                                      child: Text(
                                                                          myList[index]
                                                                              [
                                                                              'description'],
                                                                          style:
                                                                              bodyStyle),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Size:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    Text(
                                                                        myList[index]['size'] +
                                                                            'kb',
                                                                        style:
                                                                            bodyStyle)
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Date Uploaded:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    Text(
                                                                        myList[index]
                                                                            [
                                                                            'upload'],
                                                                        style:
                                                                            bodyStyle)
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10.0),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Category:',
                                                                      style: bodyStyle.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            2.0),
                                                                    Text(
                                                                        myList[index]
                                                                            [
                                                                            'category'],
                                                                        style:
                                                                            bodyStyle)
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Done'))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const ListTile(
                                              leading: Icon(
                                                  FontAwesomeIcons.circleInfo,
                                                  color: Colors.black54),
                                              title: Text(
                                                'Details',
                                                style: bodyStyle,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              removeDownload(
                                                  myList,
                                                  myList[index]["title"]
                                                      .substring(
                                                          0,
                                                          myList[index]["title"]
                                                                  .length -
                                                              4));
                                              setState(() {});
                                              Navigator.of(context).pop;
                                            },
                                            child: const ListTile(
                                              leading: Icon(
                                                  FontAwesomeIcons.download,
                                                  color: Colors.black54),
                                              title: Text(
                                                'Remove from downloads',
                                                style: bodyStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: textColor,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class ListViewCard extends StatefulWidget {
  double? height;
  final List myList;
  final String? image;

  ListViewCard({Key? key, required this.myList, this.image, this.height})
      : super(key: key);

  @override
  State<ListViewCard> createState() => _ListViewCardState();
}

class _ListViewCardState extends State<ListViewCard> {
  late List books;
  late List myList;
  String? image;

  @override
  void initState() {
    myList = widget.myList;
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (_, index) {
            return Card(
              elevation: 2.0,
              color: Colors.white,
              shadowColor: textColor.withOpacity(0.8),
              child: InkWell(
                onTap: () {
                  bool isDownloaded =
                      findDownload(tempDownload, myList[index]['title']);
                  Map<String, dynamic> map = myList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReadBufferPage(
                        book: map, isDownloaded: isDownloaded);
                  }));
                },
                splashColor: primaryColor.withOpacity(0.1),
                child: SizedBox(
                  height: widget.height ?? 60,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 60,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://www.toopasty.com.ng/inception/images/${myList[index]["image"]}"),
                                fit: BoxFit.contain,
                              )),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: Text(
                                        myList[index]["title"].substring(0,
                                            myList[index]["title"].length - 4),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: bodyStyle),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: Text(myList[index]["author"],
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: subBodyStyle),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      BottomModal(myList: myList, index: index)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class BottomModal extends StatelessWidget {
  const BottomModal({
    Key? key,
    required this.myList,
    required this.index,
  }) : super(key: key);

  final List myList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                          title: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      "https://toopasty.com.ng/inception/images/${myList[index]["image"]}"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(width: 25.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Text(
                                    myList[index]["title"].substring(
                                        0, myList[index]["title"].length - 4),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: bigBodyStyle),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Text(myList[index]["author"],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: subBodyStyle),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                    const Divider(color: textColor, height: 0.3),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Details'),
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                child: Text(
                                                    myList[index]["title"]
                                                        .substring(
                                                            0,
                                                            myList[index][
                                                                        "title"]
                                                                    .length -
                                                                4),
                                                    softWrap: true,
                                                    style: bodyStyle),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Author:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                child: Text(
                                                    myList[index]['author'],
                                                    style: bodyStyle),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Description:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.6,
                                                child: Text(
                                                    myList[index]
                                                        ['description'],
                                                    style: bodyStyle),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Size:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(myList[index]['size'] + 'kb',
                                                  style: bodyStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date Uploaded:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(myList[index]['upload'],
                                                  style: bodyStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Category:',
                                                style: bodyStyle.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(myList[index]['category'],
                                                  style: bodyStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Done'))
                                ],
                              );
                            });
                      },
                      child: const ListTile(
                        leading: Icon(FontAwesomeIcons.circleInfo,
                            color: Colors.black54),
                        title: Text(
                          'Details',
                          style: bodyStyle,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(FontAwesomeIcons.download,
                            color: Colors.black54),
                        title: Text(
                          'Save for offline',
                          style: bodyStyle,
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        icon: const Icon(
          Icons.more_vert,
          color: textColor,
        ));
  }
}
