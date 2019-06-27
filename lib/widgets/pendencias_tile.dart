import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:intl/intl.dart';

class PendenciasTile extends StatelessWidget {

  final DocumentSnapshot pendencia;
  final DocumentSnapshot usuario;
  bool isInvestimento;
  int meses;


  PendenciasTile(this.pendencia,this.usuario){
    if(pendencia.data[InfoContato.APROVADO] == InfoContato.RETIRADA_PENDENTE){
      isInvestimento = false;
    }else{
      isInvestimento= true;
    }
    meses = _tempoAporte();
  }

  @override
  Widget build(BuildContext context) {
    var valordata = pendencia.data["dataInicio"].millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    var dataFormmat = DateFormat('dd/MM/yyyy').format(data);
    if(isInvestimento){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 16 ),
        child: Card(
          child: ExpansionTile(
            title: Text("Aporte - R\$ ${pendencia.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}"),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 25.0,child: Text("Informações do investimento",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                    Text("Modalidade: ${pendencia.data["tipoAporte"]}"),
                    Text("Aporte: $dataFormmat"),
                    Text("Tipo: ${pendencia.data["tipoTransferencia"]}"),
                    Container(
                      margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                      child: Text("Informações do investidor",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                    ),
                    Text("${usuario.data[InfoContato.NAME]}"),
                    Text("${usuario.data[InfoContato.EMAIL]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("RG: ${usuario.data[InfoContato.RG]}"),
                        Text("CPF: ${usuario.data[InfoContato.CPF]}"),
                      ],
                    ),
                    Text("Celular: ${usuario.data[InfoContato.CELULAR]}"),
                    Container(
                      margin: EdgeInsets.only(top:10.0,bottom: 10.0),
                      child: Text("Informações bancárias",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    ),
                    Text("Banco: ${usuario.data[InfoContato.BANCO]}"),
                    Text("Agência: ${usuario.data[InfoContato.AGENCIA]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Conta: ${usuario.data[InfoContato.CONTA]}"),
                        Text("Digito: ${usuario.data[InfoContato.DIGITO]}"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Reprovar aporte",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja REPROVAR esse aporte?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          pendencia.reference.updateData({
                                            InfoContato.APROVADO:InfoContato.SITUACAO_REPROVADO,
                                            InfoContato.DATA_APROVACAO:DateTime.now(),
                                          }).whenComplete((){
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
                          textColor: Colors.red,
                          child: Text("Reprovar"),
                        ),
                        FlatButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Aprovar aporte",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja APROVAR esse aporte?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          pendencia.reference.updateData({InfoContato.APROVADO:InfoContato.SITUACAO_APROVADO,InfoContato.DATA_APROVACAO:DateTime.now(),InfoContato.RESGATE_MENSAL:DateTime.now(),InfoContato.RESGATE_MENSAL_APROVADO:false,}).whenComplete((){
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
                          textColor: Colors.green[900],
                          child: Text("Aprovar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      var dataAprovacaoAporte = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(pendencia.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch));
      var dataSolicitacaoRetirada = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(pendencia.data[InfoContato.DATA_RETIRADA_SOLICITADA].millisecondsSinceEpoch));

      return Container(
        margin: EdgeInsets.symmetric(vertical: 4 ,horizontal: 16 ),
        child: Card(
          child: ExpansionTile(
            title: Text("Resgate - R\$ ${pendencia.data["tipoAporte"] == "Acumulado" ? Util.calculoAcumuladoFinal(pendencia.data["valorInvestido"], meses).toStringAsFixed(2).replaceAll(".", ",") : pendencia.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",") } "),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 25.0,child: Text("Informações do resgate",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                    Text("Permanência: $meses meses"),
                    Text("Solicitação de resgate: $dataSolicitacaoRetirada"),
                    Container(
                      margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                      child: Text("Informações do investidor",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,) ,
                    ),
                    Text("${usuario.data[InfoContato.NAME]}"),
                    Text("${usuario.data[InfoContato.EMAIL]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("RG: ${usuario.data[InfoContato.RG]}"),
                        Text("CPF: ${usuario.data[InfoContato.CPF]}"),
                      ],
                    ),
                    Text("Celular: ${usuario.data[InfoContato.CELULAR]}"),
                    Container(
                      margin: EdgeInsets.only(top:10.0,bottom: 10.0),
                      child: Text("Informações bancárias",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    ),
                    Text("Banco: ${usuario.data[InfoContato.BANCO]}"),
                    Text("Agência: ${usuario.data[InfoContato.AGENCIA]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Conta: ${usuario.data[InfoContato.CONTA]}"),
                        Text("Dígito: ${usuario.data[InfoContato.DIGITO]}"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Confirmar resgate",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja confirmar esse resgate?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          pendencia.reference.updateData({InfoContato.APROVADO:InfoContato.RETIRADA_APROVADA,InfoContato.DATA_RETIRADA_CONFIRMADA:DateTime.now()}).whenComplete((){
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
                          textColor: Colors.green[900],
                          child: Text("Aprovar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  int _tempoAporte(){
    var dataInicio;
    var dataRetirada;
    int mesesInvestimento;
    switch(pendencia.data["situacao"]){
      case InfoContato.SITUACAO_APROVADO:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(pendencia.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.now();
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      case InfoContato.RETIRADA_APROVADA:
      case InfoContato.RETIRADA_PENDENTE:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(pendencia.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.fromMillisecondsSinceEpoch(pendencia.data[InfoContato.DATA_RETIRADA_SOLICITADA].millisecondsSinceEpoch);
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      default:
        mesesInvestimento =0;
        break;
    }
    return mesesInvestimento;
  }
}
