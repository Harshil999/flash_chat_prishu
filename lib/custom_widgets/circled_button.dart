import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircledButton extends StatelessWidget {
  const CustomCircledButton({
    super.key,
    required this.buttonText,
    required this.selectedColor,
    required this.onPress,
  });

  final Color selectedColor;
  final String buttonText;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: selectedColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
