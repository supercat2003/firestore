import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom/custom_button.dart';

late SharedPreferences shared;

const keyEmail = 'email';

class ProfileEmailPage extends StatefulWidget {
  const ProfileEmailPage({super.key, required this.title});

  final String title;
  @override
  State<ProfileEmailPage> createState() => _ProfileEmaulPage();
}

class _ProfileEmaulPage extends State<ProfileEmailPage> {
  String savedEmail = "";

  Future<void> init() async {
    shared = await SharedPreferences.getInstance();

    savedEmail = shared.getString(keyEmail) ?? '';

    setState(() {});
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                alignment: Alignment.topCenter,
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xfffff0e0),
                ),
                child: SingleChildScrollView(
                    child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 150),
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            child: Column(children: <Widget>[
                              Text(
                                "Профиль",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ptSerif(
                                    textStyle: const TextStyle(
                                        fontSize: 26,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "Почта: $savedEmail",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ptSerif(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 26, 12, 101),
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              CustomButton(
                                text: 'Выйти из системы',
                                onPressed: () async {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  await auth.signOut();

                                  Navigator.pushNamed(
                                      context, 'auth_page_screen');
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ]),
                          )))
                ])))));
  }
}
