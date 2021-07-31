import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  MainButton({required this.colour,required this.ontap,required this.word});
  final Color colour;
  final Function ontap;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed:()=>ontap(),
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            word,style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
