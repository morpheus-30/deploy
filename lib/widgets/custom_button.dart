import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? textButtonText;
  final String? elevatedButtonText;
  final VoidCallback? textButtonCallback;
  final VoidCallback? elevatedButtonCallback;
  final ButtonStyle? textButtonStyle;
  final ButtonStyle? elevatedButtonStyle;
  // final double elevatedButtonWidth; // Change this line
  final IconData? icon;

  const CustomButton({
    super.key,
    this.textButtonText,
    this.elevatedButtonText,
    this.textButtonCallback,
    this.elevatedButtonCallback,
    this.textButtonStyle,
    this.elevatedButtonStyle,
    // this.elevatedButtonWidth, // Set a default width
    this.icon,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (textButtonText != null)
          TextButton(
            onPressed: textButtonCallback,
            style: textButtonStyle,
            child: Text(textButtonText!),
          ),
        const SizedBox(width: 5),
        if (elevatedButtonText != null)
          SizedBox(
            // width: elevatedButtonWidth,
            child: ElevatedButton.icon(
              onPressed: elevatedButtonCallback,
              style: elevatedButtonStyle,
              icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(elevatedButtonText!),
              ),
            ),
          ),
      ],
    );
  }
}
