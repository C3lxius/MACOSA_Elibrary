import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_inception/screens/home.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:project_inception/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  checkSF() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('matric')) {
      isLoggedIn = 1;
    } else {
      isLoggedIn = null;
    }
  }

  late File jsonFile;
  String fileName = 'downloads.json';
  bool fileExists = false;

  checkFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    jsonFile = File(dir.path + '/' + fileName);
    fileExists = await jsonFile.exists();
    if (fileExists) {
      tempDownload = json.decode(await jsonFile.readAsString());
    } else if (!fileExists) {
      // jsonFile.create();
      tempDownload = [];
      // tempDownload.add(downloads);
      jsonFile.writeAsString(jsonEncode(tempDownload));
      fileExists = await jsonFile.exists();
    }
  }

  Random random = Random();
  late int randomNumber;

  @override
  void initState() {
    randomNumber = random.nextInt(3);
    checkSF();
    checkFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.circular(20)),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.luminosity),
                    image: AssetImage('images/land$randomNumber.jpg'),
                    fit: BoxFit.cover),
              ),
              // margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: secondaryColor)),
                    ),
                    onPressed: () {
                      isLoggedIn == 1
                          ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return Explore();
                            }))
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return const Login();
                            }));
                    },
                    child: const Text(
                      'skip >>',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: Material(
                color: Colors.white.withOpacity(0.0),
                elevation: 2.0,
                shadowColor: secondaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 40,
                    ),
                    const Flexible(
                      child: Text(
                        '  MACOSA E-Library',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Read, Learn, Explore...',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(160, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          onPressed: () {
                            isLoggedIn == 1
                                ? Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return Explore();
                                  }))
                                : Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                    return const Login();
                                  }));
                          },
                          child: const Text(
                            'Start Reading',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
