import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/my_snack_bar.dart';
import 'package:true_chat_app/utils/my_text_buton.dart';

class MessageTile extends StatelessWidget {
  final String uid;
  final String message;
  VoidCallback delete;
  VoidCallback edit;
  VoidCallback copy;

  MessageTile({
    super.key,
    required this.uid,
    required this.message,
    required this.delete,
    required this.edit,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = uid == FirebaseAuth.instance.currentUser!.uid;

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 80,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyTextButton(
                        text: "Delete",
                        color: Colors.red,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (uid == FirebaseAuth.instance.currentUser!.uid) {
                            delete();
                          } else {
                            MySnackBar(
                              context,
                              "You can only delete your own messages",
                            );
                          }
                        },
                      ),
                      MyTextButton(
                        text: "Copy",
                        icon: const Icon(Icons.copy),
                        onPressed: copy,
                      ),
                      MyTextButton(
                        text: "Edit",
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          if (uid == FirebaseAuth.instance.currentUser!.uid) {
                            edit();
                          } else {
                            MySnackBar(
                              context,
                              "You can only edit your own messages",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? const Color.fromARGB(255, 126, 43, 242)
                    : const Color.fromARGB(255, 77, 75, 75),
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
      ),
    );
  }
}
