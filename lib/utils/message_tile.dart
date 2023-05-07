import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String uid;
  final String message;

  const MessageTile({
    super.key,
    required this.uid,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = uid == FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? const Color.fromARGB(255, 126, 43, 242) : const Color.fromARGB(255, 77, 75, 75),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
