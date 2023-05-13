import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final Function() onPressed;

  const MyTextField({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: messageController,
              onTapOutside: (event) {
                focusNode.unfocus();
              },
              focusNode: focusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type a message',
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (messageController.text.trim().isEmpty) {
              return;
            }

            onPressed();

            focusNode.requestFocus();

            messageController.clear();
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}