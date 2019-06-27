import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:intl/intl.dart';

abstract class Util {
  static double calculoRendaFixa(double valor,Timestamp dataInicial){
  var valordata = dataInicial.millisecondsSinceEpoch;
  var data = DateTime.fromMillisecondsSinceEpoch(valordata);
  var diff = data.difference(DateTime.now());
  int meses = (diff.inDays/30).floor()*-1;
  return (valor*0.025*meses)+valor;
  }

  static double calculoAcumulado(double valor,Timestamp dataInicial){
    var valordata = dataInicial.millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    var diff = data.difference(DateTime.now());
    int meses = (diff.inDays/30).floor()*-1;
    return valor* (pow((1+0.025),meses));
  }

  static double calculoRendaFixaFinal(double valor,int meses){
    return (valor*0.025*meses)+valor;
  }

  static double calculoAcumuladoFinal(double valor,int meses){
    return valor * (pow((1+0.025),meses));
  }

  static String dataFormmat(Timestamp date){
    var valordata = date.millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    return DateFormat('dd/MM/yyyy').format(data);
  }

  static int tempoAporteMeses(Timestamp date){
    var valordata = date.millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    return (DateTime.now().difference(data).inDays/InfoContato.QTD_DIAS_MES).floor();
  }
  static int tempoAporteDias(Timestamp date){
    var valordata = date.millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    return DateTime.now().difference(data).inDays;
  }

  static List<DropdownMenuItem<String>> loadEstados(){
    List<DropdownMenuItem<String>> listEstado = [];
    listEstado.add(new DropdownMenuItem(
      child: Text("Acre"),
      value: "Acre",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Alagoas"),
      value: "Alagoas",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Amapá"),
      value: "Amapá",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Amazonas"),
      value: "Amazonas",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Bahia"),
      value: "Bahia",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Ceará"),
      value: "Ceará",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Distrito Federal"),
      value: "Distrito Federal",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Espírito Santo"),
      value: "Espírito Santo",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Goiás"),
      value: "Goiás",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Maranhão"),
      value: "Maranhão",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Mato Grosso"),
      value: "Mato Grosso",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Mato Grosso do Sul"),
      value: "Mato Grosso do Sul",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Minas Gerais"),
      value: "Minas Gerais",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Pará"),
      value: "Pará",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Paraíba"),
      value: "Paraíba",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Paraná"),
      value: "Paraná",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Pernambuco"),
      value: "Pernambuco",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Piauí"),
      value: "Piauí",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Rio de Janeiro"),
      value: "Rio de Janeiro",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Rio Grande do Norte"),
      value: "Rio Grande do Norte",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Rio Grande do Sul"),
      value: "Rio Grande do Sul",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Rondônia"),
      value: "Rondônia",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Roraima"),
      value: "Roraima",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Santa Catarina"),
      value: "Santa Catarina",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("São Paulo"),
      value: "São Paulo",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Sergipe"),
      value: "Sergipe",
    ));
    listEstado.add(new DropdownMenuItem(
      child: Text("Tocantins"),
      value: "Tocantins",
    ));
    return listEstado;
  }

  static int calcularMesesAporte(Timestamp date){
    var valordata = date.millisecondsSinceEpoch;
    var data = DateTime.fromMillisecondsSinceEpoch(valordata);
    var dataAtual = DateTime.now();
    return (dataAtual.difference(data).inDays/InfoContato.QTD_DIAS_MES).floor();
  }

  static Future<String> getContrato(BuildContext context ){
    Future<String> contrato =  DefaultAssetBundle.of(context).loadString("contrato.txt");
    return contrato;
  }

  static String setContrato(String contrato,DocumentSnapshot user,String numeroContrato ){
    String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
    String contratoUser;
    contratoUser = contrato.replaceAll("#nome", user[InfoContato.NAME].toString())
    .replaceAll("#gerado", numeroContrato)
    .replaceAll("#cpf", user[InfoContato.CPF].toString())
    .replaceAll("#rg", user[InfoContato.RG].toString())
    .replaceAll("#endereco", user[InfoContato.ENDERECO].toString())
    .replaceAll("#numero", user[InfoContato.NUM].toString())
    .replaceAll("#bairro", user[InfoContato.BAIRRO].toString())
    .replaceAll("#cidade", user[InfoContato.CIDADE].toString())
    .replaceAll("#estado", user[InfoContato.ESTADO].toString())
    .replaceAll("#cep", user[InfoContato.CEP].toString())
    .replaceAll("#data", data);
    return contratoUser;
  }
}