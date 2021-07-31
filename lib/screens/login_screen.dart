import 'package:fast_chat/screens/chat_screen.dart';
import 'package:fast_chat/sources .dart';
import 'package:flutter/material.dart';
import 'package:fast_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id ='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool spinner=false;
  final _auth = FirebaseAuth.instance;
  String? mail;
  String? password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
            inAsyncCall: spinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 40
                ),
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child : Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    mail=value;
                  },
                  decoration: kTextFieldDecoration
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  onChanged: (value) {
                      password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password.')
                ),
                SizedBox(
                  height: 24.0,
                ),
                MainButton(colour: Colors.lightBlueAccent,ontap: ()async{
                  try {
                    setState(() {
                      spinner = true;
                    });
                     await _auth.signInWithEmailAndPassword(
                        email: mail!, password: password!);
                    Navigator.pushNamed(context, ChatScreen.id);
                    setState(() {
                      spinner = false;
                    });
                  }
                  catch(e){
                    setState(() {
                      spinner = false;
                    });
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Wrong credentials",
                      desc: "Please check the email and password 😄",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                },word: 'login')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
