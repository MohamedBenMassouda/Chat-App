import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final Function() onPressed;

  MyTextField({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.onPressed,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              maxLines: null,
              controller: widget.messageController,
              onTapOutside: (event) {
                widget.focusNode.unfocus();
              },
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Message',
              ),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  setState(() {
                    isTyping = false;
                  });
                } else {
                  setState(() {
                    isTyping = true;
                  });
                }
              },
            ),
          ),
        ),
        isTyping
            ? IconButton(
                onPressed: () {
                  if (widget.messageController.text.trim().isEmpty) {
                    return;
                  }

                  widget.onPressed();

                  widget.focusNode.requestFocus();

                  widget.messageController.clear();
                },
                icon: const Icon(Icons.send),
              )
            : Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_outlined),
                  ),
                ],
              ),
      ],
    );
  }
}
