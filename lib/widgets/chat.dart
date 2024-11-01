import 'package:char_app/Models/Message.dart';
import 'package:char_app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class chatbubble extends StatelessWidget {
  const chatbubble({super.key, required this.message});
  final Message message;
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
        margin: const EdgeInsets.fromLTRB(15, 5, 10, 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: kprimaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: const TextStyle(fontSize: 15, color: Colors.white),
              // textAlign: TextAlign.center,
            ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                     
                             message.time,
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                ),
        
          
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class ChatBubbleForFriend extends StatelessWidget {
  const ChatBubbleForFriend({super.key, required this.message });
  final Message message;
// final  String username;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
        margin: const EdgeInsets.fromLTRB(15, 5, 10, 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          color: Color(0xff006D84),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns text to the left
          children: [
         Opacity(
              opacity:
                  0.5, // Set a slightly higher opacity for better visibility
              child:  Text(
             message.username,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white, // Matches bubble text color
                ),
              ),
            ),
            const SizedBox(
                height: 5), // Adds space between 'You' and message text
            Text(
              message.message,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                 
             message.time,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
String formatTime(DateTime time) {
  return DateFormat('hh:mm a').format(time ); // Format to "11:06 PM" or "11:06 AM"
}
