import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_inception/screens/home.dart';
import 'package:project_inception/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController matricController;
  late TextEditingController passwordController;
  String errorMessage = '';

  void openWhatsapp() async {
    Uri whatsApp = Uri(scheme: 'whatsapp', host: 'send', queryParameters: {
      'phone': '2348148816611',
      'text': 'Hello, My Full Name and Matric Number is:'
    });

    if (await canLaunchUrl(whatsApp)) {
      await launchUrl(whatsApp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp not installed")));
    }
  }

  addStringToSF() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('matric', matricController.text);
  }

  Future login() async {
    String _matricController = matricController.text.trim().toLowerCase();
    String _passwordController = passwordController.text.trim().toLowerCase();

    if (_matricController.isEmpty || _passwordController.isEmpty) {
      errorMessage = 'Username and Password Required';
      setState(() {
        isLoading = false;
      });
    } else {
      var url = Uri.parse('https://toopasty.com.ng/inception/login.php');
      var response = await http.post(url, body: {
        'sql':
            "SELECT * FROM user WHERE matric = '$_matricController' AND password = '$_passwordController'",
      });

      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (data == 0) {
          errorShow = true;
          errorMessage = 'The Matric Number/Password is incorrect';
          isLoading = false;
          setState(() {});
        } else if (data == 1) {
          setState(() {
            errorShow = false;
            addStringToSF();
            isLoading = false;
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Explore();
          }));
        }
      } else {
        errorShow = true;
        errorMessage = 'Connection Error';
        isLoading = false;
        setState(() {});
      }
    }
  }

  bool isObscure = true;
  bool errorShow = false;
  bool isLoading = false;

  @override
  void initState() {
    matricController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    matricController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        title: const Text(
          'Log in',
          style: appBarStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(left: 50, top: 50, right: 50),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/logo.png'),
                        height: 90,
                      ),
                    ]),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: const [
                    Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      'Log in to continue',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                errorShow
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16.0),
                        ),
                      )
                    : const SizedBox(
                        height: 6.0,
                      ),
                const SizedBox(
                  height: 6.0,
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: matricController,
                        decoration: InputDecoration(
                            labelText: 'Enter Matric Number',
                            labelStyle: const TextStyle(color: lightTextColor),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: primaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: lightTextColor.withOpacity(0.6)),
                                borderRadius: BorderRadius.circular(4)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: passwordController,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                            labelText: 'Enter Password',
                            labelStyle: const TextStyle(color: lightTextColor),
                            prefixIcon:
                                const Icon(Icons.lock, color: primaryColor),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  isObscure = !isObscure;
                                  setState(() {});
                                },
                                icon: isObscure
                                    ? const Icon(Icons.visibility,
                                        color: primaryColor)
                                    : const Icon(Icons.visibility_off,
                                        color: primaryColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(4)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: lightTextColor.withOpacity(0.6)),
                                borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            color: primaryColor,
                            strokeWidth: 5,
                          )
                        : TextButton(
                            onPressed: () async {
                              // Login();
                              setState(() {
                                isLoading = true;
                              });
                              await login();
                            },
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    const Size(160, 50)),
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                            child: const Text(
                              'Log in',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: primaryColor,
                    ),
                    TextButton(
                        onPressed: () {
                          openWhatsapp();
                        },
                        child: Text('Need help? Chat with Us',
                            style: bodyStyle.copyWith(color: Colors.black87)))
                  ],
                ),
                SizedBox(
                  height: height / 3,
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
