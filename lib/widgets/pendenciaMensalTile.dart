import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';

class PendenciaMensalTile extends StatelessWidget {
  final DocumentSnapshot pendencia;
  final DocumentSnapshot usuario;

  PendenciaMensalTile(this.pendencia,this.usuario);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
      child: Card(
        child: ExpansionTile(
          title: Text("Resgate mensal"),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25.0,child: Text("Informações do resgate mensal",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                  Text("Pagamento: ${Util.dataFormmat(pendencia[InfoContato.DATA_APROVACAO])}"),
                  Text("Valor: R\$${Util.calculoRendaFixaFinal(pendencia["valorInvestido"], 1).toStringAsFixed(2).replaceAll(".", ",")}"),
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
                  FlatButton(
                    child: Text("Confirmar resgate",style: TextStyle(color: Colors.white),),
                    color: Colors.green[900],
                    onPressed: (){
                      pendencia.reference.updateData({InfoContato.RESGATE_MENSAL:DateTime.now(),InfoContato.RESGATE_MENSAL_APROVADO:true,});
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
