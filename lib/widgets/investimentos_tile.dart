import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:intl/intl.dart';

import 'ShowContrato.dart';
class InvestimentosTile extends StatelessWidget {
  final DocumentSnapshot _investimento;
  int mesesInvestidos;
  InvestimentosTile(this._investimento){
    mesesInvestidos = _mesesInvestidos();
  }
  @override
  Widget build(BuildContext context) {
    var data = DateTime.fromMillisecondsSinceEpoch(_investimento.data["dataInicio"].millisecondsSinceEpoch);
    var dataFormmat = DateFormat('dd/MM/yyyy').format(data);
    var dataFormmatPendencia;
    var dataFormmatRetiradaSolicitada;
    String situacao;
    TextStyle styleTitle;
    if(_investimento.data["situacao"] == InfoContato.SITUACAO_PENDENTE){
      situacao = "Em análise";
      styleTitle = TextStyle(color: Colors.indigo[900]);
    }else if(_investimento.data["situacao"] == InfoContato.SITUACAO_APROVADO){
      situacao="Aprovado";
      dataFormmatPendencia = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch));
      styleTitle = TextStyle(color: Colors.green[900]);
    }else if(_investimento.data["situacao"] ==InfoContato.SITUACAO_REPROVADO){
      situacao = "Reprovado";
      dataFormmatPendencia = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch));
      styleTitle = TextStyle(color: Colors.red[900]);
    }else if(_investimento.data["situacao"] ==InfoContato.RETIRADA_APROVADA){
      situacao = "Resgatado";
      dataFormmatPendencia = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch));
      styleTitle = TextStyle(color: Colors.amber);
    }else{
      styleTitle = TextStyle(color: Colors.black);
      dataFormmatPendencia = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch));
      situacao="Resgate em análise";
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 16 ),
      child: Card(
        child: ExpansionTile(
          title: Text("$dataFormmat - $situacao",style: styleTitle,),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25.0,child: Text("Informações do investimento",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                  Text("Valor do aporte: R\$ ${_investimento.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}"),
                  Text("Aprovação: ${dataFormmatPendencia!=null ? dataFormmatPendencia: "-"}"),
                  Text("Carência: ${_dataRetirada()}"),
                  Text("Modalidade: ${_investimento.data["tipoAporte"]}"),
                  Text("Permanência: $mesesInvestidos  meses"),
                  textRendimento(),
                  Text("Rendimento total atual: R\$ ${_montanteAtual().toStringAsFixed(2).replaceAll(".", ",")}"),
                 _showSaldo(),
                  FlatButton(
                    child: Text("Ver contrato",
                    style: TextStyle(color: Colors.green[900]),),
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowContrato(uid: _investimento.documentID,))),
                  ),
                  actionsInvestimentos(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dataRetirada(){
    var data = DateTime.fromMillisecondsSinceEpoch(_investimento.data["dataInicio"].millisecondsSinceEpoch);
    var dataRetirada = data.add(Duration(days: 180));
    if(_investimento.data["situacao"] == InfoContato.SITUACAO_APROVADO){
      data = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
      dataRetirada = data.add(Duration(days: 180));
    }else if(_investimento.data["situacao"] == InfoContato.SITUACAO_REPROVADO){
      return "Investimento recusado";
    }else if(_investimento.data["situacao"] == InfoContato.RETIRADA_PENDENTE){
      data = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
      dataRetirada = data.add(Duration(days: 180));
    }else if(_investimento.data["situacao"] == InfoContato.RETIRADA_APROVADA){
      data = DateTime.fromMillisecondsSinceEpoch(_investimento.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
      dataRetirada = data.add(Duration(days: 180));
    }
    return DateFormat('dd/MM/yyyy').format(dataRetirada);
  }

  double _montanteAtual(){
    double valor;
    switch(_investimento.data["situacao"]){
      case InfoContato.SITUACAO_APROVADO:
        if(_investimento.data["tipoAporte"]=="Acumulado"){ // tipo de aporte
            valor= Util.calculoAcumuladoFinal(_investimento.data["valorInvestido"],mesesInvestidos ) - _investimento.data["valorInvestido"];
        }else{
            valor= Util.calculoRendaFixaFinal(_investimento.data["valorInvestido"], mesesInvestidos) - _investimento.data["valorInvestido"];
        }
        break;
      case InfoContato.RETIRADA_APROVADA:
      case InfoContato.RETIRADA_PENDENTE:
        if(_investimento.data["tipoAporte"]=="Acumulado"){
          valor= Util.calculoAcumuladoFinal(_investimento.data["valorInvestido"],mesesInvestidos) - _investimento.data["valorInvestido"];
        }else{
          valor= Util.calculoRendaFixaFinal(_investimento.data["valorInvestido"], mesesInvestidos) - _investimento.data["valorInvestido"];
        }
        break;
      default:
        valor = 0.00;
        break;
    }

    return valor;
  }

  Widget textRendimento(){
    if(_investimento.data["tipoAporte"] == "Renda Fixa")
      {
        double valor = Util.calculoRendaFixaFinal(_investimento["valorInvestido"],1) - _investimento["valorInvestido"];
        return Text(
            "Rendimento ao mês: R\$${valor.toStringAsFixed(2).replaceAll(".", ",")}");
      }else{
      return Container();
    }

  }

  int _mesesInvestidos(){
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

  Widget actionsInvestimentos(BuildContext context){
    Widget btn;
    if(!_investimento[InfoContato.NOVO_APORTE] && (_investimento[InfoContato.APROVADO] == InfoContato.SITUACAO_APROVADO)){
      btn = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(),
          FlatButton(
            child: Text("Trocar modalidade",style: TextStyle(color: Colors.white),),
            color: Colors.indigo[900],
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    String changeAporte;
                    double newInvestimento;
                    if(_investimento.data["tipoAporte"] == "Acumulado"){
                      changeAporte = "Renda Fixa";
                      newInvestimento = Util.calculoAcumulado(_investimento.data["valorInvestido"], _investimento.data[InfoContato.DATA_APROVACAO]);
                    }else{
                      changeAporte="Acumulado";
                      newInvestimento = _investimento.data["valorInvestido"];
                    }
                    return AlertDialog(
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      title: Text("Alterar tipo Aporte",textAlign: TextAlign.center,),
                      content: Text("Tem certeza que deseja alterar seu aporte de\n${_investimento.data["tipoAporte"].toString().toUpperCase()} para ${changeAporte.toUpperCase()} ?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: (){
                            _investimento.reference.updateData({InfoContato.APROVADO:InfoContato.SITUACAO_PENDENTE,"valorInvestido":newInvestimento,"tipoAporte":changeAporte,"dataInicio": DateTime.now()}).whenComplete((){
                              Navigator.pop(context);
                            });

                          },
                          child: Text("Sim",style: TextStyle(color: Colors.green[900]),),
                        ),
                        FlatButton(
                          onPressed: ()=> Navigator.pop(context),
                          child: Text("Não",style: TextStyle(color: Colors.red[900]),),
                        )
                      ],
                    );
                  }
              );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
          FlatButton(
            child: Text("Retirar",style: TextStyle(color: Colors.white),),
            color: Colors.indigo[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      title: Text("Retirar aporte",textAlign: TextAlign.center,),
                      content: Text("Tem certeza que deseja RETIRAR aporte ?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: (){
                            _investimento.reference.updateData({InfoContato.APROVADO:InfoContato.RETIRADA_PENDENTE,InfoContato.DATA_RETIRADA_SOLICITADA:DateTime.now()}).whenComplete((){
                              Navigator.pop(context);
                            });

                          },
                          child: Text("Sim",style: TextStyle(color: Colors.green[900]),),
                        ),
                        FlatButton(
                          onPressed: ()=> Navigator.pop(context),
                          child: Text("Não",style: TextStyle(color: Colors.red[900]),),
                        )
                      ],
                    );
                  }
              );
            },
          ),
        ],
      );
    }else{
      btn = Container();
    }
    return btn;
  }

  Widget _showSaldo(){
    if(_investimento.data["tipoAporte"] == "Acumulado")
    {
      return Text("Saldo: R\$ ${(_montanteAtual()+_investimento.data["valorInvestido"]).toStringAsFixed(2).replaceAll(".", ",")}");
    }else{
      return Container();
    }
  }


}
