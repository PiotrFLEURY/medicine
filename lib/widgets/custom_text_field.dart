import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;

  CustomTextField({this.controller, this.hint, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.bottom,
          maxLines: 1,
          keyboardType: type,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(Icons.label),
            border: InputBorder.none,
          ),
          controller: controller,
        ),
      ),
    );
  }
}
