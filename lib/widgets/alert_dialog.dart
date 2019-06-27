
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {

  final String textoCentral;
  final String textoBotao;
  final Icon icone;
  final Color corBotao;
  final Function onTap;

  MyAlertDialog({this.icone,this.textoBotao,this.textoCentral,this.corBotao,this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      contentPadding: EdgeInsets.only(top:10.0),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icone,
            Container(margin: EdgeInsets.only(top:15.0),child: Text(textoCentral,textAlign: TextAlign.center,)),
            InkWell(
              child: Container(
                  margin: EdgeInsets.only(top:20.0,),
                  padding: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: corBotao,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
                  ),
                  child: FlatButton(
                      onPressed: onTap,
                      child: Text(
                        textoBotao,
                        style: TextStyle(color: Colors.white,fontSize: 15.0),
                        textAlign: TextAlign.center,
                      )
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
