import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(text: 'Quiz', style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.black54)),
        TextSpan(text: 'Maker', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    ),
  );
}

Widget BButton({required BuildContext context, required String label, buttonWidth}){
  return  Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(30)),
    height: 50,
    alignment: Alignment.center,
    width: buttonWidth != null ? buttonWidth : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}