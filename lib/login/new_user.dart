import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class NewUser extends StatelessWidget {

  final Icon icon;
  final String text;

  NewUser({this.icon,this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              Text(text,
              style: TextStyle(fontSize: 20.0,),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
