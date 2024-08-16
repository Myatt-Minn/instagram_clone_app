import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Color backgroundcolor;
  final Color bordercolor;
  final String text;
  final Color textcolor;
  final Function()? function;

  const FollowButton(
      {super.key,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.text,
      required this.textcolor,
      this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 220,
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(
              color: bordercolor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
