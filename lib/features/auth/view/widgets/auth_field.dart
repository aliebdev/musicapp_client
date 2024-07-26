// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    this.initValue,
    required this.hintText,
    this.obscureText = false,
    this.onSaved,
  });

  final String? initValue;
  final String hintText;
  final bool obscureText;
  final void Function(String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
    );
  }
}
