import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowGroupMembers extends StatefulWidget {
  final List members;
  final String groupID;
  final String groupName;
  final String groupPicture;
  final Function onRemove;

  const ShowGroupMembers({
    super.key,
    required this.members,
    required this.groupID,
    required this.groupName,
    required this.groupPicture,
    required this.onRemove,
  });

  @override
  State<ShowGroupMembers> createState() => _ShowGroupMembersState();
}

class _ShowGroupMembersState extends State<ShowGroupMembers> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.members.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            widget.members[index]["displayName"],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Remove",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onTap: () {
                            // Close the bottom sheet
                            Navigator.pop(context);

                            // Show a dialog to confirm the removal
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Remove member"),
                                    content: const Text(
                                      "Are you sure you want to remove this member?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Remove the member from the group
                                          await FirebaseFirestore.instance
                                              .collection("groups")
                                              .doc(widget.groupID)
                                              .update({
                                            "members": FieldValue.arrayRemove([
                                              widget.members[index],
                                            ]),
                                          });

                                          // Remove the group from the member
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.members[index]["uid"])
                                              .update({
                                                "groups": FieldValue.arrayRemove([{
                                                  "groupID": widget.groupID,
                                                  "groupName": widget.groupName,
                                                  "groupPicture": widget.groupPicture,
                                                }]),
                                              });

                                          setState(() {
                                            widget.members.removeAt(index);
                                          });

                                          widget.onRemove(widget.members);

                                          Navigator.pop(context);
                                        },
                                        child: const Text("Remove"),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    );
                  });
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.members[index]["photoURL"],
                ),
              ),
              title: Text(
                widget.members[index]["displayName"],
              ),
            ),
          );
        },
      ),
    );
  }
}
