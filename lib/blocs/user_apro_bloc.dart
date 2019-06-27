import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/util/util.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase{

  final _aporteController = BehaviorSubject<List>();
  final _retiradaController = BehaviorSubject<List>();
  final _nameController = BehaviorSubject<String>();
  final _userController = BehaviorSubject<DocumentSnapshot>();
  DocumentSnapshot dadosUsuarioLogado;

  Stream<List> get outAportes  =>_aporteController.stream;
  Stream<List> get outRetiradas => _retiradaController.stream;
  Stream<String> get outNameUser => _nameController.stream;
  Stream<DocumentSnapshot> get outUser => _userController.stream;

  int get outRetiradasLenght => _retiradaController.value.length;
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _userLogado;
  StreamSubscription<QuerySnapshot> listenerUser;

  List<DocumentSnapshot> _investimentos = [];
  List<DocumentSnapshot> _retiradas =[];

  UserBloc(this._userLogado){
    listenerUser = _firestore.collection("investimentos").where("userId",isEqualTo: _userLogado.uid).snapshots().listen((snapshots){
      snapshots.documentChanges.forEach((change){
        bool pendencia = false;
        String id = change.document.documentID;
        if(change.document.data[InfoContato.APROVADO] == InfoContato.SITUACAO_APROVADO){
          var data = DateTime.fromMillisecondsSinceEpoch(change.document.data[InfoContato.DATA_APROVACAO].millisecondsSinceEpoch);
          var dataNow = DateTime.now();
          var diff = dataNow.difference(data);
          if((diff.inDays >= (InfoContato.MESES_CARENCIA*InfoContato.QTD_DIAS_MES) && change.document.data[InfoContato.NOVO_APORTE])){
            pendencia = true;
          }else if(change.document.data[InfoContato.RESGATE_MENSAL_APROVADO]){
            pendencia= true;
          }
        }
        switch(change.type){
          case DocumentChangeType.added:
            _investimentos.add(change.document);
              if(pendencia){
                _retiradas.add(change.document);
              }
            break;
          case DocumentChangeType.modified:
            _investimentos.removeWhere((document) => document.documentID == id);
            _retiradas.removeWhere((document) => document.documentID == id);
            _investimentos.add(change.document);
            if(pendencia){
              _retiradas.add(change.document);
            }
            break;
          case DocumentChangeType.removed:
            _investimentos.removeWhere((document) => document.documentID == id);
            _retiradas.removeWhere((document) => document.documentID == id);
            break;
        }
      });
      _sortByDate();
      _retiradaController.add(_retiradas);
    });
  }

  void _sortByDate(){
    _investimentos.sort((a,b)=> DateTime.fromMillisecondsSinceEpoch(b.data["dataInicio"].millisecondsSinceEpoch).compareTo(DateTime.fromMillisecondsSinceEpoch(a.data["dataInicio"].millisecondsSinceEpoch)));
    _aporteController.add(_investimentos);
  }

  void logoutUser(){
    _auth.signOut();
  }

  Future submitRetirada(DocumentSnapshot snapshot) async {
    double valorRetirada;
    bool usarDadosBancariosDoSistema = true;
    if(snapshot.data["tipoAporte"]=="Acumualado"){
      valorRetirada = Util.calculoAcumuladoFinal(snapshot.data["valorInvestido"], InfoContato.MESES_CARENCIA);
    }else{
      valorRetirada = snapshot.data["valorInvestido"];
    }
   await _firestore.collection("retiradas").document().setData(
      {
        InfoContato.APROVADO:InfoContato.SITUACAO_PENDENTE,
        "dataSolicitacao":DateTime.now(),
        "valorRetirado":valorRetirada,
        "dadosSistema":usarDadosBancariosDoSistema,
        "investimendoUid":snapshot.documentID,
        "usuarioUid":_userLogado.uid
      }
    );
  }
  
  void getUserName(){
    _firestore.collection("usuarios").document(_userLogado.uid).get().then((snapshot){
      _nameController.add(snapshot[InfoContato.NAME]);
      _userController.add(snapshot);
      dadosUsuarioLogado = snapshot;
    });
  }

  @override
  void dispose() {
    _aporteController.close();
    _retiradaController.close();
    listenerUser.cancel();
    _nameController.close();
    _userController.close();
    // TODO: implement dispose
  }

}
