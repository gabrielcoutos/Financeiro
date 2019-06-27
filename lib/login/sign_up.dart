import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundo_fe/blocs/signup_bloc.dart';
import 'package:fundo_fe/login/new_user.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:fundo_fe/widgets/input_field.dart';
import 'package:masked_text/masked_text.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _cpfController = TextEditingController();
  final _orgEmissorController = TextEditingController();
  final _dataNasciController = TextEditingController();
  final _celularController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _endController = TextEditingController();
  final _numController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  String estadoController;
  final _agenciaController = TextEditingController();
  final _contaController = TextEditingController();
  final _digitoController = TextEditingController();

  List<DropdownMenuItem<String>> listEstado = [];
  List<DropdownMenuItem<String>> listBancos = [];
  final _signUpBloc = SignUpBloc();


  @override
  void initState() {
    super.initState();
    listEstado = Util.loadEstados();
    _loadBancos();
    _signUpBloc.outState.listen((state){
      switch(state){
        case CadastroState.SUCCESS:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewUser(
              icon: Icon(Icons.check,color: Colors.green[900],size: 150.0,),
              text: "Cadastro realizado com sucesso. Assim que for aprovado você será notificado.\n Obrigado!",
            ))
          );
          break;
        case CadastroState.FAIL:
          showDialog(context: context,builder: (context)=> AlertDialog(
            title: Text("Erro ao cadastrar"),
            content: Text("Ocorreu algum erro, tente novamente!"),
          ));
          break;
        case CadastroState.LOADING:
        case CadastroState.IDLE:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: StreamBuilder<CadastroState>(
          stream: _signUpBloc.outState,
          initialData: CadastroState.LOADING,
          builder: (context, snapshot) {
            switch(snapshot.data){
              case CadastroState.LOADING:
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),),);
              case CadastroState.FAIL:
              case CadastroState.SUCCESS:
              case CadastroState.IDLE:
              return Form(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 16.0, top: 32.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Dados Pessoais
                        Text(
                          "Dados Pessoais",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        InputField(
                          label: "Nome",
                          obscure: false,
                          type: TextInputType.text,
                          tamanho: 30,
                          stream: _signUpBloc.outName,
                          onChanged: _signUpBloc.changedName,
                        ),
                        InputField(
                          label: "RG",
                          obscure: false,
                          type: TextInputType.number,
                          tamanho: 8,
                          stream: _signUpBloc.outRg,
                          onChanged: _signUpBloc.changedRg,
                        ),
                        InputField(
                          label: "Orgão emissor",
                          obscure: false,
                          type: TextInputType.text,
                          controller: _orgEmissorController,
                          stream: _signUpBloc.outOrgEmissor,
                          onChanged: _signUpBloc.changedOrgEmissor,
                          tamanho: 3,
                        ),
                        MaskedTextField(
                          maskedTextFieldController: _cpfController,
                          mask: "xxx.xxx.xxx-xx ",
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputDecoration: InputDecoration(
                              labelText: "CPF",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue[900])),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          onChange: (value){
                            _signUpBloc.changedCpf(value);
                          },
                        ),
                        MaskedTextField(
                          maskedTextFieldController: _dataNasciController,
                          mask: "xx/xx/xxxx ",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          inputDecoration: InputDecoration(
                              labelText: "Data nascimento",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue[900])),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          onChange:(value){
                            _signUpBloc.changedDataNasc(value);
                          } ,
                        ),
                        MaskedTextField(
                          maskedTextFieldController: _celularController,
                          mask: "(xx) xxxxxxxxx ",
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputDecoration: InputDecoration(
                              labelText: "Celular",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue[900])),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          onChange: _signUpBloc.changedCelular,
                        ),
                        InputField(
                          label: "Email",
                          obscure: false,
                          type: TextInputType.emailAddress,
                          controller: _emailController,
                          stream: _signUpBloc.outEmail,
                          onChanged: _signUpBloc.changedEmail,
                          tamanho: 40,
                        ),
                        InputField(
                          label: "Senha",
                          obscure: true,
                          type: TextInputType.text,
                          controller: _senhaController,
                          tamanho: 15,
                          stream: _signUpBloc.outSenha,
                          onChanged: _signUpBloc.changedSenha,
                        ),
                        InputField(
                          label: "Confirmar senha",
                          obscure: true,
                          type: TextInputType.text,
                          controller: _confirmarSenhaController,
                          tamanho: 15,
                          stream: _signUpBloc.outConfirmaSenha,
                          onChanged: _signUpBloc.changedConfirmaSenha,
                        ),
                        Divider(),
                        Text(
                          "Informações de Contato",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        InputField(
                          label: "CEP",
                          obscure: false,
                          type: TextInputType.number,
                          controller: _cepController,
                          tamanho: 8,
                          formatter: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          stream: _signUpBloc.outCEP,
                          onChanged: _signUpBloc.changedCEP,
                        ),
                        InputField(
                          label: "Endereço",
                          obscure: false,
                          type: TextInputType.text,
                          controller: _endController,
                          tamanho: 60,
                          stream: _signUpBloc.outEndereco,
                          onChanged: _signUpBloc.changedEndereco,
                        ),
                        InputField(
                          label: "Número",
                          obscure: false,
                          type: TextInputType.number,
                          controller: _numController,
                          tamanho: 5,
                          stream: _signUpBloc.outNumero,
                          onChanged: _signUpBloc.changedNumero,
                        ),
                        InputField(
                          label: "Bairro",
                          obscure: false,
                          type: TextInputType.text,
                          controller: _bairroController,
                          tamanho: 25,
                          stream: _signUpBloc.outBairro,
                          onChanged: _signUpBloc.changedBairro,
                        ),
                        InputField(
                          label: "Cidade",
                          obscure: false,
                          type: TextInputType.text,
                          controller: _cidadeController,
                          tamanho: 35,
                          stream: _signUpBloc.outCidade,
                          onChanged: _signUpBloc.changedCidade,
                        ),
                        StreamBuilder<Object>(
                            stream: _signUpBloc.outEstado,
                            builder: (context, snapshot) {
                              return DropdownButtonFormField(
                                value: _signUpBloc.estadoValue,
                                items: listEstado,
                                decoration: InputDecoration(
                                    labelText: "Estado",
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue[900])),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black))),
                                onChanged: _signUpBloc.changedEstado,
                              );
                            }),
                        Divider(),
                        Text(
                          "Dados bancários",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        StreamBuilder<String>(
                          stream: _signUpBloc.outBanco,
                          builder: (context,snapshot){
                            return DropdownButtonFormField(
                              items: listBancos,
                              value: _signUpBloc.bancoValue,
                              decoration: InputDecoration(
                                  labelText: "Banco",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.blue[900])),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black))),
                              onChanged: _signUpBloc.changedBanco,
                            );
                          },
                        ),
                        Container(margin: EdgeInsets.only(bottom: 15.0),),
                        InputField(
                          label: "Agência",
                          obscure: false,
                          type: TextInputType.number,
                          controller: _agenciaController,
                          tamanho: 5,
                          stream: _signUpBloc.outAgencia,
                          onChanged: _signUpBloc.changedAgencia,
                        ),
                        InputField(
                          label: "Conta",
                          obscure: false,
                          type: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: _contaController,
                          tamanho: 7,
                          stream: _signUpBloc.outConta,
                          onChanged: _signUpBloc.changedConta,
                        ),
                        InputField(
                          label: "Dígito",
                          obscure: false,
                          type: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: _digitoController,
                          tamanho: 2,
                          stream: _signUpBloc.outDigito,
                          onChanged: _signUpBloc.changedDigito,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            StreamBuilder<bool>(
                                stream: _signUpBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    child: RaisedButton(
                                      color: Colors.indigo[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)),
                                      child: Text(
                                        "Cadastrar",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20.0),
                                      ),
                                      onPressed: snapshot.hasData
                                          ? _signUpBloc.submitnewUser
                                          : null,
                                      disabledColor:
                                      Colors.indigo[900].withAlpha(140),
                                    ),
                                    height: 50.0,
                                  );
                                }),
                            SizedBox(
                              child: RaisedButton(
                                color: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  "Cancelar",
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              height: 50.0,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        ));
  }

  void _loadBancos() async{
    listBancos = [];
    String data = await DefaultAssetBundle.of(context).loadString("bancos.json");
    List<dynamic> bancos = jsonDecode(data);
    bancos.forEach((banco){
      String codeName = banco["Code"] +"-"+ banco["Name"];
      if(codeName.length>=30){
        codeName = codeName.substring(0,30);
      }
      listBancos.add(new DropdownMenuItem(child: Text(codeName,style: TextStyle(fontSize: 12.0),),value: codeName,));
    });
    setState(() {

    });
  }

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

}
