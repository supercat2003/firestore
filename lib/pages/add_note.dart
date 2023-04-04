import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/pages/profile_screen.dart';
import 'package:firebase_test/pages/reg_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../custom/alet_dialog.dart';
import '../custom/custom_button.dart';

late SharedPreferences shared;

final titleTextFieldController = TextEditingController();
final descTextFieldController = TextEditingController();

String title = "";
String desc = "";
const keyEmail = 'email';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class AddNotePage extends StatefulWidget {
  AddNotePage({super.key, required this.title});
  String title;

  @override
  State<AddNotePage> createState() => _AddNotePage();
}

class _AddNotePage extends State<AddNotePage> {
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
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 150),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Добавление заметки",
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
                          child: TextField(
                            controller: titleTextFieldController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.title),
                              labelText: "Название",
                            ),
                            style: GoogleFonts.ptSerif(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 26, 12, 101),
                                    fontWeight: FontWeight.w300)),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                          text:
                                              'Поле названия не может быть пустым');
                                    },
                                  );
                                });
                              } else {
                                setState(() {
                                  title = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: descTextFieldController,
                            maxLength: 200,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.description),
                              labelText: "Описание",
                            ),
                            style: GoogleFonts.ptSerif(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 26, 12, 101),
                                    fontWeight: FontWeight.w300)),
                            keyboardType: TextInputType.visiblePassword,
                            autocorrect: false,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                          text:
                                              'Описание не может быть пустым');
                                    },
                                  );
                                });
                              } else {
                                desc = value;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        CustomButton(
                          text: 'Сохранить',
                          onPressed: () async {
                            final note = <String, dynamic>{
                              "title": title,
                              "desc": desc,
                              "user": savedEmail
                            };

                            db.collection("notes").add(note).then(
                                (DocumentReference doc) => print(
                                    'DocumentSnapshot added with ID: ${doc.id}'));

                            titleTextFieldController.text = "";
                            descTextFieldController.text = "";
                            setState(() {});


                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      title: 'Профиль',
                                    )));
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
