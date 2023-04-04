import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/pages/auth_email_screen.dart';
import 'package:firebase_test/pages/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom/custom_button.dart';
import 'add_note.dart';
import 'edit_note.dart';

late SharedPreferences shared;
const keyEmail = 'email';
const keyPass = 'pass';
const keyIndex = 'index';

String savedEmail = "";
String savedPass = "";
var savedIndex;

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  // Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
  //   String action = 'create';
  //   if (documentSnapshot != null) {
  //     action = 'update';
  //     _nameController.text = documentSnapshot['name'];
  //     _priceController.text = documentSnapshot['price'].toString();
  //   }
  // }

  Future<void> init() async {
    shared = await SharedPreferences.getInstance();
    savedEmail = shared.getString(keyEmail) ?? '';
    savedPass = shared.getString(keyPass) ?? '';

    setState(() {});
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  void savePref() async {
    setState(() {});
    await shared.setString(keyIndex, savedIndex);
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
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  "Пароль: $savedPass",
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
                                height: 15,
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
                                height: 25,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('notes')
                                    .where("user", isEqualTo: savedEmail)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "Загрузка",
                                      style: GoogleFonts.ptSerif(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 26, 12, 101),
                                              fontWeight: FontWeight.w600)),
                                    );
                                  }

                                  final data = snapshot.requireData;

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data.size,
                                      itemBuilder: (context, index) {
                                        return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    data.docs[index]['title'],
                                                    style: GoogleFonts.ptSerif(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 18,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        26,
                                                                        12,
                                                                        101),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ),
                                                  subtitle: Text(
                                                      data.docs[index]['desc'],
                                                      style: GoogleFonts.ptSerif(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          26,
                                                                          12,
                                                                          101),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                  trailing: SizedBox(
                                                    width: 100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            onPressed: () => {
                                                              savedIndex = data.docs[index]['title'],
                                                              savePref(),

                                                                  // FirebaseFirestore
                                                                  //     .instance
                                                                  //     .collection(
                                                                  //         "notes")
                                                                  //     .where(
                                                                  //         "title",
                                                                  //         isEqualTo:
                                                                  //             data.docs[index]['title'])
                                                                  //     .get()
                                                                  //     .then(
                                                                  //         (value) {
                                                                  //   value.docs
                                                                  //       .forEach(
                                                                  //           (element) {
                                                                  //     FirebaseFirestore
                                                                  //         .instance
                                                                  //         .collection(
                                                                  //             "notes")
                                                                  //         .doc(element
                                                                  //             .id)
                                                                  //         .update(
                                                                  //           {"title": 'new title', "desc": 'new desc'}
                                                                  //         )
                                                                  //         .then(
                                                                  //             (value) {
                                                                  //       print(
                                                                  //           "Success!");
                                                                  //     });
                                                                  //   });
                                                                  // })

                                                                  Navigator.of(context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) => EditNotePage(
                                                                                  title: 'Изменение заметок',
                                                                                )))
                                                                  

                                                                  
                                                                  
                                                                }),
                                                        IconButton(
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            onPressed: () =>
                                                                {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "notes")
                                                                      .where(
                                                                          "title",
                                                                          isEqualTo:
                                                                              data.docs[index]['title'])
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    value.docs
                                                                        .forEach(
                                                                            (element) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "notes")
                                                                          .doc(element
                                                                              .id)
                                                                          .delete()
                                                                          .then(
                                                                              (value) {
                                                                        print(
                                                                            "Success!");
                                                                      });
                                                                    });
                                                                  })
                                                                }),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
                                      });
                                  // return SizedBox(
                                  //   height: 300,
                                  //   width: 300,
                                  //   child: ListView(
                                  //     children: snapshot.data!.docs
                                  //         .map((DocumentSnapshot document) {
                                  //           Map<String, dynamic> data =
                                  //               document.data()!
                                  //                   as Map<String, dynamic>;
                                  //           return Card(
                                  //               shape: RoundedRectangleBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(10),
                                  //               ),
                                  //               child: Column(
                                  //                 children: [
                                  //                   ListTile(
                                  //                     title: Text(
                                  //                       data['title'],
                                  //                       style: GoogleFonts.ptSerif(
                                  //                           textStyle: const TextStyle(
                                  //                               fontSize: 18,
                                  //                               color: Color
                                  //                                   .fromARGB(
                                  //                                       255,
                                  //                                       26,
                                  //                                       12,
                                  //                                       101),
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w600)),
                                  //                     ),
                                  //                     subtitle: Text(
                                  //                         data['desc'],
                                  //                         style: GoogleFonts.ptSerif(
                                  //                             textStyle: const TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 color: Color
                                  //                                     .fromARGB(
                                  //                                         255,
                                  //                                         26,
                                  //                                         12,
                                  //                                         101),
                                  //                                 fontWeight:
                                  //                                     FontWeight
                                  //                                         .w600))),
                                  //                     trailing: SizedBox(
                                  //                       width: 100,
                                  //                       child: Row(
                                  //                         children: [
                                  //                           IconButton(
                                  //                               icon: const Icon(
                                  //                                   Icons.edit),
                                  //                               onPressed: () =>
                                  //                                   {}),
                                  //                           IconButton(
                                  //                               icon: const Icon(
                                  //                                   Icons
                                  //                                       .delete),
                                  //                               onPressed: () =>
                                  //                                   {}
                                  //                                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   )
                                  //                 ],
                                  //               ));
                                  //         })
                                  //         .toList()
                                  //         .cast(),
                                  //   ),
                                  // );
                                },
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              CustomButton(
                                text: 'Добавить заметку',
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddNotePage(
                                            title: 'Добавление заметок',
                                          )));
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                text: 'Изменить профиль',
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProfilePage(
                                            title: 'Изменение профиля',
                                          )));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
