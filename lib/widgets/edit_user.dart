import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:fundo_fe/widgets/alert_dialog.dart';

class EditUsuario extends StatefulWidget {
  final  DocumentSnapshot usuarioEdit;
  final bool isAdm;
  bool loading = false;
  EditUsuario({@required this.usuarioEdit,this.isAdm});
  @override
  _EditUsuarioState createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  var rgMasked = MaskedTextController(mask: "00.000.000");
  var cpfMasked = MaskedTextController(mask: "000.000.000-00");
  TextEditingController _endController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();
  TextEditingController _bancoController = TextEditingController();
  TextEditingController _agenciaController = TextEditingController();
  TextEditingController _contaController = TextEditingController();
  TextEditingController _digitoController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List<DropdownMenuItem<String>> listEstado = [];
  List<DropdownMenuItem<String>> listBancos = [];
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    listEstado = Util.loadEstados();
    _loadBancos();
    _endController.text = widget.usuarioEdit[InfoContato.ENDERECO];
    _bairroController.text = widget.usuarioEdit[InfoContato.BAIRRO];
    _numeroController.text = widget.usuarioEdit[InfoContato.NUM];
    _cidadeController.text = widget.usuarioEdit[InfoContato.CIDADE];
    _estadoController.text = widget.usuarioEdit[InfoContato.ESTADO];
    _bancoController.text = widget.usuarioEdit[InfoContato.BANCO];
    _agenciaController.text = widget.usuarioEdit[InfoContato.AGENCIA];
    _contaController.text = widget.usuarioEdit[InfoContato.CONTA];
    _digitoController.text = widget.usuarioEdit[InfoContato.DIGITO];
    rgMasked.updateText(widget.usuarioEdit[InfoContato.RG]);
    cpfMasked.updateText(widget.usuarioEdit[InfoContato.CPF]);
    _nameController.text = widget.usuarioEdit[InfoContato.NAME];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_nameController.text),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16.0,horizontal: 4.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: !widget.isAdm,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide()
                        )
                      ),
                      controller: _nameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "E-mail",
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide()
                          ),
                      ),
                      initialValue: widget.usuarioEdit[InfoContato.EMAIL],
                      enabled: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "CPF",
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide()
                          )
                      ),
                      controller: cpfMasked,
                      enabled: !widget.isAdm,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "RG",
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide()
                          )
                      ),
                      controller: rgMasked,
                      keyboardType: TextInputType.number,
                      enabled: !widget.isAdm,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _endController,
                      decoration: InputDecoration(
                        labelText: "Endereço",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira um endereço";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _bairroController,
                      decoration: InputDecoration(
                        labelText: "Bairro",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira um Bairro";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: InputDecoration(
                        labelText: "Número",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira o número";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        labelText: "Cidade",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira a cidade";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      items: listEstado,
                      value: _estadoController.text == null ? " " : _estadoController.text,
                      decoration: InputDecoration(
                        labelText: "Estado",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ) ,
                      onChanged: (estado){
                        setState(() {
                          _estadoController.text = estado;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      items: listBancos,
                      value: _bancoController.text == null ? " " : _bancoController.text,
                      decoration: InputDecoration(
                        labelText: "Banco",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                      onChanged: (banco){
                        setState(() {
                          _bancoController.text= banco;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _agenciaController,
                      decoration: InputDecoration(
                        labelText: "Agência",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _contaController,
                      decoration: InputDecoration(
                        labelText: "Conta",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _digitoController,
                      decoration: InputDecoration(
                        labelText: "Dígito",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide()
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: widget.loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) :Text("Confirmar",style: TextStyle(color: Colors.white),),
                            color: Colors.green[900],
                            onPressed: (){
                              setState(() {
                                widget.loading = true;
                              });
                              widget.usuarioEdit.reference.updateData({
                                InfoContato.ENDERECO:_endController.text,
                                InfoContato.BAIRRO:_bairroController.text,
                                InfoContato.NUM :_numeroController.text,
                                InfoContato.CIDADE:_cidadeController.text,
                                InfoContato.ESTADO: _estadoController.text,
                                InfoContato.BANCO: _bancoController.text,
                                InfoContato.AGENCIA:_agenciaController.text,
                                InfoContato.CONTA:  _contaController.text,
                                InfoContato.DIGITO: _digitoController.text,
                                InfoContato.NAME : _nameController.text,
                                InfoContato.RG: rgMasked,
                                InfoContato.CPF: cpfMasked,
                              }).then((value){
                                showDialog(
                                  context: context,
                                  builder: (context)=>MyAlertDialog(
                                    icone: Icon(Icons.check_circle_outline,color: Colors.green[900],size: 75.0,),
                                    corBotao: Colors.green[900],
                                    textoBotao: "Ok",
                                    textoCentral: "Edição realizada com sucesso",
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },),
                                );
                              },onError: (e){

                              }).catchError((e){
                                showDialog(
                                  context: context,
                                  builder: (context)=>MyAlertDialog(
                                    icone: Icon(Icons.error_outline,color: Colors.red[900],size: 75.0,),
                                    corBotao: Colors.red[900],
                                    textoBotao: "Ok",
                                    textoCentral: "Ocorreu um erro\n$e",
                                    onTap: ()=>Navigator.pop(context),),
                                );
                              });
                            },
                            splashColor: Colors.indigo[900],
                            animationDuration: Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text("Cancelar",style: TextStyle(color: Colors.white),),
                            color: Colors.red[900],
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),

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
}
