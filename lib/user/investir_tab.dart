
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fundo_fe/blocs/investimento_bloc.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:fundo_fe/widgets/alert_dialog.dart';
import 'package:intl/intl.dart';

class Investir extends StatefulWidget {

  final DocumentSnapshot usuario;

  Investir( {this.usuario});

  @override
  _InvestirState createState() => _InvestirState();
}

class _InvestirState extends State<Investir> {
  final _valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$ ');
  List _payments =["TED","Transferência"];
  List<DropdownMenuItem<String>> _dropDownMenuItens;
  final _investirBLoc = InvestimentoBLoc();
  DocumentSnapshot user;
  bool aceitarTermos = false;

  @override
  void initState() {
    user = widget.usuario;
    print(user);
    print(widget.usuario);
    _dropDownMenuItens = getOptionsPayment();
    _investirBLoc.outState.listen((state){
      switch(state){
        case stateInvestir.SUCCESS:
          showDialog(
              context: context,
              builder: (BuildContext context){
                return MyAlertDialog(
                  icone:  Icon(
                    Icons.check_circle,
                    size: 80.0,
                    color: Colors.green[900],
                  ),
                  corBotao: Colors.green[900],
                  textoBotao: "Certo",
                  textoCentral: "Investimento registrado!\nAcompanhe o status na aba Histórico.",
                  onTap: ()=>Navigator.pop(context),
                );
              }
          );
          break;
        case stateInvestir.LOADING:
          break;
        case stateInvestir.IDLE:
          break;
        case stateInvestir.FAIL:
        showDialog(
            context: context,
            builder: (BuildContext context){
              return  MyAlertDialog(
                icone:  Icon(
                  Icons.error,
                  size: 80.0,
                  color: Colors.red[900],
                ),
                corBotao: Colors.red[900],
                textoBotao: "Certo",
                textoCentral: "Ops, algo deu errado...\nTente novamente!",
                onTap: ()=>Navigator.pop(context),
              );
            }
        );
        break;
      }

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    String dateNow = DateFormat('dd/MM/yyyy').format(date);
    return StreamBuilder<stateInvestir>(
      stream: _investirBLoc.outState,
      builder: (context, snapshotState) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: StreamBuilder<Object>(
            stream: _investirBLoc.outState,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(),
                      Text("Quantia a ser investida"),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2,color: Colors.white),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            )
                        ),
                        child: StreamBuilder<double>(
                          stream: _investirBLoc.outValorInvestido,
                          builder: (context, snapshot) {
                            return TextField(
                              controller: _valorController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[900])),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)),
                                errorText: snapshot.hasError ? snapshot.error : null,
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25.0),
                              keyboardType: TextInputType.number,
                              onChanged: (text){
                                _investirBLoc.changeValorInvestido(_valorController.numberValue);
                              },

                            );
                          }
                        ),
                      ),
                     Container(
                       margin: EdgeInsets.only(top: 10.0),
                       child: Text("Informações para a transferência"),
                     ),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0)
                          )
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text("Opções de pagamento:"),
                              StreamBuilder<String>(
                                stream: _investirBLoc.outTransferencia,
                                builder: (context, snapshot) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: Text("Opções de transferência"),
                                      style: TextStyle(fontSize: 15.0,color: Colors.black),
                                      value: _investirBLoc.outTransferenciaValue,
                                        items: _dropDownMenuItens,
                                        onChanged: _investirBLoc.changedTransferencia,

                                    ),
                                  );
                                }
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text("Banco do Brasil",),
                                    StreamBuilder<String>(
                                      stream: _investirBLoc.outTransferencia,
                                      builder: (context, snapshot) {
                                        return Text("Agência: 0983${snapshot.data == _payments[1] ? "-0":""}",);
                                      }
                                    ),
                                  ],
                                ),
                              ),
                              Container(margin: EdgeInsets.only(top: 5.0,bottom: 5.0),child: Text("CC: 31569",textAlign: TextAlign.center,)),
                              Container(margin: EdgeInsets.only(top: 5.0,bottom: 5.0),child: Text("CNPJ: 27.434.310/0001-70",textAlign: TextAlign.center,)),
                              Container(margin: EdgeInsets.only(top: 5.0),child: Text("FFE- Factoring Eireli",textAlign: TextAlign.center,)),
                            ],
                          ),

                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text("Modalidade do aporte: "),
                      ),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2,color: Colors.white),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                StreamBuilder<bool>(
                                  stream: _investirBLoc.outAcumulado,
                                  builder: (context, snapshot) {
                                    return Checkbox(
                                      value: snapshot.data == null ? false : snapshot.data,
                                      onChanged: (valor){
                                        _investirBLoc.changeAcumulad(valor);
                                      },
                                    );
                                  }
                                ),
                                Text("Acumulado"),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                StreamBuilder<bool>(
                                  stream: _investirBLoc.outRendaFixa,
                                  builder: (context, snapshot) {
                                    return Checkbox(
                                      value: snapshot.data == null ? false : snapshot.data,
                                      onChanged:(valor){
                                        _investirBLoc.changeRenda(valor);
                                      },
                                    );
                                  }
                                ),
                                Text("Renda Fixa"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(margin: EdgeInsets.only(top: 15.0),child: Text("Atenção",style: TextStyle(fontWeight: FontWeight.bold),),),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2,color: Colors.white),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)
                            )
                        ),
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Verifique as informações:"),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: StreamBuilder<double>(
                                stream: _investirBLoc.outValorInvestido,
                                builder: (context, snapshot) {
                                  return Text(
                                  "Valor: ${_valorController.text}"
                                  );
                                }
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                  "Data: $dateNow"
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: StreamBuilder<String>(
                                stream: _investirBLoc.outTransferencia,
                                builder: (context, snapshot) {
                                  return Text(
                                     "Opção: ${snapshot.hasData ? snapshot.data : "Não selecionado"}"
                                  );
                                }
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: StreamBuilder<String>(
                                stream: _investirBLoc.outAporte,
                                builder: (context, snapshot) {
                                  return Text(
                                      "Aporte: ${snapshot.data == null ? "Não selecionado" : snapshot.data}",
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            StreamBuilder<bool>(
                              stream: _investirBLoc.outSubmit,
                              builder: (context, snapshot) {
                                return RaisedButton(
                                  elevation: 5.0,
                                  color: Colors.indigo[900],
                                  child: snapshotState.data != stateInvestir.LOADING ?
                                  Text("Investir",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),):
                                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                  onPressed: snapshot.hasData ?_confirmarInvestimento : null,
                                  disabledColor: Colors.indigo[900].withAlpha(140),
                                );
                              }
                            ),
                            RaisedButton(
                              elevation: 5.0,
                              color: Colors.red[900],
                              child: Text("Cancelar",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                              onPressed: (){
                                _valorController.updateValue(0.00);
                                _investirBLoc.changeAcumulad(false);
                                _investirBLoc.changeRenda(false);
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
          ),
        );
      }
    );
  }

  List<DropdownMenuItem<String>> getOptionsPayment(){
    List<DropdownMenuItem<String>> itens = List();

    for(String pay in _payments){
      itens.add(DropdownMenuItem(child: Text(pay),value: pay,));
    }
    return itens;
  }

  void _confirmarInvestimento(){
    String contrato;
    String numeroContrato ;
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context,a1,a2,widget){
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                title: Text("Contrato aporte",textAlign: TextAlign.center,),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<String>(
                        future: Util.getContrato(context),
                        builder: (BuildContext context, AsyncSnapshot<String> text){
                          switch(text.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              return SingleChildScrollView(
                                child:  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),),
                              );
                              break;
                            case ConnectionState.done:
                              if(text.hasError){
                                return SingleChildScrollView(
                                  child: Text(text.error.toString(),style: TextStyle(fontSize: 12.0),textAlign: TextAlign.justify,),
                                );
                              }else {
                                numeroContrato = _generateNumeroContrato();
                                contrato = Util.setContrato(text.data, user,numeroContrato);
                                return Scrollbar(
                                  child: SingleChildScrollView(
                                    child: Text(contrato,
                                      style: TextStyle(fontSize: 12.0,),
                                      textAlign: TextAlign.justify,
                                      softWrap: true,),
                                  ),
                                );
                              }
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: contrato != null ?(){
                              _investirBLoc.submitInvestimento(contrato,numeroContrato);
                              Navigator.pop(context);
                            }: null,
                            child: Text("Aceitar",style: TextStyle(color: Colors.green[900]),),
                          ),
                          FlatButton(
                            onPressed: ()=> Navigator.pop(context),
                            child: Text("Recusar",style: TextStyle(color: Colors.red[900]),),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      pageBuilder: (context,animation1,animation2){}
    );
  }


  String _generateNumeroContrato(){
    DateTime dateTime = DateTime.now();
    String cpf = widget.usuario[InfoContato.CPF];
    String numero = cpf.substring(0,2);
    numero+= dateTime.year.toString();
    numero+= dateTime.month.toString();
    numero+= dateTime.day.toString();
    numero+= dateTime.hour.toString();
    numero+= dateTime.second.toString();
    numero+= dateTime.millisecond.toString();
    print(numero);
    return numero;
  }


  
}

