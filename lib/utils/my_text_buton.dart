import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  Icon icon;
  VoidCallback onPressed;
  Color color;

  MyTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    color = color == Colors.black ? Theme.of(context).textTheme.bodyText1!.color! : color;

    return TextButton(
      onPressed: () {
        onPressed();
        Navigator.pop(context);
      },
      child: Column(
        children: [
          icon,
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
