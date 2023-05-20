import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/functions/display_timestamp.dart';

class GroupTile extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> groupStream;

  const GroupTile({
    super.key,
    required this.groupStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: groupStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final messages = snapshot.data!.get("messages") as List<dynamic>;

        final bool read = messages.last["read"]
            .contains(FirebaseAuth.instance.currentUser!.uid);

        final subtitle = messages.isEmpty
            ? const Text("No messages yet")
            : Text(
                "${messages.last["sender"]}: ${messages.last["message"]}",
                style: TextStyle(
                  fontWeight: read ? FontWeight.normal : FontWeight.bold,
                ),
              );

        final trailing = messages.isEmpty
            ? null
            : Text(
              displayTimeStamp(messages.last["timestamp"].toDate()),
              style: TextStyle(
                fontWeight: read ? FontWeight.normal : FontWeight.bold,
              ),
            );

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              snapshot.data!.get("groupPicture"),
            ),
          ),
          title: Text(
            snapshot.data!.get("groupName"),
          ),
          subtitle: subtitle,
          trailing: trailing,
        );
      },
    );
  }
}
