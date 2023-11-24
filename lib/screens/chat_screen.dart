import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_prishu/constants.dart';
import 'package:flash_chat_prishu/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String messageText = '';
  final _messageTextEditingController = TextEditingController();
  int a = 1;

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        // print('Logged in User EmailId: ${loggedInUser.email}');
      }
    } catch (e) {
      print('Exception in Chat Screen: $e');
    }
  }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('chats').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    print('ab: $a');
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                //Implement logout functionality
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        //Implement send functionality.
                        _firestore.collection('chats').add({
                          'text': messageText,
                          'sender': loggedInUser!.email,
                          'dttm': DateTime.now(),
                          //DateFormat("dd-MM-yy HH:mm:ss").format(DateTime.now()),
                        });
                        _messageTextEditingController.clear();
                      } catch (e) {
                        print('Exception in Chat Send Button: $e');
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('chats').orderBy('dttm', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.pink,
                ),
              ),
            ],
          );
        }

        final messages = snapshot.data!.docs;
        // final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messagesWidget = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final datetm = DateFormat("dd-MM-yy HH:mm:ss").format(message.data()['dttm'].toDate());
          final currentUser = loggedInUser!.email;
          if (messageSender == currentUser) {}
          // print('Curr User: $currentUser');
          final messageDocument = MessageBubble(
            messageSender: messageSender,
            messageText: messageText,
            dttm: datetm,
            isMe: messageSender == currentUser,
          );
          messagesWidget.add(messageDocument);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messagesWidget,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.messageSender,
    required this.messageText,
    required this.dttm,
    required this.isMe,
  });

  final messageText, messageSender, dttm;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // print('isMe: $isMe');
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Text(
            dttm.toString(),
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.pink.shade300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  messageText,
                  style: TextStyle(
                    fontSize: 27.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
