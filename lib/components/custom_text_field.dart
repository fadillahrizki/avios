import 'package:flutter/material.dart';

import '../constants/custom_color.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.obsecureText = false,
    this.maxLines = 1,
    required this.label,
    this.controller,
  });

  final String label;
  final int maxLines;
  bool obsecureText;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPassword = false;

  @override
  void initState() {
    isPassword = widget.obsecureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 12),
        TextField(
          controller: widget.controller ?? TextEditingController(),
          maxLines: widget.maxLines,
          obscureText: widget.obsecureText,
          cursorColor: CustomColor().primary,
          decoration: InputDecoration(
            suffixIcon: Visibility(
              visible: isPassword,
              child: IconButton(
                color: CustomColor().primary,
                icon: Icon(
                  widget.obsecureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() {
                  widget.obsecureText = !widget.obsecureText;
                }),
              ),
            ),
            filled: true,
            fillColor: CustomColor().white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor().primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColor().secondary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Masukkan ${widget.label}...',
          ),
        ),
      ],
    );
  }
}
