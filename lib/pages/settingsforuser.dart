import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_shop/pages/login.dart';
import 'package:book_shop/pages/privacyandpolicy.dart';

class SettingsForUser extends StatefulWidget {
  SettingsForUser();

  @override
  State<SettingsForUser> createState() => _SettingsForUserState();
}

class _SettingsForUserState extends State<SettingsForUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 17),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.2,
                            spreadRadius: 0.1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: Image.asset(
                                    "assets/images/privacy.png",
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Privacy policy",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Andika',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showAlertDialogBox(context);
                    },
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.2,
                            spreadRadius: 0.1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Icon(Icons.person),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Admin Login",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Andika',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialogBox(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "Login?",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Andika",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  "Are you sure you want to Login?",
                  style: TextStyle(fontSize: 16, fontFamily: "Andika"),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('password');
                          await prefs.remove('email');
                          await prefs.remove('phone');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginForm(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Andika",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 30,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Andika",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
