import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_inception/screens/read_buffer.dart';
import 'package:project_inception/screens/settings.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExplorePageWidget extends StatefulWidget {
  const ExplorePageWidget({Key? key}) : super(key: key);

  @override
  State<ExplorePageWidget> createState() => _ExplorePageWidgetState();
}

class _ExplorePageWidgetState extends State<ExplorePageWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  bool isLoad = true;
  late List book;
  late List note;
  late Future bookFuture;
  late TabController tabController;

  Future loadBooks() async {
    var url = Uri.parse('https://www.toopasty.com.ng/inception/get.php');
    var response = await http.post(url, body: {
      'sql': "SELECT * FROM book WHERE category = 'book'",
    });

    var result = await http.post(url, body: {
      'sql': "SELECT * FROM book WHERE category = 'note'",
    });

    if (response.statusCode != 200 && result.statusCode != 200) {
      throw ('error');
    } else {
      book = jsonDecode(response.body);
      note = jsonDecode(result.body);
    }
    addToSearch();
    return 1;
  }

  void addToSearch() {
    for (int i = 0; i < book.length && i < note.length; i++) {
      if (book[i].containsKey("title") || note[i].containsKey("title")) {
        search.add(book[i]['title'].toString().toLowerCase());
        search.add(note[i]['title'].toString().toLowerCase());
      }
    }
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
    super.build(context);
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
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                  child: Text('Lecture Notes', style: bodyStyle),
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.0,
                  ),
                  child: Text('Books', style: bodyStyle),
                )),
          ],
        ),
        actions: [
          //TODO: SearchBar
          // IconButton(
          //     onPressed: () {
          //       showSearch(context: context, delegate: MySearchDelegate());
          //     },
          //     icon: const Icon(Icons.search),
          //     iconSize: 25),
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
          : SizedBox(
              height: 40,
              width: 40,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    bookFuture = loadBooks();
                    setState(() {});
                  },
                  child: const Icon(Icons.refresh),
                  backgroundColor: primaryColor,
                ),
              ),
            ),
      body: FutureBuilder(
        future: bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text('Most Popular',
                                              style: bodyStyle.copyWith(
                                                  fontSize: 18)),
                                        ),
                                        bottom: PreferredSize(
                                            preferredSize:
                                                const Size.fromHeight(160),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 180.0,
                                              child: ListView.builder(
                                                  itemCount: 3,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (_, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        bool isDownloaded =
                                                            findDownload(
                                                                tempDownload,
                                                                note[index]
                                                                    ['title']);
                                                        Map<String, dynamic>
                                                            map = note[index];
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return ReadBufferPage(
                                                              book: map,
                                                              isDownloaded:
                                                                  isDownloaded);
                                                        }));
                                                      },
                                                      onLongPress: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Wrap(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: ListTile(
                                                                        title: Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              image: DecorationImage(
                                                                                image: CachedNetworkImageProvider("https://toopasty.com.ng/inception/images/${note[index]["image"]}"),
                                                                                fit: BoxFit.cover,
                                                                              )),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                25.0),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                              //removing the ".pdf" at the end of each book
                                                                              child: Text(note[index]["title"].substring(0, note[index]["title"].length - 4), softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2, style: bigBodyStyle),
                                                                            ),
                                                                            const SizedBox(height: 5.0),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                              child: Text(note[index]["author"], softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1, style: subBodyStyle),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                  const Divider(
                                                                      color:
                                                                          textColor,
                                                                      height:
                                                                          0.3),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: const Text('Details'),
                                                                              content: SizedBox(
                                                                                height: MediaQuery.of(context).size.height / 2,
                                                                                child: Column(
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
                                                                                              child: Text(note[index]["title"].substring(0, note[index]["title"].length - 4), softWrap: true, style: bodyStyle),
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
                                                                                              'Author:',
                                                                                              style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            const SizedBox(height: 2.0),
                                                                                            SizedBox(
                                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                                              child: Text(note[index]['author'], style: bodyStyle),
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
                                                                                              child: Text(note[index]['description'], style: bodyStyle),
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
                                                                                            Text(note[index]['size'] + 'kb', style: bodyStyle)
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
                                                                                            Text(note[index]['upload'], style: bodyStyle)
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
                                                                                            Text(note[index]['category'], style: bodyStyle)
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
                                                                    child:
                                                                        const ListTile(
                                                                      leading: Icon(
                                                                          FontAwesomeIcons
                                                                              .circleInfo,
                                                                          color:
                                                                              Colors.black54),
                                                                      title:
                                                                          Text(
                                                                        'Details',
                                                                        style:
                                                                            bodyStyle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const ListTile(
                                                                      leading: Icon(
                                                                          FontAwesomeIcons
                                                                              .download,
                                                                          color:
                                                                              Colors.black54),
                                                                      title:
                                                                          Text(
                                                                        'Save for offline',
                                                                        style:
                                                                            bodyStyle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Card(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                              height: 110,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.6,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        'https://www.toopasty.com.ng/inception/images/${note[index]['image']}'),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          2.0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                note[index][
                                                                        "title"]
                                                                    .substring(
                                                                        0,
                                                                        note[index]["title"].length -
                                                                            4),
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    bodyStyle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                        const SizedBox(height: 10.0),
                                        Text(
                                          'Notes',
                                          style:
                                              bodyStyle.copyWith(fontSize: 18),
                                        ),
                                        const SizedBox(height: 6.0),
                                        ListViewCard(myList: note),
                                      ],
                                    ),
                                  )),
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
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text('Most Popular',
                                              style: bodyStyle.copyWith(
                                                  fontSize: 18)),
                                        ),
                                        bottom: PreferredSize(
                                            preferredSize:
                                                const Size.fromHeight(150),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160.0,
                                              child: ListView.builder(
                                                  itemCount: 3,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (_, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        bool isDownloaded =
                                                            findDownload(
                                                                tempDownload,
                                                                book[index]
                                                                    ['title']);
                                                        Map<String, dynamic>
                                                            map = book[index];
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return ReadBufferPage(
                                                              book: map,
                                                              isDownloaded:
                                                                  isDownloaded);
                                                        }));
                                                      },
                                                      onLongPress: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Wrap(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child: ListTile(
                                                                        title: Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              image: DecorationImage(
                                                                                image: CachedNetworkImageProvider("https://toopasty.com.ng/inception/images/${book[index]["image"]}"),
                                                                                fit: BoxFit.cover,
                                                                              )),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                25.0),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                              child: Text(book[index]["title"].substring(0, book[index]["title"].length - 4), softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 2, style: bigBodyStyle),
                                                                            ),
                                                                            const SizedBox(height: 5.0),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                              child: Text(book[index]["author"], softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1, style: subBodyStyle),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                  const Divider(
                                                                      color:
                                                                          textColor,
                                                                      height:
                                                                          0.3),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: const Text('Details'),
                                                                              content: SizedBox(
                                                                                height: MediaQuery.of(context).size.height / 2,
                                                                                child: Column(
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
                                                                                              child: Text(book[index]["title"].substring(0, book[index]["title"].length - 4), softWrap: true, style: bodyStyle),
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
                                                                                              'Author:',
                                                                                              style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            const SizedBox(height: 2.0),
                                                                                            SizedBox(
                                                                                              width: MediaQuery.of(context).size.width / 1.6,
                                                                                              child: Text(book[index]['author'], style: bodyStyle),
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
                                                                                              child: Text(book[index]['description'], style: bodyStyle),
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
                                                                                            Text(book[index]['size'] + 'kb', style: bodyStyle)
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
                                                                                            Text(book[index]['upload'], style: bodyStyle)
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
                                                                                            Text(book[index]['category'], style: bodyStyle)
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
                                                                    child:
                                                                        const ListTile(
                                                                      leading: Icon(
                                                                          FontAwesomeIcons
                                                                              .circleInfo,
                                                                          color:
                                                                              Colors.black54),
                                                                      title:
                                                                          Text(
                                                                        'Details',
                                                                        style:
                                                                            bodyStyle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const ListTile(
                                                                      leading: Icon(
                                                                          FontAwesomeIcons
                                                                              .download,
                                                                          color:
                                                                              Colors.black54),
                                                                      title:
                                                                          Text(
                                                                        'Save for offline',
                                                                        style:
                                                                            bodyStyle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Card(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                              height: 110,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.6,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        'https://www.toopasty.com.ng/inception/images/${book[index]['image']}'),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                book[index][
                                                                        "title"]
                                                                    .substring(
                                                                        0,
                                                                        book[index]["title"].length -
                                                                            4),
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    bodyStyle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )),
                                      ),
                                    ];
                                  },
                                  body: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10.0),
                                        Text(
                                          'Book Shelf',
                                          style:
                                              bodyStyle.copyWith(fontSize: 18),
                                        ),
                                        const SizedBox(height: 6.0),
                                        ListViewCard(myList: book),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
