import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.deepOrange,
      title: const Text("Ошибка"),
      titleTextStyle: GoogleFonts.ptSerif(
          textStyle: const TextStyle(
              color: Colors.white, wordSpacing: 1, fontWeight: FontWeight.w600),
          fontSize: 18),
      actionsOverflowButtonSpacing: 20,
      
      content: Text(text,
          style: GoogleFonts.ptSerif(
              textStyle: const TextStyle(
                  color: Colors.white,
                  wordSpacing: 1,
                  fontWeight: FontWeight.w300),
              fontSize: 15)),
    );
  }
}
