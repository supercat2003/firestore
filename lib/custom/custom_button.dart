
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, this.onPressed, required this.text, required this.icon});

  final Function()? onPressed;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xffffa046), Colors.deepOrange],
          ),
        ),
        child: MaterialButton(
            onPressed: onPressed,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    text,
                    style: GoogleFonts.ptSerif(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          wordSpacing: 1,
                          fontWeight: FontWeight.w300),
                      fontSize: 15,
                    ),
                  ),
                  icon,
                ],
              ),
            )));
  }
}