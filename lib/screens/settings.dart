import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'login.dart';

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
  late String matric;
  late String name;
  late String level;
  late Future sfFuture;

  changePassword() async {
    if (newPasswordController.text == confirmPasswordController.text) {
      confirmPassError = false;
      var url = Uri.parse('https://www.toopasty.com.ng/inception/update.php');

      var response = await http.post(url, body: {
        'sql':
            "UPDATE user SET password = '${newPasswordController.text}' WHERE matric = '$matric' "
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
    matric = prefs.getString('matric')!;
    name = prefs.getString('name')!;
    level = prefs.getString('level')!;
    return 1;
  }

  deleteSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('matric');
    prefs.remove('name');
    prefs.remove('level');
  }

  void openWhatsapp() async {
    Uri whatsApp = Uri(
        scheme: 'whatsapp',
        host: 'send',
        queryParameters: {'phone': '2348148816611', 'text': 'Hello'});
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(whatsApp)) {
        await launchUrl(whatsApp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("WhatsApp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsApp)) {
        await launchUrl(whatsApp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("WhatsApp not installed")));
      }
    }
  }

  @override
  void initState() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    sfFuture = readSF();
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
            children: [
              Column(
                children: [
                  const SizedBox(height: 24.0),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    elevation: 2.0,
                    child: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.5),
                      foregroundImage: const AssetImage('images/tums.jpg'),
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
                      child: FutureBuilder(
                          future: sfFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Text(
                                    name,
                                    style: bodyStyle,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    matric,
                                    style: bodyStyle.copyWith(
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '$level level',
                                    style: userSubnameStyle,
                                  )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Column(
                                children: const [
                                  Text(
                                    'Name',
                                    style: bodyStyle,
                                  ),
                                  Text(
                                    'Matric',
                                    style: bodyStyle,
                                  ),
                                  Text(
                                    'Level',
                                    style: userSubnameStyle,
                                  )
                                ],
                              );
                            } else {
                              return const CircularProgressIndicator(
                                  color: primaryColor);
                            }
                          }),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          deleteSF();
                          isLoggedIn = null;
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Login();
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: textColor))),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Change Password'),
                                    actionsPadding: const EdgeInsets.all(0.0),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      child: ListView(children: [
                                        confirmPassError
                                            ? Text(
                                                'The two passwords you entered are not the same',
                                                style: bodyStyle.copyWith(
                                                    color: Colors.red))
                                            : const SizedBox(),
                                        TextField(
                                            controller: newPasswordController,
                                            decoration: const InputDecoration(
                                                labelText: 'New Password')),
                                        TextField(
                                            controller:
                                                confirmPasswordController,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Confirm New Password')),
                                      ]),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            changePassword();
                                          },
                                          child: const Text('submit',
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
                                  children: const [
                                    Text(
                                      'Change Password',
                                      style: bodyStyle,
                                    ),
                                  ],
                                ),
                                const Icon(
                                  FontAwesomeIcons.unlockKeyhole,
                                  color: textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: textColor))),
                        child: InkWell(
                          onTap: () async {
                            Uri whatsApp = Uri(
                                scheme: 'whatsapp',
                                host: 'send',
                                queryParameters: {
                                  'phone': '2348148816611',
                                  'text': //todo: fix this
                                      'Hey baby, here\'s some boob pics...'
                                });

                            if (await canLaunchUrl(whatsApp)) {
                              await launchUrl(whatsApp);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("WhatsApp not installed")));
                            }
                          },
                          splashColor: primaryColor.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      //Todo: fix this
                                      'Contact Lover💕',
                                      style: bodyStyle,
                                    ),
                                  ],
                                ),
                                const Icon(
                                  FontAwesomeIcons.rocketchat,
                                  color: textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: textColor))),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("App Version 1.0.0"),
                              behavior: SnackBarBehavior.floating,
                            ));
                          },
                          splashColor: primaryColor.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'App Version',
                                        style: bodyStyle,
                                      )
                                    ]),
                                const Icon(
                                  FontAwesomeIcons.code,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: textColor),
                                bottom: BorderSide(color: textColor))),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("T&C's Apply"),
                              behavior: SnackBarBehavior.floating,
                            ));
                          },
                          splashColor: primaryColor.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Legal Information',
                                        style: bodyStyle,
                                      )
                                    ]),
                                const Icon(
                                  FontAwesomeIcons.scaleUnbalanced,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
