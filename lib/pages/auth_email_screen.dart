import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/pages/reg_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../custom/alet_dialog.dart';
import '../custom/custom_button.dart';

late SharedPreferences shared;
const keyEmail = 'email';

final emailTextFieldController = TextEditingController();

final auth = FirebaseAuth.instance;

String savedEmail = "";

class AuthEmailPage extends StatefulWidget {
  AuthEmailPage({super.key, required this.title});
  String title;

  @override
  State<AuthEmailPage> createState() => _AuthEmailPage();
}

class _AuthEmailPage extends State<AuthEmailPage> {
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
                              if (await _sendSignInWithEmailLink(true)) {
                                Navigator.pushNamed(
                                    context, 'profile_email');
                              } else if (await _sendSignInWithEmailLink(
                                  false)) {
                                setState(() {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialog(
                                          text: 'Ошибка входа');
                                    },
                                  );
                                });
                              }
                            }

                            emailTextFieldController.text = "";
                            setState(() {});
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

Future<bool> _sendSignInWithEmailLink(bool bool) async {
  final FirebaseAuth user = FirebaseAuth.instance;
  try {
    user.sendSignInLinkToEmail(
      email: savedEmail,
      actionCodeSettings: ActionCodeSettings(
          url: "https://signinemaillink.page.link/XktS",
          androidMinimumVersion: "16",
          androidPackageName: "com.example.app",
          iOSBundleId: "com.example.app",
          androidInstallApp: true,
          handleCodeInApp: true),
    );
  } catch (e) {
    print(e.toString());
    return bool = false;
  }
  print(savedEmail + "<< sent");
  return bool = true;
}
