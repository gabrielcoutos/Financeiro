import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowContrato extends StatefulWidget {
  final String uid;
  ShowContrato({this.uid});
  @override
  _ShowContratoState createState() => _ShowContratoState();
}

class _ShowContratoState extends State<ShowContrato> {
  bool downloading = true;
  String contrato;

  @override
  void initState() {
    super.initState();
    _getContrato();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contrato"),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: downloading? Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),),
        ): 
        Container(
          padding: EdgeInsets.all(15.0),
          color: Colors.grey[500].withOpacity(0.5),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Text(contrato),
            ),
          ),
        )
      ),
    );
  }

  Future<void> _getContrato() async{
    print(widget.uid);
    StringBuffer cont = StringBuffer();
    try{
      final StorageReference reference = FirebaseStorage.instance.ref().child(widget.uid+".txt");
      final String url = await reference.getDownloadURL();
      HttpClient client = new HttpClient();
      client.getUrl(Uri.parse(url))
          .then((request){
        return request.close();
      }).then((HttpClientResponse response){
        response.transform(utf8.decoder).listen((valor) => cont.write(valor),onDone: () {
          contrato = cont.toString();
          setState(() {
            downloading = false;
          });
        },onError: (erro){
          print(erro);
          Fluttertoast.showToast(
              msg: "Erro ao carregar os dados, tente novamente.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black.withOpacity(0.7),
              textColor: Colors.white,
              fontSize: 12.0
          );
          Navigator.pop(context);
        });
      });
    }catch (e){
      print(e);
      Fluttertoast.showToast(
          msg: "Erro ao carregar os dados, tente novamente.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 12.0
      );
      Navigator.pop(context);
    }

  }
}

