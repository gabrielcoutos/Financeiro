import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';

class ResgateMensal extends StatelessWidget {

  final DocumentSnapshot _pagamento;

  ResgateMensal(this._pagamento);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
      child: Card(
        child: ExpansionTile(
          title: Text("Pagamento do resgate mensal"),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Aporte: R\$ ${_pagamento["valorInvestido"].toStringAsFixed(2).replaceAll(".", ",")}"),
                  Text("Rendimento: R\$ ${(Util.calculoAcumuladoFinal(_pagamento["valorInvestido"], 1)-_pagamento["valorInvestido"]).toStringAsFixed(2).replaceAll(".", ",")}"),
                  FlatButton(
                    child: Text("OK",style: TextStyle(color: Colors.green[900]),),
                    onPressed: (){
                      _pagamento.reference.updateData({InfoContato.RESGATE_MENSAL_APROVADO:false});
                    },
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
