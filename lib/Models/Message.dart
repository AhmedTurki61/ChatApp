
import 'package:char_app/widgets/constants.dart';


class Message{
  final String message;
   final  String id; 
   final String username;
    final String  time;
  Message(this.message, this.id, this.username, this.time);
  factory  Message.fromJson(jsonData){

           return Message(jsonData[kmessage],jsonData['id'],jsonData['username'], jsonData[kCreatedAt]);

  } 

}