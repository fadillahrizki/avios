import 'package:flutter/material.dart';

import '../constants/custom_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.type = 'primary',
    this.size = 'normal',
    this.enabled = true,
    required this.onPressed,
    required this.label,
  });

  final String label, type, size;
  final GestureTapCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (type == 'primary') {
      return ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          backgroundColor:
              enabled ? CustomColor().primary : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: size == 'normal' ? 14 : 10,
            ),
          ),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          side: BorderSide(color: CustomColor().secondary),
          backgroundColor:
              enabled ? CustomColor().white : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: CustomColor().primary,
              fontSize: size == 'normal' ? 14 : 10,
            ),
          ),
        ),
      );
    }
  }
}
