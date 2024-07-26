// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    this.initValue,
    required this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.onSaved,
    this.onTap,
  });

  final String? initValue;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final void Function(String? value)? onSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      initialValue: initValue,
      obscureText: obscureText,
      readOnly: readOnly,
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
