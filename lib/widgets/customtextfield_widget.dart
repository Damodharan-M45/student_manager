import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_manager/constant/appcolors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;
  final double textSize;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final int? maxLines; // ✅ optional maxLines
  final AutovalidateMode? autovalidateMode; // ✅ optional auto validation

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = AppColors.white,
    this.borderColor = AppColors.grey,
    this.borderRadius = 8.0,
    this.textSize = 16.0,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.maxLength,
    this.maxLines = 1,
    this.autovalidateMode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      autovalidateMode: widget.autovalidateMode,
      style: TextStyle(fontSize: widget.textSize),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: widget.textSize),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _toggleVisibility,
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: widget.fillColor,
        counterText: '', // hide default counter
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
      ),
    );
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      return TextEditingValue(
        text: newValue.text.trimLeft(),
        selection: TextSelection.collapsed(
          offset: newValue.text.trimLeft().length,
        ),
      );
    }
    return newValue;
  }
}
