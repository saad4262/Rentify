import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realestate/modules/home/view/home1.dart';

import '../../../shared/utils/responsive_helper/responsive_helper.dart';

class ChatPage extends StatefulWidget {
  final String propertyId;
  final String propertyOwnerId;
  final String propertyOwnerName;
  final String userimage;



  ChatPage({required this.propertyId,required this.userimage, required this.propertyOwnerId, required this.propertyOwnerName,});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }


  String _generateChatId(String currentUserId, String propertyOwnerId) {
    // Sort the IDs to ensure consistency
    List<String> ids = [currentUserId, propertyOwnerId];
    ids.sort(); // Sort alphabetically to avoid swapping order
    return '${ids[0]}_${ids[1]}'; // Combine the sorted IDs
  }


  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String currentUserId = currentUser?.uid ?? '';
      String propertyOwnerId = widget.propertyOwnerId;
      String chatId = _generateChatId(currentUserId, propertyOwnerId);
      String message = _messageController.text;

      _messageController.clear();

      // Reference to the chat document for both users
      var currentUserChatDocRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc(chatId);

      var propertyOwnerChatDocRef = _firestore
          .collection('users')
          .doc(propertyOwnerId)
          .collection('chats')
          .doc(chatId);

      // Check if the chat document exists, if not, create it
      var chatDoc = await currentUserChatDocRef.get();
      if (!chatDoc.exists) {
        await currentUserChatDocRef.set({
          'chatId': chatId,
          'users': [currentUserId, propertyOwnerId],
          'lastMessage': message, // Set last message when chat is created
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Also create the same document in the property owner's collection
        await propertyOwnerChatDocRef.set({
          'chatId': chatId,
          'users': [currentUserId, propertyOwnerId],
          'lastMessage': message, // Set last message when chat is created
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Update the lastMessage field if the chat document already exists
        await currentUserChatDocRef.update({
          'lastMessage': message,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await propertyOwnerChatDocRef.update({
          'lastMessage': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Store the message in the current user's chat collection
      await currentUserChatDocRef.collection('messages').add({
        'senderId': currentUser?.uid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Store the message in the property owner's chat collection
      await propertyOwnerChatDocRef.collection('messages').add({
        'senderId': currentUser?.uid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the message input
    }
  }


  // void _sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     String currentUserId = currentUser?.uid ?? '';
  //     String propertyOwnerId = widget.propertyOwnerId;
  //     String chatId = _generateChatId(currentUserId, propertyOwnerId);
  //
  //     // Reference to the chat document
  //     var chatDocRef = _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('chats')
  //         .doc(chatId); // Chat document for the current user
  //
  //     // Check if the chat document exists, if not, create it
  //     var chatDoc = await chatDocRef.get();
  //     if (!chatDoc.exists) {
  //       // Create the document if it doesn't exist
  //       await chatDocRef.set({
  //         'chatId': chatId,
  //         'users': [currentUserId, propertyOwnerId],
  //         'lastMessage': 'start chat', // Initial message or a placeholder
  //         'timestamp': FieldValue.serverTimestamp(),
  //       });
  //     }
  //
  //     // Store messages in the current user's collection (sender)
  //     await chatDocRef.collection('messages').add({
  //       'senderId': currentUser?.uid,
  //       'message': _messageController.text,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Also store messages in the property owner's collection (receiver)
  //     await _firestore
  //         .collection('users')
  //         .doc(propertyOwnerId)
  //         .collection('chats')
  //         .doc(chatId)
  //         .collection('messages')
  //         .add({
  //       'senderId': currentUser?.uid,
  //       'message': _messageController.text,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Clear the message input
  //     _messageController.clear();
  //   }
  // }


  // void _sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     String currentUserId = currentUser?.uid ?? '';
  //     String propertyOwnerId = widget.propertyOwnerId;
  //     String chatId = _generateChatId(currentUserId, propertyOwnerId);
  //
  //
  //     // Store messages in the current user's collection (sender)
  //     await _firestore.collection('users').doc(currentUserId)
  //         .collection('chats')
  //         .doc(chatId)  // chat with the property owner
  //         .collection('messages')
  //         .add({
  //       'senderId': currentUser?.uid,
  //       'message': _messageController.text,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Also store messages in the property owner's collection (receiver)
  //     await _firestore.collection('users').doc(propertyOwnerId)
  //         .collection('chats')
  //         .doc(chatId)  // chat with the current user
  //         .collection('messages')
  //         .add({
  //       'senderId': currentUser?.uid,
  //       'message': _messageController.text,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //
  //     // Clear the message input
  //     _messageController.clear();
  //   }
  // }
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'No timestamp available'; // Or handle null cases as needed
    }
    DateTime date = timestamp.toDate();
    return '${date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 8,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      }, // Open drawer on tap
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF5F4F8),
                        child: Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: widget.userimage.isNotEmpty
                            ? NetworkImage(widget.userimage!)
                            : AssetImage('assets/images/person1.png') as ImageProvider,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(widget.propertyOwnerName,style: TextStyle(fontSize: 18, fontFamily: "Schyler", color: Color(0xFF204D6C)),
)

                  ],
                ),

                // Notification and Profile Icon
                 CircleAvatar(
                            radius: 25,
                   backgroundColor: Color(0xFFF5F4F8),
                            child: Icon(Icons.call, color: Color(0xFF234F68)),
                          ),

                  ],


            ),
          ),

    Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('chats')
        .doc(_generateChatId(currentUser!.uid, widget.propertyOwnerId)) // Use the same chatId
        .collection('messages')
        .orderBy('timestamp')
        .snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    }

    var messages = snapshot.data!.docs;
    return SingleChildScrollView(
    child: Container(
    margin: EdgeInsets.all(8), // Margin around the Card
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.all(8), // Padding inside the Card
    child: ListView.builder(
    shrinkWrap: true, // Ensures the ListView takes only the necessary height
    physics: NeverScrollableScrollPhysics(), // Prevents scrolling if inside a scrollable parent
    itemCount: messages.length,
    itemBuilder: (context, index) {
    var message = messages[index];
    bool isSender = message['senderId'] == currentUser?.uid;

    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4), // Space between messages
    child: Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    // Show user image
    if (!isSender)
    CircleAvatar(
    radius: 20,
    backgroundImage: NetworkImage(widget.userimage),
    ),
    SizedBox(width: 8),
    // Show message bubble
    Container(
    padding: EdgeInsets.all(12), // Padding inside the message bubble
    decoration: BoxDecoration(
    color: isSender ? Colors.white : Color(0xFF234F68),
    borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    message['message'],
    style: TextStyle(
    color: isSender ? Colors.black : Colors.white,
    fontFamily: "family2",
    ),
    ),
    SizedBox(height: 4),
    // Show timestamp
    Text(
    _formatTimestamp(message['timestamp'] as Timestamp?),
    style: TextStyle(
    color: Colors.grey,
    fontSize: 12,
    ),
    ),
    ],
    ),
    ),
    SizedBox(width: 8),
    // Show sender's image
    // if (isSender)
    // CircleAvatar(
    // radius: 20,
    // backgroundImage: NetworkImage(currentUser?.photoURL ?? 'default-image-url'),
    // ),
    ],
    ),
    ),
    );
    },
    ),
    ),
    ],
    ),
    ),
    );
    },
    ),
    ),

// Method to format the timestamp into a readable format
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (value) {
                      _sendMessage();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: CircleAvatar(
                          child: Icon(Icons.camera_alt_outlined, color: Colors.black),
                          // backgroundColor: Colors.white,
                        ),
                      // ),
                      hintText: 'Type a message',

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFF5F4F8),
     width: 1.0), // Unfocused color

                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(                  color: Color(0XFFF5F4F8),
                            width: 1.0), // Unfocused color
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  child: Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                  backgroundColor: Color(0xFF8BC83F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
