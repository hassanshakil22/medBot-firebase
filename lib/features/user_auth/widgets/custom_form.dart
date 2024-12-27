import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onfieldSubmit;
  final TextInputType? inputType;

  const CustomFormField({
    super.key,
    this.controller,
    this.fieldKey,
    this.isPasswordField,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onfieldSubmit,
    this.inputType,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.35),
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        style: const TextStyle(color: Colors.blue),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onfieldSubmit,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Set radius here
              borderSide: BorderSide.none, // Removes the visible border
            ),
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                _obscureText = !_obscureText;
              }),
              child: widget.isPasswordField == true
                  ? Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _obscureText == false ? Colors.blue : Colors.grey,
                    )
                  : const Text(" "),
            )),
      ),
    );
  }
}
