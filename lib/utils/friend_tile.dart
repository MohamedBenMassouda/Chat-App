import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/chat_page.dart';

class FriendTile extends StatelessWidget {
  final Map<String, dynamic> friend;

  const FriendTile({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(friend["photoURL"]),
        ),
        title: Text(friend["displayName"]),
        // Add Last Seen
        // subtitle: Text(friend["email"]),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(friend: friend),
            ),
          );
        },
      )
    );
  }
}