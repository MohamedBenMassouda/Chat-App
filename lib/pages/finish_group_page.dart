import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_chat_app/pages/group_chat_page.dart';
import 'package:true_chat_app/utils/generateUID.dart';
import 'package:true_chat_app/utils/my_snack_bar.dart';

class FinishAddGroupPage extends StatefulWidget {
  // 0 for the username, 1 for the photoURL
  final List<Map<String, String>> selectedFriends;

  FinishAddGroupPage({
    super.key,
    required this.selectedFriends,
  });

  @override
  State<FinishAddGroupPage> createState() => _FinishAddGroupPageState();
}

class _FinishAddGroupPageState extends State<FinishAddGroupPage> {
  String groupPhotoURL = "";

  TextEditingController groupNameController = TextEditingController();

  void getGroupProfilePicture() async {
    // Get permission to access the gallery and choose a new profile picture
    var permissionStatus = await Permission.storage.request();

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.storage.request();
    } else {
      // Permission is granted
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        // User chooses the new profile picture from the gallery
        final file = File(result.files.single.path!);

        setState(() {
          groupPhotoURL = file.toString();
        });
        // Upload the file to the database
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Group"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              getGroupProfilePicture();
            },
            child: groupPhotoURL != ""
                ? CircleAvatar(
                    backgroundImage: NetworkImage(groupPhotoURL),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
            child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Enter Group Name',
              ),
            ),
          ),
          Text(
            "${widget.selectedFriends.length} members",
            style: const TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedFriends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.selectedFriends[index]["photoURL"] ?? ""),
                  ),
                  title:
                      Text(widget.selectedFriends[index]["displayName"] ?? ""),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (groupNameController.text.isEmpty) {
            MySnackBar(context, "Please enter a group name");
            return;
          }

          final uid = generateUID();
          await FirebaseFirestore.instance.collection("groups").doc(uid).set({
            "groupName": groupNameController.text,
            "groupPhotoURL": groupPhotoURL,
            "owner": {
              "uid": FirebaseAuth.instance.currentUser!.uid,
              "displayName": FirebaseAuth.instance.currentUser!.displayName!,
              "photoURL": FirebaseAuth.instance.currentUser!.photoURL!,
            },
            "members": widget.selectedFriends,
            "messages": []
          });

          for (var user in widget.selectedFriends) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user["uid"])
                .update({
              "groups": FieldValue.arrayUnion([uid])
            });
          }

          final Stream<DocumentSnapshot<Map<String, dynamic>>> group =
              FirebaseFirestore.instance.collection("groups").doc(uid).snapshots();

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatPage(group: group)),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
