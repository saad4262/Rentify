// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'message.dart';
//
// class ChatListPage extends StatefulWidget {
//   final String propertyId;
//   final String propertyOwnerId;
//   final String propertyOwnerName;
//   final String userimage;
//   final String? number;
//   final String? uid2;
//   final String? username1;
//
//
//   ChatListPage({
//     required this.propertyId,
//     required this.userimage,
//     required this.propertyOwnerId,
//     required this.propertyOwnerName,
//      this.number,
//     this.uid2,
//     this.username1
//
//   });
//
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }
//
// class _ChatListPageState extends State<ChatListPage> {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chats'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('users')
//             .doc(currentUser?.uid)
//             .collection('chats')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           var chatDocs = snapshot.data!.docs;
//
//           if (chatDocs.isEmpty) {
//             return Center(child: Text('No Chats Available.'));
//           }
//
//           return ListView.builder(
//             itemCount: chatDocs.length,
//             itemBuilder: (context, index) {
//               var chatDoc = chatDocs[index];
//               String chatId = chatDoc.id;  // This is the chat UID
//               List<String> users = List.from(chatDoc['users']);
//
//               // Filter out the current user from the chat list
//               String otherUserId = users.firstWhere(
//                       (userId) => userId != currentUser?.uid,
//                   orElse: () => '');
//
//               return FutureBuilder<DocumentSnapshot>(
//                 future: _firestore.collection('users').doc(otherUserId).get(),
//                 builder: (context, userSnapshot) {
//                   if (!userSnapshot.hasData) {
//                     return ListTile(
//                       title: Text('Loading...'),
//                     );
//                   }
//
//                   var userData = userSnapshot.data!;
//
//                   // Accessing the fullName from the infoUser field
//                   var infoUser = userData['infoUser']; // Assuming 'infoUser' is a subfield
//                   String fullName = infoUser != null ? infoUser['fullName'] ?? 'Unknown User' : 'Unknown User';
//                   String imageUrl = infoUser != null ? infoUser['imageUrl'] ?? '' : ''; // Default image if not found
//
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: imageUrl.isNotEmpty
//                           ? NetworkImage(imageUrl)
//                           : AssetImage('assets/default_profile.png') as ImageProvider,  // Default image if no URL
//                     ),
//                     title: Text(fullName),  // Display full name
//                     subtitle: Text(chatId),  // You can display chat ID or last message here
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => ChatPage(
//                       //       propertyId: widget.number!,
//                       //       propertyOwnerId: widget.uid2!,
//                       //       userimage: widget.userimage,
//                       //       propertyOwnerName: widget.username1!,
//                       //     ),
//                       //   ),
//                       // );
//
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
