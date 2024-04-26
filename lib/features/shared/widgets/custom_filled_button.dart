import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {

  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;

  const CustomFilledButton({
    super.key, 
    this.onPressed, 
    required this.text, 
    this.buttonColor
  });

  @override
  Widget build(BuildContext context) {

    final  radius = BorderRadius.circular(10);

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: buttonColor,
        shape:  RoundedRectangleBorder(
        borderRadius: radius,
        
      )),
        
  
      onPressed: onPressed, 
      child: Text(text)
    );
  }
}