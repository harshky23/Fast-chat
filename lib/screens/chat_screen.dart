import 'package:flutter/material.dart';
import 'package:fast_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _store = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id ='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  String? message;

  @override
  void initState() {
    super.initState();
    getInfo();
  }
  void getInfo(){
    try{
    final user =  _auth.currentUser;
    if(user != null){
      loggedInUser=user;
    }}
    catch(e){print(e);}
  }
  // void getStream() async{
  //   await for(var snapshot in _store.collection('messages').snapshots()){
  //       for(var message in snapshot.docs){
  //         print(message.data());
  //       }
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                 _auth.signOut();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message= value;//Do something with the user input.

                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageController.clear();
                      _store.collection('messages').add({
                        'text' : message,
                        'id' : loggedInUser!.email,
                        'time': DateTime.now()
                      });//Implement send functionality.

                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.lightBlueAccent,
                      size: 30.0,
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection('messages').orderBy('time').snapshots(),
        builder: (context ,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final  messages = snapshot.data!.docs;
          List<Bubble> messagesWidgets =[];
          for(var message in messages){
            final messageID = message.get('id');
            final messageText = message.get('text');
            final Timestamp timestamp = message['time'] as Timestamp;
            final DateTime dateTime = timestamp.toDate();
            final dateString = DateFormat('d-M-y || H:mm').format(dateTime);
            final checkID = loggedInUser!.email;
            final messagesBubble = Bubble(dateString,messageID,messageText,messageID==checkID);
            messagesWidgets.add(messagesBubble);
          }
          return
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
                child: ListView(
                  children : messagesWidgets,
                ),
              ),
            );
        }
    );
  }
}



class Bubble extends StatelessWidget {
Bubble(this.time,this.id,this.text,this.isTrue);
final String time;
 final String  id;
 final String text;
 final bool isTrue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: (isTrue==true)?CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(time,style: TextStyle(color: Colors.white)),
          // Text(id,style: TextStyle(color: Colors.white),),
          Material(
            color: (isTrue==true)? Colors.blue : Colors.black,
            borderRadius: (isTrue==true)? kSelf: kOther,
            child:
                GestureDetector(
                  onLongPress: (){
                    Alert(context: context, title: "Message Detail", desc: "Date and Time : $time\nMail ID : $id").show();
                  },
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
                    child: Text(text,style:
                    TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                    ),),
                  ),
                ),
            ),
        ],
      ),
    );
  }
}
