import 'package:flutter/material.dart';
import 'package:project_inception/screens/read.dart';
import 'package:project_inception/utilities/constants.dart';

class ReadBufferPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final book;
  const ReadBufferPage({Key? key, required this.book}) : super(key: key);

  @override
  _ReadBufferPageState createState() => _ReadBufferPageState();
}

class _ReadBufferPageState extends State<ReadBufferPage> {
  late Map<String, dynamic> book;

  @override
  void initState() {
    book = widget.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          book['title'],
          style: appBarStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://projectinception.000webhostapp.com/images/${book['image']}'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(15)),
                ),
                const SizedBox(width: 16.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(book['title'], style: bodyStyle),
                  const SizedBox(height: 8.0),
                  book['subtitle'] != null
                      ? Text(book['subtitle'],
                          style: subBodyStyle.copyWith(color: textColor))
                      : const SizedBox(),
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
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Read(title: book['title']);
                        }));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      child: Text(
                        'Read',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      child: Text(
                        'Download',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {},
                  //     iconSize: 25,
                  //     icon: Icon(
                  //       Icons.download_outlined,
                  //       color: textColor.withOpacity(0.8),
                  //     )),
                  // IconButton(
                  //     onPressed: () {},
                  //     iconSize: 32,
                  //     icon: Icon(
                  //       Icons.favorite_outline,
                  //       color: secondaryColor.withOpacity(0.8),
                  //     ))
                ]),
            const SizedBox(height: 8.0),
            const Text('Description', style: bodyStyle),
            const SizedBox(height: 8.0),
            Text(
              book['description'] ??
                  'Lorem Ipsum dolor amet syncua dolor Lorem Ipsum dolor amet syncua dolor Lorem Ipsum dolor amet syncua dolor...'
                      "Lorem Ipsum dolor amet syncua dolor Lorem Ipsum dolor amet syncua dolor Lorem Ipsum dolor amet syncua dolor..."
                      'Lorem Ipsum dolor amet syncua dolor Lorem Ipsum dolor ',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            const Text('Comments', style: bodyStyle),
            Expanded(
              child: Center(
                  child: Text(
                'No comments yet...',
                style: subBodyStyle.copyWith(color: textColor),
              )),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Enter Comment here...',
                  labelStyle: const TextStyle(color: lightTextColor),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    iconSize: 24,
                    color: primaryColor,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: lightTextColor.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }
}
