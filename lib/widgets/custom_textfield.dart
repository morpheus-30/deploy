import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget CustomFormField({
  TextEditingController? controller,
  String? label,
  String? hintText,
  String? errorText,
  String? initialValue,
  BorderRadius? borderRadius,
  double? width,
  double? height,
  bool obscureText = false,
  Color cursorColor = Colors.grey,
  Color? textColor,
  Color? hintColor,
  Color? borderColor,
  Color? focusedBorderColor,
  Color? errorBorderColor,
  Color? focusedErrorBorderColor,
  Color? fillColor, // Background color for the field
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  TextInputType? inputType,
  List<TextInputFormatter>? inputFormatters,
  bool readOnly = false,
  bool enabled = true,
  EdgeInsetsGeometry contentPadding =
      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  Function(String)? onChanged,
  Function(String)?
      onFieldSubmitted, // Added onFieldSubmitted for handling Enter key
  TextInputAction?
      textInputAction, // Added textInputAction for keyboard actions
}) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue,
    keyboardType: inputType,
    inputFormatters: inputFormatters,
    readOnly: readOnly,
    enabled: enabled,
    obscureText: obscureText,
    style: TextStyle(color: textColor), // Text color
    textInputAction:
        textInputAction, // Added here to specify the keyboard action
    decoration: InputDecoration(
      filled: fillColor !=
          null, // Enable background color only if fillColor is provided
      fillColor: fillColor, // Background color
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: contentPadding,
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 14,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: hintColor ?? Colors.grey.withOpacity(0.5),
      ),
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        borderSide: BorderSide(
          color: borderColor ?? Colors.grey.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        borderSide: BorderSide(
          color: focusedBorderColor ?? Colors.grey.withOpacity(0.5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        borderSide: BorderSide(
          color: borderColor ?? Colors.grey.withOpacity(0.5),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        borderSide: BorderSide(
          color: errorBorderColor ?? Colors.red.withOpacity(0.6),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        borderSide: BorderSide(
          color: focusedErrorBorderColor ?? Colors.red,
        ),
      ),
    ),
    cursorColor: cursorColor,
    validator: validator,
    onChanged: onChanged,
    onFieldSubmitted:
        onFieldSubmitted, // Handle when user submits (presses Enter)
  );
}
