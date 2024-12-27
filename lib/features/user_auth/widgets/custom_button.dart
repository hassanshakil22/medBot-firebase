import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authProject/features/user_auth/views/login_view.dart';
import 'package:firebase_authProject/global/widgets/toast.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        onPressed: widget.onPressed,
        child: Text(widget.text),
      ),
    );
  }
}
