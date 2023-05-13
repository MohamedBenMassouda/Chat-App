import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/groups/add_group_page.dart';
import 'package:true_chat_app/utils/show/show_group_members.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String groupPicture;
  final List members;
  final Map<String, dynamic> owner;

  const GroupInfoPage({
    super.key,
    required this.groupID,
    required this.groupName,
    required this.groupPicture,
    required this.members,
    required this.owner,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        widget.owner["uid"] == FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Edit Group"),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    if (isOwner) {
                    } else {}
                  },
                  child: const Text("Delete Group"),
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
              ),
            ),
            title: Text(widget.groupName),
            subtitle: Text("${widget.members.length + 1} members"),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              final List membersList = widget.members;
              membersList.add(widget.owner);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGroupPage(
                    isAdding: true,
                    members: membersList,
                    onAdd: (newMembers) {
                      membersList.remove(widget.owner);

                      // Add new members to the group
                      FirebaseFirestore.instance
                          .collection("groups")
                          .doc(widget.groupID)
                          .update({
                        "members": FieldValue.arrayUnion(newMembers),
                      });

                      // Add the group to the new members
                      for (var member in newMembers) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(member["uid"])
                            .update({
                              "groups": FieldValue.arrayUnion([
                                {
                                  "groupPicture": widget.groupPicture,
                                  "groupID": widget.groupID,
                                  "groupName": widget.groupName,
                                }
                              ]),
                            });
                      }

                      setState(() {
                        widget.members.addAll(newMembers);
                      });
                    },
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_add_alt),
                SizedBox(width: 10),
                Text("Add Members"),
              ],
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.owner["photoURL"],
              ),
            ),
            title: Text(widget.owner["displayName"]),
            subtitle: const Text("Owner"),
            trailing: const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
          ),
          ShowGroupMembers(
            members: widget.members,
            groupID: widget.groupID,
            groupName: widget.groupName,
            groupPicture: widget.groupPicture,
            onRemove: (newMembers) {
              setState(() {
                widget.members.removeWhere((member) =>
                    newMembers.contains(member["uid"]) ||
                    member["uid"] == widget.owner["uid"]);
              });
            },
          ),
        ],
      ),
    );
  }
}
