import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom/custom_button.dart';
import 'auth_screen.dart';

late SharedPreferences shared;

const keyEmail = 'email';

final passTextFieldController = TextEditingController();
final emailTextFieldController = TextEditingController();

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class RegPage extends StatefulWidget {
  RegPage({super.key, required this.title});
  String title;

  @override
  State<RegPage> createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  String savedEmail = "";
  String savedPass = "";

  Future<void> init() async {
    shared = await SharedPreferences.getInstance();

    setState(() {});
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  void savePref() async {
    setState(() {});
    await shared.setString(keyEmail, savedEmail);
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
                          "Регистрация",
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
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            onChanged: (value) {
                              savedEmail = value;
                              savePref();
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
                              icon: Icon(Icons.lock),
                              labelText: "Пароль",
                            ),
                            style: GoogleFonts.ptSerif(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 26, 12, 101),
                                    fontWeight: FontWeight.w300)),
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {
                              savedPass = value;
                            },
                          ),
                        ),
                        
                        const SizedBox(
                          height: 80,
                        ),
                        CustomButton(
                          text: 'Войти в профиль',
                          onPressed: ()  async{
                            try{
                              UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: savedEmail, password: savedPass);

                              final user = <String, dynamic>{
                                "email": savedEmail,
                                "pass": savedPass
                              };

                              db.collection("users").add(user).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));

                            }on FirebaseAuthException catch(e){
                              if(e.code == 'weak-password'){
                                print('weak password');
                              }
                              else if(e.code == 'email-already-in-use'){
                                print ('email already in use');
                              }

                            }catch (e){
                              print(e);
                            }

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AuthPage(
                                      title: 'Авторизация',
                                    )));
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
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