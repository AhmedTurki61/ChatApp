import 'package:char_app/Models/Message.dart';
import 'package:char_app/pages/loading_data_page.dart';
import 'package:char_app/widgets/chat.dart';
import 'package:char_app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.email, required this.username});

  final _controller = ScrollController();
  final String? username;
  final String? email;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  static String id = 'ChatPage';
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagelist = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagelist.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kprimaryColor,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      width: 50,
                    ),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagelist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messagelist[index].id == email
                          ? chatbubble(
                              message: messagelist[index],
                            )
                          : ChatBubbleForFriend(
                              message: messagelist[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction
                        .send, // Changes keyboard button to "Send"
                    onSubmitted: (_) =>
                        sendMessage(), // Sends message on keyboard "Send" press
                    decoration: InputDecoration(
                      hintText: 'Send message',
                      suffix: GestureDetector(
                        onTap: sendMessage, // Sends message on icon tap
                        child: const Icon(Icons.send, color: kprimaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: kprimaryColor),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kprimaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return LoadingDataPage();
        }
      },
    );
  }

  void sendMessage() {
    DateTime now = DateTime.now();
String formattedTime = DateFormat.Hm().format(now);
    if (controller.text.isNotEmpty) {
      messages.add({
        'message': controller.text,
        kCreatedAt: formattedTime,
        'id': email,
        'username': username,
      });
      controller.clear();
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}

String formatTime(DateTime time) {
  return DateFormat('hh:mm a')
      .format(time); // Format to "11:06 PM" or "11:06 AM"
}
