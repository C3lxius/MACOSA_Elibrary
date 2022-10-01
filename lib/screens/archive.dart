import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_inception/screens/read_buffer.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class ArchiveTabIcon extends StatelessWidget {
  final Widget image;
  // Color color;

  const ArchiveTabIcon(
      {Key? key,
      // required this.color,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // decoration: BoxDecoration(
        //     border: Border.all(color: color, width: 2.0),
        //     borderRadius: BorderRadius.circular(5.0)),
        width: MediaQuery.of(context).size.width / 4,
        //todo: remove this padding
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: image,
          // Icon(
          //   icon,
          //   semanticLabel: string,
          //   size: 32,
          //   color: color,
          // ),
        ));
  }
}

class ArchivePageWidget extends StatefulWidget {
  const ArchivePageWidget({Key? key}) : super(key: key);

  @override
  State<ArchivePageWidget> createState() => _ArchivePageWidgetState();
}

class _ArchivePageWidgetState extends State<ArchivePageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late VideoPlayerController _videoController;
  void _onLoad() async {
    setState(() {
      imageLength += 10;
    });
  }

  late List audio;
  late List doc;
  late List image;
  late List video;
  late Future archiveFuture;
  int imageLength = 8;

  loadArchives() async {
    Uri url = Uri.parse('https://www.toopasty.com.ng/inception/get.php');
    var response1 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'audio'"});
    var response2 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'document'"});
    var response3 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'image'"});
    var response4 = await http.post(url,
        body: {'sql': "Select * from archives where category = 'video'"});

    if (response1.statusCode != 200 &&
        response2.statusCode != 200 &&
        response3.statusCode != 200 &&
        response4.statusCode != 200) {
      throw ('error');
    } else {
      audio = jsonDecode(response1.body);
      doc = [];
      image = jsonDecode(response3.body);
      video = []; //jsonDecode(response4.body);
    }

    return 1;
  }

  late AudioPlayer player;
  bool isPlaying = false;
  late String title = "${audio[0]['title']}";
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  void stop() async {
    position = Duration.zero;
    await player.release();
  }

  formatTime(Duration d) => d.toString().substring(2, 7);

  List books = [];

  @override
  void initState() {
    archiveFuture = loadArchives();
    player = AudioPlayer();
    player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    player.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });

    player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => isPlaying = s == PlayerState.playing);
    });

    // player.onPlayerComplete.listen((event) {
    //   player.release();
    //   setState(() {
    //     position = duration;
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    _videoController.dispose;
    super.dispose();
  }

  bool isset = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
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
            actions: const [
              //TODO: SearchBar
              // IconButton(
              //     onPressed: () {
              //       showSearch(context: context, delegate: MySearchDelegate());
              //     },
              //     icon: const Icon(Icons.search),
              //     iconSize: 25),
              SizedBox(width: 15.0)
            ],
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
            child: DefaultTabController(
                length: 4,
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool isScroll) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: backgroundColor,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(10),
                          child: TabBar(
                            labelStyle: tabLabelStyle,
                            unselectedLabelColor: textColor,
                            indicatorColor: primaryColor,
                            labelPadding:
                                const EdgeInsets.only(left: 2.0, right: 2.0),
                            tabs: [
                              ArchiveTabIcon(
                                  // color: lightTextColor,
                                  image: Image.asset('images/audio.png',
                                      height: 40, width: 60)),
                              ArchiveTabIcon(
                                  // color: primaryColor,
                                  image: Image.asset('images/folders.png',
                                      height: 40, width: 60)),
                              ArchiveTabIcon(
                                // color: const Color(0xFFE100C4),
                                image: Image.asset('images/image.png',
                                    height: 40, width: 60),
                              ),
                              ArchiveTabIcon(
                                // color: secondaryColor,
                                image: Image.asset('images/play.png',
                                    height: 40, width: 60),
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
                                      Row(children: [
                                        Text(
                                          'Audio Files',
                                          style:
                                              bodyStyle.copyWith(fontSize: 16),
                                        ),
                                      ]),
                                      const SizedBox(height: 10.0),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: audio.length,
                                            itemBuilder: (_, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    title =
                                                        "${audio[index]['title']}";
                                                  });
                                                  UrlSource url = UrlSource(
                                                      "https://www.toopasty.com.ng/inception/archives/audio/$title");
                                                  if (isPlaying) {
                                                    stop();
                                                    await player.play(url);
                                                  } else {
                                                    await player.play(url);
                                                  }
                                                },
                                                splashColor: primaryColor
                                                    .withOpacity(0.1),
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 50.0,
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: SizedBox(
                                                                width: 40,
                                                                height: double
                                                                    .infinity,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      "https://www.toopasty.com.ng/inception/res/waves.png",
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 2.2,
                                                                          child: Text(
                                                                              audio[index]["title"],
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: subBodyStyle),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ]),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Details'),
                                                                          content:
                                                                              SizedBox(
                                                                            height:
                                                                                MediaQuery.of(context).size.height / 2,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Name:',
                                                                                          style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(height: 2.0),
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context).size.width / 1.6,
                                                                                          child: Text(audio[index]['title'], softWrap: true, style: bodyStyle),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 10.0),
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Description:',
                                                                                          style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(height: 2.0),
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context).size.width / 1.6,
                                                                                          child: Text(audio[index]['description'], style: bodyStyle),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 10.0),
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Size:',
                                                                                          style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(height: 2.0),
                                                                                        Text(audio[index]['size'] + 'mb', style: bodyStyle)
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 10.0),
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Date Uploaded:',
                                                                                          style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(height: 2.0),
                                                                                        Text(audio[index]['upload'], style: bodyStyle)
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 10.0),
                                                                                Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Category:',
                                                                                          style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(height: 2.0),
                                                                                        Text(audio[index]['category'], style: bodyStyle)
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
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  color:
                                                                      textColor,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),

                                      // The Hovering Playing Audio Card
                                      Card(
                                        elevation: 30.0,
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 5.0),
                                            SizedBox(
                                              height: 50.0,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: double.infinity,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://www.toopasty.com.ng/inception/res/waves.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.2,
                                                                child: Text(
                                                                    title,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style:
                                                                        subBodyStyle),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 5.0),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.2,
                                                                child: Text(
                                                                    formatTime(
                                                                        position)),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        UrlSource url = UrlSource(
                                                            "https://www.toopasty.com.ng/inception/archives/audio/$title");
                                                        if (isPlaying) {
                                                          await player.pause();
                                                        } else {
                                                          await player
                                                              .play(url);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2.0),
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              primaryColor,
                                                          foregroundColor:
                                                              backgroundColor,
                                                          child: isPlaying
                                                              ? const Icon(
                                                                  Icons.pause,
                                                                  size: 25)
                                                              : const Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 25),
                                                        ),
                                                      )),
                                                  const SizedBox(width: 5.0),
                                                  InkWell(
                                                    onTap: () {
                                                      stop();
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          primaryColor,
                                                      child: Icon(Icons.stop,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                          ],
                                        ),
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Documents',
                                              style: bodyStyle.copyWith(
                                                  fontSize: 19),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: doc.length,
                                            itemBuilder: (_, index) {
                                              return Container(
                                                color: Colors.white,
                                                child: InkWell(
                                                  onTap: () {
                                                    bool isDownloaded = false;
                                                    Map<String, dynamic> map =
                                                        doc[index];
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return ReadBufferPage(
                                                          book: map,
                                                          isDownloaded:
                                                              isDownloaded);
                                                    }));
                                                  },
                                                  splashColor: primaryColor
                                                      .withOpacity(0.1),
                                                  child: SizedBox(
                                                    height: 80.0,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: SizedBox(
                                                              width: 100,
                                                              height: double
                                                                  .infinity,
                                                              child: Image.asset(
                                                                  'images/document.png')),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2.2,
                                                                      child: Text(
                                                                          doc[index]
                                                                              [
                                                                              "title"],
                                                                          softWrap:
                                                                              true,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style:
                                                                              subBodyStyle),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                              ]),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Details'),
                                                                      content:
                                                                          SizedBox(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                2,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Name:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.6,
                                                                                      child: Text(doc[index]['title'], softWrap: true, style: bodyStyle),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Description:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.6,
                                                                                      child: Text(doc[index]['description'], style: bodyStyle),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Size:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(doc[index]['size'] + 'kb', style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Date Uploaded:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(doc[index]['upload'], style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Category:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(doc[index]['category'], style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Done'))
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .info_outline,
                                                              color: textColor,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                            image.isEmpty
                                ? Center(
                                    child: Text('No Images yet',
                                        style: subBodyStyle.copyWith(
                                            color: textColor)))
                                : Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    height: MediaQuery.of(context).size.height,
                                    child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 160,
                                          mainAxisExtent: 80,
                                          crossAxisSpacing: 2.0,
                                        ),
                                        itemCount: image.length,
                                        itemBuilder: (_, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Gallery(
                                                  image: image,
                                                  index: index,
                                                );
                                              }));
                                            },
                                            onLongPress: () {
                                              // TODO: add alertdialog to each image
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://www.toopasty.com.ng/inception/archives/low/${image[index]['title']}",
                                              memCacheWidth: 1170,
                                              memCacheHeight: 1040,
                                            ),
                                          );
                                        }),
                                  ),
                            video.isEmpty
                                ? Center(
                                    child: Text('No Videos yet',
                                        style: subBodyStyle.copyWith(
                                            color: textColor)))
                                : Column(
                                    children: [
                                      const SizedBox(height: 10.0),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: video.length,
                                            itemBuilder: (_, index) {
                                              return Container(
                                                color: Colors.white,
                                                child: InkWell(
                                                  onTap: () {
                                                    _videoController =
                                                        VideoPlayerController
                                                            .network(
                                                                "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
                                                    _videoController
                                                        .addListener(() {
                                                      setState(() {});
                                                    });
                                                    _videoController
                                                        .setLooping(true);
                                                    _videoController
                                                        .initialize()
                                                        .then((_) =>
                                                            _videoController
                                                                .play());

                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return Video(
                                                          controller:
                                                              _videoController);
                                                    }));
                                                  },
                                                  splashColor: primaryColor
                                                      .withOpacity(0.1),
                                                  child: SizedBox(
                                                    height: 80.0,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Container(
                                                            width: 100,
                                                            height:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        backgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    image:
                                                                        const DecorationImage(
                                                                      image: CachedNetworkImageProvider(
                                                                          "https://www.toopasty.com.ng/inception/images/thumb2.JPG"),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                            child: const Icon(
                                                              Icons.play_circle,
                                                              color: Colors
                                                                  .white38,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2.2,
                                                                      child: Text(
                                                                          video[index]
                                                                              [
                                                                              "title"],
                                                                          softWrap:
                                                                              true,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style:
                                                                              subBodyStyle),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                              ]),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Details'),
                                                                      content:
                                                                          SizedBox(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                2,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Name:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.6,
                                                                                      child: Text(video[index]['title'], softWrap: true, style: bodyStyle),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Description:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.6,
                                                                                      child: Text(video[index]['description'], style: bodyStyle),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Size:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(video[index]['size'] + 'kb', style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Date Uploaded:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(video[index]['upload'], style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10.0),
                                                                            Row(
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      'Category:',
                                                                                      style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    const SizedBox(height: 2.0),
                                                                                    Text(video[index]['category'], style: bodyStyle)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Done'))
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .info_outline,
                                                              color: textColor,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryColor)),
                                child: Text(
                                  'Retry',
                                  style:
                                      bodyStyle.copyWith(color: Colors.white),
                                ),
                              )
                            ]);
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      }
                    },
                  ),
                )),
          )),
    );
  }
}
