
import 'package:fast_chat/screens/login_screen.dart';
import 'package:fast_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fast_chat/sources .dart';

class WelcomeScreen extends StatefulWidget {
  static const String id ='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  static const colorizeTextStyle = TextStyle(
    fontSize: 45.0,
    fontFamily: 'Horizon',
    fontWeight: FontWeight.bold,
  );
 late AnimationController controller;
 late Animation animationColor,animationLogo;
  @override
  void initState() {
    super.initState();
    controller = AnimationController( duration : Duration(seconds: 2),vsync: this);
    animationColor = ColorTween(begin: Colors.blue , end: Colors.white).animate(controller);
    animationLogo = CurvedAnimation(parent:controller,curve : Curves.decelerate);
    controller.forward();
    controller.addListener(() {setState(() {});});
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animationColor.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container( child :Image.asset('images/logo.png'),
                  height: animationLogo.value*60,
                ),),
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
          'Fast Chat',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            )],
            ),
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(left: 250),
              child: Text('- By Harsh',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 48.0,
            ),
            MainButton(colour: Colors.lightBlueAccent,ontap: () {Navigator.pushNamed(context, LoginScreen.id);},word: 'login'),
            MainButton(colour: Colors.blue,ontap: () {Navigator.pushNamed(context, RegistrationScreen.id);},word: 'Register')
    ])));
  }
}
