import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_inception/screens/login.dart';
import 'package:project_inception/screens/read_buffer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
const bodyStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
const subBodyStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

int selectedIndex = 0;
late bool isArchive;
List search = [];

Future<bool> _onWillPop() async {
  return false;
}

void addFavourite() async {}

//CUSTOM WIDGETS

class ArchivePageWidget extends StatefulWidget {
  @override
  State<ArchivePageWidget> createState() => _ArchivePageWidgetState();
}

class _ArchivePageWidgetState extends State<ArchivePageWidget> {
  late List audio;
  late List doc;
  late List image;
  late List video;
  late Future archiveFuture;

  loadArchives() async {
    print('arch loading');
    Uri url = Uri.parse('https://projectinception.000webhostapp.com/get.php');
    var response1 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'audio'"});
    var response2 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'doc'"});
    var response3 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'image'"});
    var response4 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'video'"});

    // print(response1.statusCode);
    // print(response2.statusCode);
    // print(response3.statusCode);
    // print(response4.statusCode);
    // print(response3.body);

    if (response1.statusCode != 200 &&
        response2.statusCode != 200 &&
        response3.statusCode != 200 &&
        response4.statusCode != 200) {
      throw ('error');
    } else {
      audio = [];
      print(audio);
      doc = [];
      print(doc);
      image = jsonDecode(response3.body);
      print(image);
      video = [];
      print(video);
    }

    return 1;
  }

  List books = [];

  @override
  void initState() {
    archiveFuture = loadArchives();
    super.initState();
  }

  bool isset = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedIndex = 0;
        setState(() {
          print(selectedIndex);
        });
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              'Archives',
              style: appBarStyle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: MySearchDelegate());
                  },
                  icon: const Icon(Icons.search),
                  iconSize: 25),
              const SizedBox(width: 15.0)
            ],
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8.0),
              Expanded(
                  child: DefaultTabController(
                      length: 4,
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool isScroll) {
                          return [
                            SliverAppBar(
                              pinned: true,
                              backgroundColor: backgroundColor,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(0),
                                child: TabBar(
                                  labelStyle: tabLabelStyle,
                                  unselectedLabelColor: textColor,
                                  indicator: const BoxDecoration(),
                                  labelPadding:
                                      EdgeInsets.only(left: 2.0, right: 2.0),
                                  tabs: [
                                    ArchiveTabIcon(
                                      color: const Color(0xFF36B1D0),
                                      icon: Icons.audiotrack,
                                    ),
                                    ArchiveTabIcon(
                                      color: primaryColor,
                                      icon: Icons.description_outlined,
                                    ),
                                    ArchiveTabIcon(
                                      color: const Color(0xFFE100C4),
                                      icon: Icons.image,
                                    ),
                                    ArchiveTabIcon(
                                      color: secondaryColor,
                                      icon: Icons.video_library_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        },
                        body: FutureBuilder(
                          future: archiveFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return TabBarView(
                                children: [
                                  audio.isEmpty
                                      ? Center(
                                          child: Text('No Audio Files yet',
                                              style: subBodyStyle.copyWith(
                                                  color: textColor)))
                                      : Column(
                                          children: [
                                            const SizedBox(height: 10.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Audio Files',
                                                    style: bodyStyle.copyWith(
                                                        fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListViewCard(
                                              myList: audio,
                                              image: 'audio.png',
                                              height: 75,
                                            ),
                                          ],
                                        ),
                                  doc.isEmpty
                                      ? Center(
                                          child: Text('No Documents yet',
                                              style: subBodyStyle.copyWith(
                                                  color: textColor)))
                                      : Column(
                                          children: [
                                            const SizedBox(height: 10.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Documents',
                                                    style: bodyStyle.copyWith(
                                                        fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListViewCard(
                                              myList: doc,
                                              image: 'document.png',
                                              height: 75,
                                            ),
                                          ],
                                        ),
                                  image.isEmpty
                                      ? Center(
                                          child: Text('No Images yet',
                                              style: subBodyStyle.copyWith(
                                                  color: textColor)))
                                      : Column(
                                          children: [
                                            const SizedBox(height: 10.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Images',
                                                    style: bodyStyle.copyWith(
                                                        fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // GridViewCard(
                                            //   myList: image,
                                            //   image: 'image.png',
                                            // ),
                                            Expanded(
                                              child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              150,
                                                          mainAxisExtent: 120),
                                                  itemCount: image.length,
                                                  itemBuilder: (_, index) {
                                                    print(
                                                        image[index]['title']);
                                                    return Card(
                                                      elevation: 2.0,
                                                      shadowColor: textColor,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          print("onTap");
                                                        },
                                                        onLongPress: () {
                                                          print('Long press');
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                height: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color:
                                                                            backgroundColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              CachedNetworkImageProvider("https://projectinception.000webhostapp.com/images/archives/low_res/${image[index]['title']}"),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                              ),
                                                            ),
                                                            // Container(
                                                            //   color: Colors
                                                            //       .white,
                                                            //   child: Row(
                                                            //     mainAxisAlignment:
                                                            //         MainAxisAlignment
                                                            //             .spaceBetween,
                                                            //     children: [
                                                            //       Expanded(
                                                            //         child:
                                                            //             Padding(
                                                            //           padding:
                                                            //               const EdgeInsets.only(left: 8.0),
                                                            //           child:
                                                            //               Text(
                                                            //             image[index]["title"],
                                                            //             style:
                                                            //                 bodyStyle.copyWith(fontSize: 16),
                                                            //             softWrap:
                                                            //                 true,
                                                            //             overflow:
                                                            //                 TextOverflow.ellipsis,
                                                            //             maxLines:
                                                            //                 1,
                                                            //           ),
                                                            //         ),
                                                            //       ),
                                                            //       IconButton(
                                                            //         onPressed:
                                                            //             () {
                                                            //           showModalBottomSheet(
                                                            //               context: context,
                                                            //               builder: (context) {
                                                            //                 return Wrap(
                                                            //                   children: [
                                                            //                     Padding(
                                                            //                       padding: const EdgeInsets.all(16.0),
                                                            //                       child: ListTile(
                                                            //                           title: Row(
                                                            //                         children: [
                                                            //                           Container(
                                                            //                             width: 40,
                                                            //                             height: 40,
                                                            //                             decoration: BoxDecoration(
                                                            //                                 borderRadius: BorderRadius.circular(5),
                                                            //                                 image: image == null
                                                            //                                     ? DecorationImage(
                                                            //                                         image: AssetImage("images/${image[index]["image"]}"),
                                                            //                                         fit: BoxFit.cover,
                                                            //                                       )
                                                            //                                     : DecorationImage(image: AssetImage("images/$image"), fit: BoxFit.contain)),
                                                            //                           ),
                                                            //                           SizedBox(width: 25.0),
                                                            //                           Column(
                                                            //                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                             children: [
                                                            //                               Text(image[index]["title"], style: bodyStyle),
                                                            //                               SizedBox(height: 5.0),
                                                            //                               image[index]["subtitle"] != null ? Text(image[index]["subtitle"], style: subBodyStyle) : const SizedBox(),
                                                            //                             ],
                                                            //                           ),
                                                            //                         ],
                                                            //                       )),
                                                            //                     ),
                                                            //                     Divider(color: textColor, height: 0.3),
                                                            //
                                                            //                     InkWell(
                                                            //                       onTap: () {
                                                            //                         showDialog(
                                                            //                             context: context,
                                                            //                             builder: (context) {
                                                            //                               return AlertDialog(
                                                            //                                 title: const Text('Details'),
                                                            //                                 content: SizedBox(
                                                            //                                   height: MediaQuery.of(context).size.height / 2,
                                                            //                                   child: Column(
                                                            //                                     children: [
                                                            //                                       Row(
                                                            //                                         children: [
                                                            //                                           Column(
                                                            //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                                             children: [
                                                            //                                               Text(
                                                            //                                                 'Name:',
                                                            //                                                 style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                            //                                               ),
                                                            //                                               const SizedBox(height: 2.0),
                                                            //                                               Text(image[index]['title'], style: bodyStyle)
                                                            //                                             ],
                                                            //                                           ),
                                                            //                                         ],
                                                            //                                       ),
                                                            //                                       const SizedBox(height: 10.0),
                                                            //                                       Row(
                                                            //                                         children: [
                                                            //                                           Column(
                                                            //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                                             children: [
                                                            //                                               Text(
                                                            //                                                 isArchive ? 'Description:' : 'Author:',
                                                            //                                                 style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                            //                                               ),
                                                            //                                               const SizedBox(height: 2.0),
                                                            //                                               SizedBox(
                                                            //                                                 width: 230.0,
                                                            //                                                 child: Text(image[index]['subtitle'], style: bodyStyle),
                                                            //                                               )
                                                            //                                             ],
                                                            //                                           ),
                                                            //                                         ],
                                                            //                                       ),
                                                            //                                       const SizedBox(height: 10.0),
                                                            //                                       Row(
                                                            //                                         children: [
                                                            //                                           Column(
                                                            //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                                             children: [
                                                            //                                               Text(
                                                            //                                                 'Size:',
                                                            //                                                 style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                            //                                               ),
                                                            //                                               const SizedBox(height: 2.0),
                                                            //                                               Text(image[index]['size'] + 'kb', style: bodyStyle)
                                                            //                                             ],
                                                            //                                           ),
                                                            //                                         ],
                                                            //                                       ),
                                                            //                                       const SizedBox(height: 10.0),
                                                            //                                       Row(
                                                            //                                         children: [
                                                            //                                           Column(
                                                            //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                                             children: [
                                                            //                                               Text(
                                                            //                                                 'Date Uploaded:',
                                                            //                                                 style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                            //                                               ),
                                                            //                                               const SizedBox(height: 2.0),
                                                            //                                               Text(image[index]['upload'], style: bodyStyle)
                                                            //                                             ],
                                                            //                                           ),
                                                            //                                         ],
                                                            //                                       ),
                                                            //                                       const SizedBox(height: 10.0),
                                                            //                                       Row(
                                                            //                                         children: [
                                                            //                                           Column(
                                                            //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                            //                                             children: [
                                                            //                                               Text(
                                                            //                                                 'Category:',
                                                            //                                                 style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                            //                                               ),
                                                            //                                               const SizedBox(height: 2.0),
                                                            //                                               Text(image[index]['category'], style: bodyStyle)
                                                            //                                             ],
                                                            //                                           ),
                                                            //                                         ],
                                                            //                                       ),
                                                            //                                     ],
                                                            //                                   ),
                                                            //                                 ),
                                                            //                                 actions: [
                                                            //                                   TextButton(
                                                            //                                       onPressed: () {
                                                            //                                         Navigator.of(context).pop();
                                                            //                                       },
                                                            //                                       child: Text('Done'))
                                                            //                                 ],
                                                            //                               );
                                                            //                             });
                                                            //                       },
                                                            //                       child: ListTile(
                                                            //                         leading: Icon(Icons.info_outline_rounded),
                                                            //                         title: Text(
                                                            //                           'Details',
                                                            //                           style: bodyStyle,
                                                            //                         ),
                                                            //                       ),
                                                            //                     ),
                                                            //                     InkWell(
                                                            //                       onTap: () {},
                                                            //                       child: ListTile(
                                                            //                         leading: Icon(Icons.favorite_border_outlined),
                                                            //                         title: Text(
                                                            //                           'Add to favorites',
                                                            //                           style: bodyStyle,
                                                            //                         ),
                                                            //                       ),
                                                            //                     ),
                                                            //                     InkWell(
                                                            //                       onTap: () {},
                                                            //                       child: ListTile(
                                                            //                         leading: Icon(Icons.download_for_offline_outlined),
                                                            //                         title: Text(
                                                            //                           'Save for offline',
                                                            //                           style: bodyStyle,
                                                            //                         ),
                                                            //                       ),
                                                            //                     ),
                                                            //                   ],
                                                            //                 );
                                                            //               });
                                                            //         },
                                                            //         icon: Icon(
                                                            //             Icons.more_vert),
                                                            //         color:
                                                            //             secondaryColor,
                                                            //       )
                                                            //     ],
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                  video.isEmpty
                                      ? Center(
                                          child: Text('No Videos yet',
                                              style: subBodyStyle.copyWith(
                                                  color: textColor)))
                                      : Column(
                                          children: [
                                            const SizedBox(height: 10.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Videos',
                                                    style: bodyStyle.copyWith(
                                                        fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListViewCard(
                                              myList: video,
                                              image: 'video.png',
                                              height: 75,
                                            ),
                                          ],
                                        ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                        child: Text("An Error Occurred",
                                            style: bodyStyle)),
                                    TextButton(
                                      onPressed: () {
                                        archiveFuture = loadArchives();
                                        setState(() {});
                                      },
                                      style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(80, 30)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  primaryColor)),
                                      child: Text(
                                        'Retry',
                                        style: bodyStyle.copyWith(
                                            color: Colors.white),
                                      ),
                                    )
                                  ]);
                            } else {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor));
                            }
                          },
                        ),
                      )))
            ]),
          )),
    );
  }
}

class DownloadPageWidget extends StatefulWidget {
  final books;
  DownloadPageWidget({this.books});

  @override
  State<DownloadPageWidget> createState() => _DownloadPageWidgetState();
}

class _DownloadPageWidgetState extends State<DownloadPageWidget> {
  late List books;

  @override
  void initState() {
    widget.books == null ? books = [] : books = widget.books;
    super.initState();
  }

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Downloads',
            style: appBarStyle,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: MySearchDelegate());
                },
                icon: const Icon(Icons.search),
                iconSize: 25),
            const SizedBox(width: 15.0)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                books.length == 0
                    ? Center(
                        child: Text('No downloads yet',
                            style: subBodyStyle.copyWith(color: textColor)))
                    : GridViewCard(
                        myList: books[2],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List searchResults = [];
  Map searchResult = {};
  List bok = [
    {"image": "pic0.jpg", "title": "Shapes of Us", "author": "Van Berg"},
    {"image": "pic1.jpg", "title": "The count", "author": "Isla Ereg"},
    {"image": "pic2.jpg", "title": "Sonorous Notions", "author": "Cel Bansy"}
  ];
  List ik = ['shapes', 'shilent', 'howwa', 'banana'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResults.clear();
    int index = 0;
    String hey = '';

    // while (index < bok.length) {
    //   if (bok[index].containsKey("title")) {
    //
    //     hey = 'Yes';
    //   } else {
    //     hey = 'No';
    //   }
    // }
    searchResults = ik.where((element) => element.startsWith(query)).toList();

    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResults.length, (index) {
            var item = searchResults[index];
            return Card(
              color: Colors.white,
              child: Container(padding: EdgeInsets.all(16), child: Text(item)),
            );
          })),
    );
    //ListView Builder!
    // ListView.builder(
    //   itemCount: searchResults.length,
    //   itemBuilder: (_, index) {
    //     return Card(
    //       elevation: 2.0,
    //       color: Colors.white,
    //       shadowColor: textColor.withOpacity(0.8),
    //       child: InkWell(
    //         onTap: () {
    //           Map<String, dynamic> map = searchResults[index];
    //           Navigator.push(context, MaterialPageRoute(builder: (context) {
    //             return ReadBufferPage(book: map);
    //           }));
    //         },
    //         splashColor: primaryColor.withOpacity(0.1),
    //         child: SizedBox(
    //           height: 60,
    //           child: Row(
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Container(
    //                   width: 60,
    //                   height: double.infinity,
    //                   decoration: BoxDecoration(
    //                       color: backgroundColor,
    //                       borderRadius: BorderRadius.circular(5),
    //                       image: DecorationImage(
    //                         image: NetworkImage(
    //                             "https://projectinception.000webhostapp.com/images/${searchResults[index]["image"]}"),
    //                         fit: BoxFit.cover,
    //                       )),
    //                 ),
    //               ),
    //               const SizedBox(width: 5),
    //               Expanded(
    //                 child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Text(searchResults[index]["title"],
    //                               style: bodyStyle),
    //                         ],
    //                       ),
    //                       const SizedBox(height: 4),
    //                       Row(
    //                         children: [
    //                           searchResults[index]["subtitle"] != null
    //                               ? Text(searchResults[index]["subtitle"],
    //                               style: subBodyStyle)
    //                               : const SizedBox(),
    //                         ],
    //                       ),
    //                     ]),
    //               ),
    //               IconButton(
    //                   onPressed: () {
    //                     showModalBottomSheet(
    //                         context: context,
    //                         builder: (context) {
    //                           return Wrap(
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.all(16.0),
    //                                 child: ListTile(
    //                                     title: Row(
    //                                       children: [
    //                                         Container(
    //                                           width: 40,
    //                                           height: 40,
    //                                           decoration: BoxDecoration(
    //                                               borderRadius:
    //                                               BorderRadius.circular(5),
    //                                               image: DecorationImage(
    //                                                 image: AssetImage(
    //                                                     "images/${searchResults[index]["image"]}"),
    //                                                 fit: BoxFit.cover,
    //                                               )),
    //                                         ),
    //                                         SizedBox(width: 25.0),
    //                                         Column(
    //                                           crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text(searchResults[index]["title"],
    //                                                 style: bodyStyle),
    //                                             SizedBox(height: 5.0),
    //                                             searchResults[index]["subtitle"] !=
    //                                                 null
    //                                                 ? Text(
    //                                                 searchResults[index]
    //                                                 ["subtitle"],
    //                                                 style: subBodyStyle)
    //                                                 : const SizedBox(),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     )),
    //                               ),
    //                               const Divider(color: textColor, height: 0.3),

    //                               InkWell(
    //                                 onTap: () {
    //                                   showDialog(
    //                                       context: context,
    //                                       builder: (context) {
    //                                         return AlertDialog(
    //                                           title: const Text('Details'),
    //                                           content: SizedBox(
    //                                             height:
    //                                             MediaQuery.of(context)
    //                                                 .size
    //                                                 .height /
    //                                                 2,
    //                                             child: Column(
    //                                               children: [
    //                                                 Row(
    //                                                   children: [
    //                                                     Column(
    //                                                       crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                       children: [
    //                                                         Text(
    //                                                           'Name:',
    //                                                           style: bodyStyle.copyWith(
    //                                                               fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             height:
    //                                                             2.0),
    //                                                         Text(
    //                                                             searchResults[index]
    //                                                             [
    //                                                             'title'],
    //                                                             style:
    //                                                             bodyStyle)
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                     height: 10.0),
    //                                                 Row(
    //                                                   children: [
    //                                                     Column(
    //                                                       crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                       children: [
    //                                                         Text(
    //                                                           isArchive
    //                                                               ? 'Description:'
    //                                                               : 'Author:',
    //                                                           style: bodyStyle.copyWith(
    //                                                               fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             height:
    //                                                             2.0),
    //                                                         SizedBox(
    //                                                           width: 230.0,
    //                                                           child: searchResults[index]
    //                                                           [
    //                                                           "description"] !=
    //                                                               null
    //                                                               ? Text(
    //                                                               searchResults[index]
    //                                                               [
    //                                                               'description'],
    //                                                               style:
    //                                                               bodyStyle)
    //                                                               : const SizedBox(),
    //                                                         )
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                     height: 10.0),
    //                                                 Row(
    //                                                   children: [
    //                                                     Column(
    //                                                       crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                       children: [
    //                                                         Text(
    //                                                           'Size:',
    //                                                           style: bodyStyle.copyWith(
    //                                                               fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             height:
    //                                                             2.0),
    //                                                         Text(
    //                                                             searchResults[index]
    //                                                             [
    //                                                             'size'] +
    //                                                                 'kb',
    //                                                             style:
    //                                                             bodyStyle)
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                     height: 10.0),
    //                                                 Row(
    //                                                   children: [
    //                                                     Column(
    //                                                       crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                       children: [
    //                                                         Text(
    //                                                           'Date Uploaded:',
    //                                                           style: bodyStyle.copyWith(
    //                                                               fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             height:
    //                                                             2.0),
    //                                                         Text(
    //                                                             searchResults[index]
    //                                                             [
    //                                                             'upload'],
    //                                                             style:
    //                                                             bodyStyle)
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 const SizedBox(
    //                                                     height: 10.0),
    //                                                 Row(
    //                                                   children: [
    //                                                     Column(
    //                                                       crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                       children: [
    //                                                         Text(
    //                                                           'Category:',
    //                                                           style: bodyStyle.copyWith(
    //                                                               fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                         ),
    //                                                         const SizedBox(
    //                                                             height:
    //                                                             2.0),
    //                                                         Text(
    //                                                             searchResults[index]
    //                                                             [
    //                                                             'category'],
    //                                                             style:
    //                                                             bodyStyle)
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           actions: [
    //                                             TextButton(
    //                                                 onPressed: () {
    //                                                   Navigator.of(context)
    //                                                       .pop();
    //                                                 },
    //                                                 child: const Text('Done'))
    //                                           ],
    //                                         );
    //                                       });
    //                                 },
    //                                 child: const ListTile(
    //                                   leading:
    //                                   Icon(Icons.info_outline_rounded),
    //                                   title: Text(
    //                                     'Details',
    //                                     style: bodyStyle,
    //                                   ),
    //                                 ),
    //                               ),
    //                               InkWell(
    //                                 onTap: () {},
    //                                 child: const ListTile(
    //                                   leading: Icon(
    //                                       Icons.favorite_border_outlined),
    //                                   title: Text(
    //                                     'Add to favorites',
    //                                     style: bodyStyle,
    //                                   ),
    //                                 ),
    //                               ),
    //                               InkWell(
    //                                 onTap: () {},
    //                                 child: const ListTile(
    //                                   leading: Icon(Icons
    //                                       .download_for_offline_outlined),
    //                                   title: Text(
    //                                     'Save for offline',
    //                                     style: bodyStyle,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           );
    //                         });
    //                   },
    //                   icon: const Icon(
    //                     Icons.more_vert,
    //                     color: secondaryColor,
    //                   ))
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}

class ExplorePageWidget extends StatefulWidget {
  const ExplorePageWidget({Key? key}) : super(key: key);

  @override
  State<ExplorePageWidget> createState() => _ExplorePageWidgetState();
}

class _ExplorePageWidgetState extends State<ExplorePageWidget>
    with SingleTickerProviderStateMixin {
  bool isset = false;
  bool isLoad = true;
  late List book;
  late List note;
  late Future bookFuture;
  late TabController tabController;

  Future loadBooks() async {
    print('book loading');
    var url = Uri.parse('https://projectinception.000webhostapp.com/get.php');
    var response = await http.post(url, body: {
      'sql': "SELECT * FROM Books WHERE category = 'Book'",
    });

    var result = await http.post(url, body: {
      'sql': "SELECT * FROM Books WHERE category = 'Note'",
    });

    if (response.statusCode != 200 && result.statusCode != 200) {
      throw ('error');
    } else {
      book = jsonDecode(response.body);
      print(book);
      note = jsonDecode(result.body);
      print(note);
    }

    return 1;
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    bookFuture = loadBooks();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isArchive = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'E-Library',
          style: appBarStyle,
        ),
        bottom: TabBar(
          controller: tabController,
          labelStyle: tabLabelStyle,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                  child: Text('Books'),
                )),
            Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.0,
                  ),
                  child: Text('Lecture Notes'),
                )),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search),
              iconSize: 25),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsPageWidget();
                }));
              },
              icon: const Icon(Icons.settings),
              iconSize: 25),
          const SizedBox(width: 15.0)
        ],
      ),
      floatingActionButton: isLoad
          ? null
          : FloatingActionButton(
              onPressed: () {
                bookFuture = loadBooks();
                setState(() {});
              },
              child: Icon(Icons.refresh),
              backgroundColor: primaryColor,
            ),
      body: FutureBuilder(
        future: bookFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isLoad = false;
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        book.isEmpty
                            ? Center(
                                child: Text('No Books Yet',
                                    style: subBodyStyle.copyWith(
                                        color: textColor)),
                              )
                            : NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return <Widget>[
                                    SliverAppBar(
                                      backgroundColor: backgroundColor,
                                      foregroundColor: Colors.black87,
                                      automaticallyImplyLeading: false,
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text('New Books'),
                                      ),
                                      bottom: PreferredSize(
                                          preferredSize:
                                              const Size.fromHeight(140),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 20.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150.0,
                                            child: ListView.builder(
                                                itemCount: 6,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Map<String, dynamic> map =
                                                          book[index];
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ReadBufferPage(
                                                            book: map);
                                                      }));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          height: 110,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.3),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    'https://projectinception.000webhostapp.com/images/${book[index]['image']}'),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
// child: Image(image: AssetImage('images/land1'),),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            book[index]
                                                                ['title'],
                                                            style: bodyStyle,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            book[index]
                                                                ['subtitle'],
                                                            style: subBodyStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          )),
                                    ),
                                  ];
                                },
                                body: Container(
                                  margin:
                                      EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Book Shelf',
                                            style: bodyStyle.copyWith(
                                                fontSize: 19),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                isset = !isset;
                                                setState(() {});
                                              },
                                              icon: Icon(!isset
                                                  ? Icons.grid_view_sharp
                                                  : Icons.list_sharp))
                                        ],
                                      ),
                                      isset
                                          ? GridViewCard(myList: book)
                                          : ListViewCard(myList: book),
                                    ],
                                  ),
                                )),
                        note.isEmpty
                            ? Center(
                                child: Text('No Notes Yet',
                                    style: subBodyStyle.copyWith(
                                        color: textColor)),
                              )
                            : NestedScrollView(
                                headerSliverBuilder: (BuildContext context,
                                    bool innerBoxIsScrolled) {
                                  return <Widget>[
                                    SliverAppBar(
                                      backgroundColor: backgroundColor,
                                      foregroundColor: Colors.black87,
                                      automaticallyImplyLeading: false,
                                      title: const Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text('Latest Notes'),
                                      ),
                                      bottom: PreferredSize(
                                          preferredSize: Size.fromHeight(140),
                                          child: Container(
                                            margin: EdgeInsets.only(left: 20.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150.0,
                                            child: ListView.builder(
                                                itemCount: 6,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Map<String, dynamic> map =
                                                          note[index];
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ReadBufferPage(
                                                            book: map);
                                                      }));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          height: 110,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.6,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.3),
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/${note[index]['image']}'),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            note[index]
                                                                ['title'],
                                                            style: bodyStyle,
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            note[index]
                                                                ['subtitle'],
                                                            style: subBodyStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          )),
                                    ),
                                  ];
                                },
                                body: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Lecture Notes',
                                            style: bodyStyle.copyWith(
                                                fontSize: 19),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                isset = !isset;
                                                setState(() {});
                                              },
                                              icon: Icon(!isset
                                                  ? Icons.grid_view_sharp
                                                  : Icons.list_sharp))
                                        ],
                                      ),
                                      isset
                                          ? GridViewCard(myList: note)
                                          : ListViewCard(myList: note),
                                    ],
                                  ),
                                )),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text("An Error Occurred", style: bodyStyle)),
                  TextButton(
                    onPressed: () {
                      bookFuture = loadBooks();
                      setState(() {});
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(80, 30)),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    child: Text(
                      'Retry',
                      style: bodyStyle.copyWith(color: Colors.white),
                    ),
                  )
                ]);
          } else {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
        },
      ),
    );
  }
}

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  bool isObscure = true;
  bool confirmPassError = false;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  String? username;

  changePassword() async {
    if (newPasswordController.text == confirmPasswordController.text) {
      confirmPassError = false;
      var url =
          Uri.parse('https://projectinception.000webhostapp.com/update.php');

      var response = await http.post(url, body: {
        'sql':
            "UPDATE user SET password = '${newPasswordController.text}' WHERE matric = '$username' "
      });
      if (response.statusCode == 200) {
        newPasswordController.clear();
        confirmPasswordController.clear();
        Navigator.of(context).pop();
      }
    } else {
      confirmPassError = true;
      setState(() {});
    }
  }

  readSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
  }

  deleteSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
  }

  @override
  void initState() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          title: const Text(
            'Settings',
            style: appBarStyle,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 24.0),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 2.0,
                    child: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.5),
                      foregroundImage: AssetImage('images/blackmale.jpg'),
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 30),
                      child: Column(
                        children: [
                          Text(
                            'Lorem Ipsum',
                            style: bodyStyle,
                          ),
                          Text(
                            'Ks/12/2022',
                            style: bodyStyle,
                          ),
                          Text(
                            '100 level',
                            style: userSubnameStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          deleteSF();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(160, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor)),
                        child: const Text(
                          'Log out',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: textColor))),
                        child: InkWell(
                          onTap: () {
                            readSF();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Change Password'),
                                    actionsPadding: EdgeInsets.all(0.0),
                                    content: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      child: ListView(children: [
                                        confirmPassError
                                            ? Text(
                                                'The two passwords you entered are not the same',
                                                style: bodyStyle.copyWith(
                                                    color: Colors.red))
                                            : SizedBox(),
                                        TextField(
                                            controller: newPasswordController,
                                            decoration: InputDecoration(
                                                labelText: 'New Password')),
                                        TextField(
                                            controller:
                                                confirmPasswordController,
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Confirm New Password')),
                                      ]),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            changePassword();
                                          },
                                          child: Text('submit',
                                              style: TextStyle(
                                                  color: primaryColor)))
                                    ],
                                  );
                                });
                          },
                          splashColor: primaryColor.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Change Password',
                                      style: bodyStyle,
                                    ),
                                  ],
                                ),
                                Material(
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(50),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    size: 35,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SettingsOption(
                        title: 'Contact Support',
                        subtitle: 'FAQ, Helpdesk',
                      ),
                      SettingsOption(
                        title: 'App Version',
                        subtitle: '1.21.1',
                      ),
                      SettingsOption(
                        title: 'Legal Information',
                        subtitle: 'T&Cs, Licenses',
                      ),
                      Divider(
                        color: textColor,
                        thickness: 1.0,
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ],
          ),
        ));
  }
}

class ArchiveTabIcon extends StatelessWidget {
  IconData icon;
  String? string;
  Color color;

  ArchiveTabIcon({required this.icon, required this.color, this.string});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 2.0),
            borderRadius: BorderRadius.circular(5.0)),
        width: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            icon,
            semanticLabel: string,
            size: 32,
            color: color,
          ),
        ));
  }
}

class GridViewCard extends StatefulWidget {
  final List myList;
  final String? image;

  GridViewCard({required this.myList, this.image});

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
                  Map<String, dynamic> map = myList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReadBufferPage(book: map);
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
                              image: image == null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          "https://projectinception.000webhostapp.com/images/${myList[index]["image"]}"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: AssetImage("images/$image"),
                                      fit: BoxFit.contain)),
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                myList[index]["title"],
                                style: bodyStyle.copyWith(fontSize: 16),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                                                    image: image == null
                                                        ? DecorationImage(
                                                            image: AssetImage(
                                                                "images/${myList[index]["image"]}"),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : DecorationImage(
                                                            image: AssetImage(
                                                                "images/$image"),
                                                            fit: BoxFit
                                                                .contain)),
                                              ),
                                              SizedBox(width: 25.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(myList[index]["title"],
                                                      style: bodyStyle),
                                                  SizedBox(height: 5.0),
                                                  myList[index]["subtitle"] !=
                                                          null
                                                      ? Text(
                                                          myList[index]
                                                              ["subtitle"],
                                                          style: subBodyStyle)
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ),
                                        Divider(color: textColor, height: 0.3),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Details'),
                                                    content: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
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
                                                                  Text(
                                                                      myList[index]
                                                                          [
                                                                          'title'],
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
                                                                    isArchive
                                                                        ? 'Description:'
                                                                        : 'Author:',
                                                                    style: bodyStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2.0),
                                                                  SizedBox(
                                                                    width:
                                                                        230.0,
                                                                    child: Text(
                                                                        myList[index]
                                                                            [
                                                                            'subtitle'],
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
                                                                      myList[index]
                                                                              [
                                                                              'size'] +
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
                                                          child: Text('Done'))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.info_outline_rounded),
                                            title: Text(
                                              'Details',
                                              style: bodyStyle,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.favorite_border_outlined),
                                            title: Text(
                                              'Add to favorites',
                                              style: bodyStyle,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: ListTile(
                                            leading: Icon(Icons
                                                .download_for_offline_outlined),
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
                            icon: Icon(Icons.more_vert),
                            color: secondaryColor,
                          )
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

  ListViewCard({required this.myList, this.image, this.height});

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
            search.add(myList[index]["title"]);
            return Card(
              elevation: 2.0,
              color: Colors.white,
              shadowColor: textColor.withOpacity(0.8),
              child: InkWell(
                onTap: () {
                  Map<String, dynamic> map = myList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReadBufferPage(book: map);
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
                              image: image == null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          "https://projectinception.000webhostapp.com/images/${myList[index]["image"]}"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: AssetImage("images/$image"),
                                      fit: BoxFit.contain)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(myList[index]["title"],
                                      style: bodyStyle),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  myList[index]["subtitle"] != null
                                      ? Text(myList[index]["subtitle"],
                                          style: subBodyStyle)
                                      : const SizedBox(),
                                ],
                              ),
                            ]),
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
                                                      BorderRadius.circular(5),
                                                  image: image == null
                                                      ? DecorationImage(
                                                          image: AssetImage(
                                                              "images/${myList[index]["image"]}"),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : DecorationImage(
                                                          image: AssetImage(
                                                              "images/$image"),
                                                          fit: BoxFit.contain)),
                                            ),
                                            SizedBox(width: 25.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(myList[index]["title"],
                                                    style: bodyStyle),
                                                SizedBox(height: 5.0),
                                                myList[index]["subtitle"] !=
                                                        null
                                                    ? Text(
                                                        myList[index]
                                                            ["subtitle"],
                                                        style: subBodyStyle)
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ),
                                      Divider(color: textColor, height: 0.3),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Details'),
                                                  content: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
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
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        2.0),
                                                                Text(
                                                                    myList[index]
                                                                        [
                                                                        'title'],
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
                                                                  isArchive
                                                                      ? 'Description:'
                                                                      : 'Author:',
                                                                  style: bodyStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        2.0),
                                                                SizedBox(
                                                                  width: 230.0,
                                                                  child: myList[index]
                                                                              [
                                                                              "description"] !=
                                                                          null
                                                                      ? Text(
                                                                          myList[index]
                                                                              [
                                                                              'description'],
                                                                          style:
                                                                              bodyStyle)
                                                                      : const SizedBox(),
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
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        2.0),
                                                                Text(
                                                                    myList[index]
                                                                            [
                                                                            'size'] +
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
                                                                          FontWeight
                                                                              .bold),
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
                                                                          FontWeight
                                                                              .bold),
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Done'))
                                                  ],
                                                );
                                              });
                                        },
                                        child: ListTile(
                                          leading:
                                              Icon(Icons.info_outline_rounded),
                                          title: Text(
                                            'Details',
                                            style: bodyStyle,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.favorite_border_outlined),
                                          title: Text(
                                            'Add to favorites',
                                            style: bodyStyle,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          leading: Icon(Icons
                                              .download_for_offline_outlined),
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
                          icon: Icon(
                            Icons.more_vert,
                            color: secondaryColor,
                          ))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SettingsOption extends StatefulWidget {
  //This is the Widget for multiple Options in the Settings Page
  final String title;
  final String? subtitle;

  // ignore: use_key_in_widget_constructors
  const SettingsOption({required this.title, this.subtitle});

  @override
  State<SettingsOption> createState() => _SettingsOptionState();
}

class _SettingsOptionState extends State<SettingsOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: textColor))),
      child: InkWell(
        onTap: () {},
        splashColor: primaryColor.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: bodyStyle,
                  ),
                  const SizedBox(height: 3),
                  widget.subtitle == null
                      ? const SizedBox()
                      : Text(
                          '${widget.subtitle}',
                          style: settingSubStyle,
                        ),
                ],
              ),
              Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(50),
                child: const Icon(
                  Icons.chevron_right,
                  size: 35,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
