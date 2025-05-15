import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String lable;
  final IconData? avaterIcon;
  const ChipWidget({Key? key, required this.lable, this.avaterIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label:  Text(lable, style: const TextStyle(color: Colors.white)),
      avatar: avaterIcon != null ? Icon(avaterIcon, color: Colors.white) : null,
      backgroundColor: const Color.fromARGB(255, 49, 77, 218),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }
}
