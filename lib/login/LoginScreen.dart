import 'package:flutter/material.dart';
import 'package:fundo_fe/admin/home_admin.dart';
import 'package:fundo_fe/blocs/login_bloc.dart';
import 'package:fundo_fe/login/sign_up.dart';
import 'package:fundo_fe/user/home_user.dart';
import 'package:fundo_fe/widgets/alert_dialog.dart';
import 'package:fundo_fe/widgets/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RecuperarSenha.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{

  final _loginBloc = LoginBloc();
  AnimationController _animationController;
  bool manterConectado = false;
  var listening;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this,duration: Duration(seconds: 2));
    listening =_loginBloc.outState.listen((state){
      switch(state){
        case LoginState.ADMIN:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>HomeAdmin())
          );
          break;
        case LoginState.USER:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>HomeUser(_loginBloc.userAuth))
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context,builder: (context)=> MyAlertDialog(icone: Icon(Icons.error_outline,color: Colors.red[900],size: 75.0,),textoCentral: "Erro ao realizar o login\nverifique seu e-mail ou senha",textoBotao: "Certo",corBotao: Colors.red[900],onTap: ()=>Navigator.pop(context),) );
          break;
        case LoginState.USERNOTAPROVED:
          showDialog(context: context,builder: (context)=> MyAlertDialog(icone: Icon(Icons.report_problem,color: Colors.yellow[900],size: 75.0,),textoCentral: "Seu cadastro ainda não foi aprovado\n pelo administrador, aguarde...",textoBotao: "Obrigado",corBotao: Colors.red[900],onTap: ()=>Navigator.pop(context),) );
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loginBloc.dispose();
    listening.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: StreamBuilder<Object>(
        stream: _loginBloc.outState,
        builder: (context, snapshotMaior) {
          return SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                           Image.asset(
                             "imagens/logo_FFE.png",
                             height: 130.0,
                             width: 130.0,
                           ),
                            Divider(),
                            InputField(
                              label: "E-mail",
                              obscure: false,
                              type:TextInputType.emailAddress,
                              stream: _loginBloc.outEmail,
                              onChanged: _loginBloc.changeEmail,
                            ),
                            Divider(),
                            InputField(
                              label: "Senha",
                              obscure: true,
                              type: TextInputType.text,
                              stream: _loginBloc.outSenha,
                              onChanged: _loginBloc.changeSenha,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  value: manterConectado,
                                  onChanged: (value){
                                    _saveConectado(value);
                                    setState(() {
                                      manterConectado = value;
                                    });
                                  },
                                  activeColor: Colors.indigo[900],
                                ),
                                Text("Manter conectado")
                              ],
                            ),
                            StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  child: RaisedButton(
                                    color: Colors.indigo[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: snapshotMaior.data != LoginState.LOADING ? Text(
                                      "Entrar",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0
                                      ),
                                    ): CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) ,
                                    onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                    disabledColor: Colors.indigo[900].withAlpha(140),
                                  ),
                                  height: 50.0,
                                );
                              }
                            ),
                           FlatButton(
                             child:  Text(
                               "Cadastrar-se",
                               style: TextStyle(fontSize: 15.0),
                               textAlign: TextAlign.center,

                             ),
                             onPressed: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUp()));
                             },

                           ),
                            FlatButton(
                              child: Text(
                                "Recuperar senha",
                                style: TextStyle(fontSize: 13.0,color: Colors.black38),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecuperarSenha())),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  void _saveConectado(bool value) async{
    final prefs =  await SharedPreferences.getInstance();
    prefs.setBool("manterConectado", value);

  }
}
