import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/chat_page.dart';

class FriendTile extends StatefulWidget {
  final Map<String, dynamic> friend;
  // True only when selecting friends to add to a group
  final bool isSelecting;
  bool isSelected;
  // List of the usernames of the selected friends
  List<Map<String, String>>? selectedFriends;

  FriendTile({
    super.key,
    required this.friend,
    this.isSelecting = false,
    this.isSelected = false,
    this.selectedFriends,
  });

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
        child: ListTile(
          leading: !widget.isSelected
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.friend["photoURL"]),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
          title: Text(widget.friend["displayName"]),
          // Add Last Seen
          // subtitle: Text(friend["email"]),

          onTap: () {
            if (widget.isSelecting) {
              setState(() {
                widget.isSelected = !widget.isSelected;
                if (widget.isSelected) {
                  widget.selectedFriends!.add({
                    "displayName": widget.friend["displayName"],
                    "photoURL": widget.friend["photoURL"],
                    "uid": widget.friend["uid"],
                  });
                } else {
                  widget.selectedFriends!.removeWhere((friend) =>
                      friend["displayName"] == widget.friend["displayName"]
                  );
                }
              });

              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(friend: widget.friend),
              ),
            );
          },
        ));
  }
}
