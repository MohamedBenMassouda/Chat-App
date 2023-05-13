import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/groups/finish_group_page.dart';
import 'package:true_chat_app/utils/my_snack_bar.dart';
import 'package:true_chat_app/utils/show/show_friends.dart';

class AddGroupPage extends StatefulWidget {
  final bool isAdding;
  final List members;
  final Function(List<Map<String, String>>)? onAdd;

  const AddGroupPage({
    super.key,
    this.isAdding = false,
    this.members = const [],
    this.onAdd,
  });

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
        title: widget.isAdding
            ? const Text("Add Friends to Group")
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
            isAdding: widget.isAdding,
            members: widget.members,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedFriends.isEmpty) {
            MySnackBar(context, "Please select at least one friend");
            return;
          }

          if (widget.isAdding) {
            widget.onAdd!(selectedFriends);

            Navigator.pop(context);
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
        child: widget.isAdding
            ? const Icon(Icons.add)
            : const Icon(Icons.arrow_right_alt_sharp),
      ),
    );
  }
}
