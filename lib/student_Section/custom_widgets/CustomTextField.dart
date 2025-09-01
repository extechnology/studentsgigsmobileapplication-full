import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for TextInputFormatter

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final IconData? iconTrailing;
  final Color? iconColor;
  final TextEditingController? controller;
  final bool? isObscured;
  final bool? enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator; // Added validator parameter

  const CustomTextField({
    super.key,
    this.hintText,
    this.iconTrailing,
    this.iconColor,
    this.controller,
    this.isObscured = false,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.validator, // Added to constructor
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize password visibility based on isObscured
    _isPasswordVisible = !(widget.isObscured ?? false);
  }

  @override
  Widget build(BuildContext context) {
    // Auto-detect if this should be a password field with toggle
    bool isPasswordField =
        (widget.isObscured ?? false) && widget.iconTrailing == null;

    return TextFormField(
      // Changed from TextField to TextFormField
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText:
          isPasswordField ? !_isPasswordVisible : (widget.isObscured ?? false),
      cursorColor: Colors.black,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      validator: widget.validator, // Added validator property
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black26),
        focusColor: Colors.white,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.black26,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          // Added error border styling
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          // Added focused error border
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: widget.iconColor ?? Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : (widget.iconTrailing != null
                ? Icon(widget.iconTrailing, color: widget.iconColor)
                : null),
        counterText: '', // Removes the counter for maxLength
      ),
    );
  }
}
