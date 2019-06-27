import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fundo_fe/model/Info_contato.dart';

import 'edit_user.dart';

class UserTile extends StatelessWidget {

  final DocumentSnapshot usuario;
  var controllerCep = MaskedTextController(text: "",mask: "00000-000");

  UserTile(this.usuario){
    controllerCep.updateText(usuario.data[InfoContato.CEP]);
  }
  @override
  Widget build(BuildContext context) {

    TextStyle colorTitle;
    if(usuario[InfoContato.APROVADO] == InfoContato.SITUACAO_PENDENTE){
      colorTitle =TextStyle(color:Colors.indigo);
    }else if(usuario[InfoContato.APROVADO] == InfoContato.SITUACAO_APROVADO){
      colorTitle =TextStyle(color:Colors.green[900]);
    }else{
      colorTitle =TextStyle(color:Colors.red);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(usuario.documentID),
          title: Text(
             usuario[InfoContato.EMAIL],
            style: colorTitle,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 15.0),child: Text("Dados Pessoais",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
                      Row(
                        children: <Widget>[
                          Text(usuario[InfoContato.NAME] != null ? usuario[InfoContato.NAME]: "Sem nome" ,textAlign: TextAlign.left,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(usuario[InfoContato.EMAIL]!= null ? usuario[InfoContato.EMAIL]: "Sem e-mail",textAlign: TextAlign.left,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("RG: ${usuario[InfoContato.RG]}"),
                          Text("CPF: ${usuario[InfoContato.CPF]}"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Tel: ${usuario[InfoContato.CELULAR]}",textAlign: TextAlign.left,),
                        ],
                      ),
                      Container(margin: EdgeInsets.only(top:15.0),child: Text("Endereço",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
                      Text("Endereço: ${usuario.data[InfoContato.ENDERECO]}",textAlign: TextAlign.left,),
                      Text("Bairro: ${usuario.data[InfoContato.BAIRRO]}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Número: ${usuario.data[InfoContato.NUM]}"),
                          Text("CEP: ${controllerCep.text}"),
                        ],
                      ),
                      Text("Cidade: ${usuario.data[InfoContato.CIDADE]}"),
                      Text("Estado: ${usuario.data[InfoContato.ESTADO]}"),



                      Container(margin: EdgeInsets.only(top:15.0),child: Text("Dados Bancários",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
                      Row(
                        children: <Widget>[
                          Text("Banco: ${usuario[InfoContato.BANCO]}",textAlign: TextAlign.left,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Agencia: ${usuario[InfoContato.AGENCIA]}",textAlign: TextAlign.left,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Conta: ${usuario[InfoContato.CONTA]}",),
                          Text("Dígito: ${usuario[InfoContato.DIGITO]}",),
                        ],
                      ),

                    ],
                  ),
                  Divider(),
                  RaisedButton(
                    onPressed: (){
                      usuario.reference.updateData({
                        InfoContato.APROVADO: InfoContato.SITUACAO_APROVADO
                      });
                    },
                    color: Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    textColor: Colors.white,
                    child: Text("Aprovar"),
                  ),
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>EditUsuario(usuarioEdit: usuario,)));
                    },
                    color: Colors.indigo[900],
                    textColor: Colors.white,
                    child: Text("Editar"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      usuario.reference.updateData({
                        InfoContato.APROVADO: InfoContato.SITUACAO_REPROVADO
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.red[900],
                    child: Text("Reprovar"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
