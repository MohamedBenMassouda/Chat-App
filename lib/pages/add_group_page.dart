import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/finish_group_page.dart';
import 'package:true_chat_app/utils/my_snack_bar.dart';
import 'package:true_chat_app/utils/show_friends.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  TextEditingController groupNameController = TextEditingController();

  TextEditingController groupDescriptionController = TextEditingController();

  TextEditingController friendName = TextEditingController();
  int countSelectedFriends = 0;
  List<Map<String, String>> selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: selectedFriends.length > 0
            ? Text("${selectedFriends.length} selected")
            : const Text("Add Group"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  groupNameController.text = value;
                });
              },
              controller: friendName,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Who would you like to add?',
              ),
            ),
          ),
          ShowFriends(
            friendName: friendName.text,
            isSelecting: true,
            selectedFriends: selectedFriends,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedFriends.isEmpty) {
            MySnackBar(context, "Please select at least one friend");
            return;
          }
          
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FinishAddGroupPage(selectedFriends: selectedFriends)
              )
          );
        },
        child: const Icon(Icons.arrow_right_alt_sharp),
      ),
    );
  }
}
