import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/groups/group_chat_page.dart';
import 'package:true_chat_app/utils/tiles/group_tile.dart';

class ShowGroups extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> groupStream;

  const ShowGroups({
    super.key,
    required this.groupStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: groupStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No groups"),
          );
        }

        final groups = snapshot.data!.get("groups") as List<dynamic>;

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: GroupTile(
                groupStream: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(groups[index]["groupID"])
                          .snapshots(),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatPage(
                      group: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(groups[index]["groupID"])
                          .snapshots(),
                      groupName: groups[index]["groupName"],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}