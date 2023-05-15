import 'package:flutter/material.dart';

class UnreadIndicator extends StatelessWidget {

  const UnreadIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
  
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.red,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Text(
              "Unread",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Expanded(
            child: Container(
              height: 1,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
