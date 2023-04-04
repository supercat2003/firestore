import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/pages/auth_screen.dart';
import 'package:firebase_test/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom/alet_dialog.dart';
import '../custom/custom_button.dart';

late SharedPreferences shared;

final emailTextFieldController = TextEditingController();
final passTextFieldController = TextEditingController();

String email = "";
String pass = "";
String savedEmail = "";
String savedPass = "";
const keyEmail = 'email';
const keyPass = 'pass';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

User? user;

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key, required this.title});
  String title;

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> init() async {
    shared = await SharedPreferences.getInstance();
    savedEmail = shared.getString(keyEmail) ?? '';
    savedPass = shared.getString(keyPass) ?? '';

    setState(() {});
  }

  void savePref() async {
    setState(() {});
  
    await shared.setString(keyPass, savedPass);
    await shared.setString(keyEmail, savedEmail);
    //await shared.setString(keyUid, ref.toString());
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> updateUser() {
  return users
    .doc(auth.currentUser!.uid) //auth.currentUser!.uid  pQuVLUhLCgstVBL5f0Yy
    .update({"email": email, "pass": pass})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}

  Future<void> updateAuthUser() async{
    user = auth.currentUser!;

    user?.updatePassword(passTextFieldController.text);
    // user?.updateEmail('123@123.com');
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
                          "Изменение профиля",
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
                            controller: emailTextFieldController,
                            maxLength: 30,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: "Почта",
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
                                              'Поле почты не может быть пустым');
                                    },
                                  );
                                });
                              } else {
                                setState(() {
                                  email = value;
                                  savePref();
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
                            controller: passTextFieldController,
                            maxLength: 8,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              labelText: "Пароль",
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
                                              'Пароль не может быть пустым');
                                    },
                                  );
                                });
                              } else {
                                pass = value;
                                savePref();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        CustomButton(
                          text: 'Сохранить',
                          onPressed: () {

                            // User? userdata = auth.currentUser!;
                            // userdata.updateEmail(savedEmail);
                            // userdata.updatePassword(savedPass);
                            
                            updateAuthUser();
                            updateUser();

                            emailTextFieldController.text = "";
                            passTextFieldController.text = "";
                            setState(() {});


                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AuthPage(
                                      title: 'Авторизация',
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
