import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:fundo_fe/widgets/ShowContrato.dart';

class InvestimentosAdminTile extends StatelessWidget {
  DocumentSnapshot _investimento;
  DocumentSnapshot _userInvestimento;
  String situacao;
  TextStyle titleStyle;
  int tempoInvestimento;

  InvestimentosAdminTile(this._investimento,this._userInvestimento){
    tempoInvestimento = tempoAporte();
    switch(_investimento.data[InfoContato.APROVADO]){
      case InfoContato.SITUACAO_APROVADO:
        situacao = "Aprovado";
        titleStyle = TextStyle(color: Colors.green[900],);
        break;
      case InfoContato.SITUACAO_REPROVADO:
        situacao = "Reprovado";
        titleStyle = TextStyle(color: Colors.red[900],);
        break;
      case InfoContato.SITUACAO_PENDENTE:
        situacao = "Em análise";
        titleStyle = TextStyle(color: Colors.indigo[900],);
        break;
      case InfoContato.RETIRADA_PENDENTE:
        situacao=" Resgate em análise";
        titleStyle = TextStyle(color: Colors.indigo[900],);
        break;
      case InfoContato.RETIRADA_APROVADA:
        situacao= "Resgatado";
        titleStyle = TextStyle(color: Colors.amber[900],);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 16 ),
      child: Card(
        child: ExpansionTile(
          title: Text("${_textTitle()}",style: titleStyle,),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25.0,child: Text("Informações do investimento",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                  Text("Aporte: ${Util.dataFormmat(_investimento.data["dataInicio"])}"),
                  Text("Aprovação: ${_investimento.data[InfoContato.DATA_APROVACAO]!= null ? Util.dataFormmat(_investimento.data[InfoContato.DATA_APROVACAO]): " - "}"),
                  _AddToRetirada(),
                  Text("Permanência: $tempoInvestimento meses"),
                  Text("Modalidade: ${_investimento.data["tipoAporte"]}"),
                  Text("Situação do aporte: $situacao"),
                  _valorInicialAcumulado(),
                  _totalResgatado(),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: Text("Informações do investidor",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                  ),
                  Text("${_userInvestimento.data[InfoContato.NAME]}"),
                  Text("${_userInvestimento.data[InfoContato.EMAIL]}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("RG: ${_userInvestimento.data[InfoContato.RG]}"),
                      Text("CPF: ${_userInvestimento.data[InfoContato.CPF]}"),
                    ],
                  ),
                  Text("Celular: ${_userInvestimento.data[InfoContato.CELULAR]}"),
                  Container(
                    margin: EdgeInsets.only(top:10.0,bottom: 10.0),
                    child: Text("Informações bancárias",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                  Text("Banco: ${_userInvestimento.data[InfoContato.BANCO]}"),
                  Text("Agência: ${_userInvestimento.data[InfoContato.AGENCIA]}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Conta: ${_userInvestimento.data[InfoContato.CONTA]}"),
                      Text("Dígito: ${_userInvestimento.data[InfoContato.DIGITO]}"),
                    ],
                  ),
                  FlatButton(
                    child: Text("Ver contrato",
                      style: TextStyle(color: Colors.green[900]),),
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowContrato(uid: _investimento.documentID,))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _AddToRetirada(){
    List<Widget> retirada = [];
    if(_investimento.data[InfoContato.APROVADO] == InfoContato.RETIRADA_PENDENTE){
      Text texto = Text("Solicitação resgate: ${Util.dataFormmat(_investimento.data[InfoContato.DATA_RETIRADA_SOLICITADA])}");
      retirada.add(texto);
    }else if(_investimento.data[InfoContato.APROVADO] == InfoContato.RETIRADA_APROVADA){
      Text texto =Text("Solicitação resgate: ${Util.dataFormmat(_investimento.data[InfoContato.DATA_RETIRADA_SOLICITADA])}");
      Text texto1 =Text("Confirmação resgate: ${Util.dataFormmat(_investimento.data[InfoContato.DATA_RETIRADA_CONFIRMADA])}");
      retirada.add(texto);
      retirada.add(texto1);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: retirada,);
  }
  Widget _valorInicialAcumulado(){
    if(_investimento.data["tipoAporte"] == "Acumulado"){
      return Text("Valor inicial: R\$${_investimento.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}");
    }else{
      return Container();
    }
  }

  String _textTitle(){
    String title;
    if(_investimento.data["tipoAporte"] == "Acumulado"){
      double valorTotal = Util.calculoAcumuladoFinal(_investimento["valorInvestido"], tempoInvestimento);
      title = "${_userInvestimento.data[InfoContato.NAME]} - R\$ ${valorTotal.toStringAsFixed(2).replaceAll(".", ",")}";
    }else{
      title = "${_userInvestimento.data[InfoContato.NAME]} - R\$ ${_investimento.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}";
    }
    return title;
  }

  Widget _totalResgatado(){
    if(_investimento.data["tipoAporte"] == "Renda Fixa"){
      return Text("Total resgatado: R\$ ${(Util.calculoRendaFixaFinal(_investimento.data["valorInvestido"], tempoInvestimento) - _investimento.data["valorInvestido"]).toStringAsFixed(2).replaceAll(".", ",")}");
    }else{
      return Container();
    }
  }

  int tempoAporte(){
    var dataInicio;
    var dataRetirada;
    int mesesInvestimento;
    switch(_investimento.data["situacao"]){
      case InfoContato.SITUACAO_APROVADO:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.now();
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      case InfoContato.RETIRADA_APROVADA:
      case InfoContato.RETIRADA_PENDENTE:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_RETIRADA_SOLICITADA].millisecondsSinceEpoch);
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      default:
        mesesInvestimento =0;
        break;
    }
    return mesesInvestimento;

  }

}
