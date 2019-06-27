import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/recuperar_senha_bloc.dart';
import 'package:fundo_fe/widgets/alert_dialog.dart';

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  final _recoveryBloc = RecuperarSenhaBloc();
  StreamSubscription  listening;

  @override
  void initState() {
    super.initState();
    listening = _recoveryBloc.outState.listen((state){
      switch(state){
        case RecoverState.SUCCESS:
          showDialog(context: context,builder: (context)=> MyAlertDialog(icone: Icon(Icons.check_circle_outline,color: Colors.green[900],size: 75.0,),textoCentral: "Um e-mail para realizar a troca de senha foi enviado",textoBotao: "Certo",corBotao: Colors.green[900],onTap: (){Navigator.pop(context);Navigator.pop(context);},) );
          break;

        case RecoverState.ERROR:
          showDialog(context: context,builder: (context)=> MyAlertDialog(icone: Icon(Icons.error_outline,color: Colors.red[900],size: 75.0,),textoCentral: "Verifique se digitou o e-mail corretamente",textoBotao: "Certo",corBotao: Colors.red[900],onTap: ()=>Navigator.pop(context),) );
          break;

        case RecoverState.ENVIANDO:
        case RecoverState.IDLE:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "imagens/logo_FFE.png",
                      height: 130.0,
                      width: 130.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Recuperação de senha",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<String>(
                      stream: _recoveryBloc.outEmail,
                      builder: (context, snapshot) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: "Insira o e-mail",
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[900])
                            ),
                            errorText: snapshot.hasError ? snapshot.error : null,
                          ),
                          onChanged: _recoveryBloc.changeEmail,
                        );
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<String>(
                            stream: _recoveryBloc.outEmail,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                color: Colors.indigo[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: StreamBuilder<RecoverState>(
                                  stream: _recoveryBloc.outState,
                                  builder: (context, snapshot) {
                                    return snapshot.data != RecoverState.ENVIANDO ? Text("Recuperar",style: TextStyle(color: Colors.white,fontSize: 18.0))
                                    :CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),);
                                  }
                                ),
                                onPressed: snapshot.data == null ? null : (){
                                  _recoveryBloc.recoverPassword();
                                }
                              );
                            }
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.red[900],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Text("Cancelar",style: TextStyle(color: Colors.white,fontSize: 18.0)),
                            onPressed: ()=>Navigator.pop(context),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    listening.cancel();
  }

}
