
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:intl/intl.dart';

class Retiradas extends StatelessWidget {
  final DocumentSnapshot _retirada;
  int tempoAporte;
  Retiradas(this._retirada){
    tempoAporte = _tempoAporte();
  }
  @override
  Widget build(BuildContext context) {
    var valordata = _retirada.data["dataInicio"].millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    var dataFormmat = DateFormat('dd/MM/yyyy').format(data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 16.0),
      child: Card(
        child: ExpansionTile(
          title: Text("${_textTitle()}"),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25.0,child: Text("Informações do investimento",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                  Text("Modalidade: ${_retirada.data["tipoAporte"]}"),
                  Text("Data do aporte: $dataFormmat"),
                  Text("Permanência: $tempoAporte meses"),
                  Divider(),
                  Text("${_retirada.data["tipoAporte"]=="Acumulado" ? "Montante : R\$${Util.calculoAcumuladoFinal(_retirada.data["valorInvestido"],tempoAporte).toStringAsFixed(2).replaceAll(".", ",")}" : "Rendimentos: R\$ ${(Util.calculoRendaFixaFinal(_retirada.data["valorInvestido"],tempoAporte)-_retirada.data["valorInvestido"]).toStringAsFixed(2).replaceAll(".", ",")}"}"),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Manter aporte",style: TextStyle(color:Colors.white),),
                          color: Colors.indigo[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Manter aporte",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja manter esse aporte?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          _retirada.reference.updateData({"situacao":InfoContato.SITUACAO_APROVADO,InfoContato.NOVO_APORTE:false}).whenComplete((){
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
                            splashColor: Colors.black
                        ),
                        RaisedButton(
                          child: Text("Alterar tipo aporte",style: TextStyle(color: Colors.white),),
                          color: Colors.indigo[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  String changeAporte;
                                  double newInvestimento;
                                  if(_retirada.data["tipoAporte"] == "Acumulado"){
                                    changeAporte = "Renda Fixa";
                                    newInvestimento = Util.calculoAcumulado(_retirada.data["valorInvestido"], _retirada.data[InfoContato.DATA_APROVACAO]);
                                  }else{
                                    changeAporte="Acumulado";
                                    newInvestimento = _retirada.data["valorInvestido"];
                                  }
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Alterar tipo do Aporte",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja alterar seu aporte de\n${_retirada.data["tipoAporte"].toString().toUpperCase()} para ${changeAporte.toUpperCase()} ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          _retirada.reference.updateData({InfoContato.APROVADO:InfoContato.SITUACAO_PENDENTE,"valorInvestido":newInvestimento,"tipoAporte":changeAporte,"dataInicio": DateTime.now()}).whenComplete((){
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
                            splashColor: Colors.black
                        ),
                        RaisedButton(
                          child: Text("Resgatar valor",style: TextStyle(color:Colors.white),),
                          color: Colors.indigo[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          splashColor: Colors.black,
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    title: Text("Resgatar aporte",textAlign: TextAlign.center,),
                                    content: Text("Tem certeza que deseja RESGATAR aporte ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: (){
                                          _retirada.reference.updateData({InfoContato.APROVADO:InfoContato.RETIRADA_PENDENTE,InfoContato.DATA_RETIRADA_SOLICITADA:DateTime.now()}).whenComplete((){
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

  String _textTitle(){
    String title;
    if(_retirada.data["tipoAporte"] == "Renda Fixa"){
      title = "Resgate - R\$ ${_retirada.data["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}";
    }else{
      title = "Resgate - R\$ ${Util.calculoAcumuladoFinal(_retirada.data["valorInvestido"], tempoAporte).toStringAsFixed(2).replaceAll(".", ",")}";
    }

    return title;
  }

  int _tempoAporte(){
    var dataInicio;
    var dataRetirada;
    int mesesInvestimento;
    switch(_retirada.data["situacao"]){
      case InfoContato.SITUACAO_APROVADO:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(_retirada.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.now();
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      case InfoContato.RETIRADA_APROVADA:
      case InfoContato.RETIRADA_PENDENTE:
        dataInicio = DateTime.fromMillisecondsSinceEpoch(_retirada.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
        dataRetirada = DateTime.fromMillisecondsSinceEpoch(_retirada.data[InfoContato.DATA_RETIRADA_SOLICITADA].millisecondsSinceEpoch);
        mesesInvestimento = (dataRetirada.difference(dataInicio).inDays/InfoContato.QTD_DIAS_MES).floor();
        break;
      default:
        mesesInvestimento =0;
        break;
    }
    return mesesInvestimento;
  }

}
