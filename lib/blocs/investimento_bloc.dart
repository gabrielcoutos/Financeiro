import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/model/MyStorage.dart';
import 'package:fundo_fe/validators/investimento_validators.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum stateInvestir{
  IDLE,
  SUCCESS,
  LOADING,
  FAIL
}
class InvestimentoBLoc extends BlocBase with InvestimentoValidator{

  final _valorInvestido = BehaviorSubject<double>();
  final _transferencia = BehaviorSubject<String>();
  final _acumulado = BehaviorSubject<bool>();
  final _rendaFixa = BehaviorSubject<bool>();
  final _aporteString = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<stateInvestir>();
  String dataNow;
  var date;


  InvestimentoBLoc(){
    _acumulado.sink.add(false);
    _rendaFixa.sink.add(false);
    date = DateTime.now();
    dataNow = DateFormat('dd/MM/yyyy').format(date);
  }

  Stream<double> get outValorInvestido => _valorInvestido.stream.transform(validateValorInvestido);
  Stream<bool> get outAcumulado => _acumulado.stream.transform(validateAcumulado);
  Stream<bool> get outRendaFixa => _rendaFixa.stream.transform(validateRendaFixa);
  Stream<stateInvestir> get outState => _stateController.stream;
  Stream<String> get outAporte => _aporteString.stream;
  Stream<String> get outTransferencia => _transferencia.stream;
  Stream<bool> get outSubmit => Observable.combineLatest3(outValorInvestido,outAcumulado, outRendaFixa , (a,b, c ){
    if( (a> 4999.9) && (b || c )){
      return true;
    }
  });


  String get outTransferenciaValue => _transferencia.stream.value;

  void changeValorInvestido(double valor){
    _valorInvestido.sink.add(valor);
  }

  void changeAcumulad(bool valor){
    if(_rendaFixa.value && valor){
      _rendaFixa.sink.add(false);
    }
    _acumulado.sink.add(valor);
    outAporteEscolido();
  }
  void changeRenda(bool valor){
    if(_acumulado.value && valor){
      _acumulado.sink.add(false);
    }
    _rendaFixa.sink.add(valor);
    outAporteEscolido();
  }

  Function(String) get changedTransferencia => _transferencia.sink.add;

  void submitInvestimento (String contrato,String num) async {
    _stateController.add(stateInvestir.LOADING);
    MyStorage myStorage = MyStorage();
    File writeContrato = await myStorage.writeContrato(contrato);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user !=null) {
      Map<String, dynamic> dataInvestimenro = {
        "valorInvestido": _valorInvestido.stream.value,
        "tipoAporte": _aporteString.stream.value,
        "tipoTransferencia": _transferencia.stream.value,
        "dataInicio": date,
        "situacao": 0,
        "userId": user.uid,
        InfoContato.NOVO_APORTE: true,
      };
      await Firestore.instance.collection("investimentos").add(dataInvestimenro)
      .then((valor) async{
        print(writeContrato);
        final StorageReference reference = FirebaseStorage.instance.ref().child(valor.documentID+'.txt');
        await reference.putFile(writeContrato).onComplete.then((value) async{
          _stateController.add(stateInvestir.SUCCESS);
          _rendaFixa.add(false);
          _acumulado.add(false);
        });
      }).catchError((e){
        _stateController.add(stateInvestir.FAIL);
      });
    }else{
      _stateController.add(stateInvestir.FAIL);
    }
  }

  void outAporteEscolido() {
    if(_acumulado.value){
     _aporteString.sink.add("Acumulado");
    }else if(_rendaFixa.value){
      _aporteString.sink.add( "Renda Fixa");
    }else{
      _aporteString.sink.add("Não selecionado");
    }
  }
  @override
  void dispose() {
    _stateController.close();
    _valorInvestido.close();
    _acumulado.close();
    _rendaFixa.close();
    _aporteString.close();
    _transferencia.close();
    // TODO: implement dispose
  }

}