import 'package:flutter/material.dart';
import '../constants/custom_color.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.content});

  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColor().background,
      // title: Text("Konfirmasi OTP"),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListBody(children: content),
        ),
      ),
    );
  }
}
