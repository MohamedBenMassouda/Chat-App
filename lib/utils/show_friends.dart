import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/friend_tile.dart';

class ShowFriends extends StatelessWidget {
  final String friendName;
  final bool isSelecting;
  List<Map<String, String>>? selectedFriends;

  ShowFriends({
    super.key,
    this.friendName = "",
    this.isSelecting = false,
    this.selectedFriends,
  });

  var friendsList = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  List<Map<String, dynamic>> mentionedFriends(
      List friendsList, String friendName) {
    final friends = <Map<String, dynamic>>[];
    for (final friend in friendsList) {
      if (friend["displayName"]
          .toString()
          .toLowerCase()
          .contains(friendName.toLowerCase())) {
        friends.add(friend);
      }
    }
    return friends;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
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

          var friends = snapshot.data!.get('friends') as List<dynamic>;
          final f = mentionedFriends(friends, friendName);

          if (f.isNotEmpty) {
            friends = f;
          }
          
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FriendTile(
                friend: friends[index],
                isSelecting: isSelecting,
                selectedFriends: selectedFriends,
              );
            },
          );
        },
      ),
    );
  }
}
