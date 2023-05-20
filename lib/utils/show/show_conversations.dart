import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/tiles/conversation_tile.dart';

class ShowConversations extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> friendsList;

  const ShowConversations({
    super.key,
    required this.friendsList,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: friendsList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final friends = snapshot.data!.get('friends') as List<dynamic>;

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return ConversationTile(
              name: friends[index]["displayName"],
              friend: friends[index],
              photoURL: friends[index]["photoURL"],
              chatDoc: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(friends[index]["chatId"]),
            );
          },
        );
      },
    );
  }
}
