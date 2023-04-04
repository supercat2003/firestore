import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/pages/reg_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../custom/alet_dialog.dart';
import '../custom/custom_button.dart';

late SharedPreferences shared;

const keyPass = 'pass';
const keyEmail = 'email';
const keyUid = 'uid';

final passTextFieldController = TextEditingController();
final emailTextFieldController = TextEditingController();

final auth = FirebaseAuth.instance;

String savedEmail = "";

class AuthPage extends StatefulWidget {
  AuthPage({super.key, required this.title});
  String title;

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
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
    await shared.setString(keyPass, savedPass);
    await shared.setString(keyEmail, savedEmail);
    //await shared.setString(keyUid, ref.toString());
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
                          "Авторизация",
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
                                  savedEmail = value;
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
                              icon: Icon(Icons.lock),
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
                                              'Поле пароля не может быть пустым');
                                    },
                                  );
                                });
                              } else {
                                savedPass = value;
                                savePref();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        CustomButton(
                          text: 'Войти',
                          onPressed: () async {
                            bool isvalid = EmailValidator.validate(savedEmail);
                            if (!isvalid) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomDialog(
                                      text: 'Поле почты заполнено неправильно');
                                },
                              );
                            } else {
                              try {
                                UserCredential userCredential =
                                    await auth.signInWithEmailAndPassword(
                                        email: savedEmail, password: savedPass);
                                Navigator.pushNamed(
                                    context, 'profile_page_screen');

                                // DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
                                // print(ref);

                                // var user;
                                // var ref = FirebaseFirestore.instance
                                //     .collection("users")
                                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                                //     .set(user)
                                //     .onError((e, _) =>
                                //         print("Error writing document: $e"));

                                // print(user);
                                // print(ref);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('user not found');
                                } else if (e.code == 'wrong-password') {
                                  print('wrong password');
                                }
                              }
                            }

                            emailTextFieldController.text = "";
                            passTextFieldController.text = "";
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: 'Создать профиль',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    RegPage(title: 'Регистрация')));
                          },
                          icon: const Icon(
                            Icons.create,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: 'Зайти по полю почты',
                          onPressed: () {
                            Navigator.pushNamed(context, 'auth_email_screen');
                          },
                          icon: const Icon(
                            Icons.alternate_email_sharp,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: 'Зайти в режиме гостя',
                          onPressed: () async {
                            final auth = FirebaseAuth.instance;
                            try {
                              UserCredential userCredential =
                                  await auth.signInAnonymously();
                              Navigator.pushNamed(context, 'profile_anon');
                            } catch (e) {
                              print(e);
                            }
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
