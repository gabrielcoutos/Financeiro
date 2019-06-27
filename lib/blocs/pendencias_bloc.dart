
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:rxdart/rxdart.dart';

class PendenciasBloc extends BlocBase {

  final _pendenciaController = BehaviorSubject<List>();
  final _investimentosController = BehaviorSubject<List>();
  StreamSubscription<QuerySnapshot> usuarioListener;
  StreamSubscription<QuerySnapshot> investimentoListener;

  Stream<List> get outPendencias => _pendenciaController.stream;
  int get outTotalPendencias => _pendenciaController.stream.value.length;

  Stream<List> get outInvestimentos => _investimentosController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _usuarios = [];
  List<DocumentSnapshot> todosUsuarios = [];
  List<DocumentSnapshot> _investimentos=[];
  List<DocumentSnapshot> _todosInvestimentos=[];
  List<DocumentSnapshot> _pendencias= [];
  
  PendenciasBloc(){
    _addListenerUsuarioPendente();
    _addListenerInvestimentoPendente();
  }
  
  void _addListenerUsuarioPendente(){
    usuarioListener =_firestore.collection("usuarios").snapshots().listen((snapshot){
      _pendencias =[];
      snapshot.documentChanges.forEach((change){
        String id = change.document.documentID;
        if(change.document.data[InfoContato.APROVADO] == InfoContato.SITUACAO_PENDENTE) {
          switch (change.type) {
            case DocumentChangeType.added:
              _usuarios.add(change.document);
              break;
            case DocumentChangeType.modified:
              _usuarios.removeWhere((usuario) => usuario.documentID == id);
              _usuarios.add(change.document);
              break;
            case DocumentChangeType.removed:
              _usuarios.removeWhere((usuario) => usuario.documentID == id);
              break;
          }
        }else{
          // add em uma lista que guarda todos os usuários para comparar de quem é o investimento.
          _usuarios.removeWhere((usuario) => usuario.documentID == id);
          switch (change.type) {
            case DocumentChangeType.added:
              todosUsuarios.add(change.document);
              break;
            case DocumentChangeType.modified:
              todosUsuarios.removeWhere((usuario) => usuario.documentID == id);
              todosUsuarios.add(change.document);
              break;
            case DocumentChangeType.removed:
              todosUsuarios.removeWhere((usuario) => usuario.documentID == id);
              break;
          }
        }
      });
      _pendencias.addAll(_usuarios);
      _pendencias.addAll(_investimentos);
      _pendenciaController.add(_pendencias);
    });
    
  }
  
  void _addListenerInvestimentoPendente(){
    investimentoListener =_firestore.collection("investimentos").snapshots().listen((snapshot){
      _pendencias =[];
      snapshot.documentChanges.forEach((change){
        String id = change.document.documentID;
        if(change.document.data[InfoContato.APROVADO]==InfoContato.SITUACAO_PENDENTE || change.document.data[InfoContato.APROVADO] == InfoContato.RETIRADA_PENDENTE){
          switch (change.type) {
            case DocumentChangeType.added:
              _investimentos.add(change.document);
              break;
            case DocumentChangeType.modified:
              _investimentos.removeWhere((usuario) => usuario.documentID == id);
              _investimentos.add(change.document);
              break;
            case DocumentChangeType.removed:
              _investimentos.removeWhere((usuario) => usuario.documentID == id);
              break;
          }
        }else if(change.document.data[InfoContato.APROVADO]==InfoContato.SITUACAO_APROVADO){
          _investimentos.removeWhere((usuario) => usuario.documentID == id);
          if(change.document.data["tipoAporte"]== "Renda Fixa"){
            var datatime = change.document.data[InfoContato.RESGATE_MENSAL].millisecondsSinceEpoch;
            var data = DateTime.fromMillisecondsSinceEpoch(datatime);
            Duration days = DateTime.now().difference(data);
            if(days.inDays>= InfoContato.QTD_DIAS_MES ){
              _investimentos.add(change.document);
            }
          }
          switch (change.type) {
            case DocumentChangeType.added:
              _todosInvestimentos.add(change.document);
              break;
            case DocumentChangeType.modified:
              _todosInvestimentos.removeWhere((usuario) => usuario.documentID == id);
              _todosInvestimentos.add(change.document);
              break;
            case DocumentChangeType.removed:
              _todosInvestimentos.removeWhere((usuario) => usuario.documentID == id);
              break;
          }

        }else{
          _investimentos.removeWhere((usuario) => usuario.documentID == id);
          _todosInvestimentos.removeWhere((usuario) => usuario.documentID == id);
        }
      });
      _pendencias.addAll(_usuarios);
      _pendencias.addAll(_investimentos);
      _pendenciaController.add(_pendencias);
      _investimentosController.add(_todosInvestimentos);
    });
  }
  

  @override
  void dispose() {
    usuarioListener.cancel();
    _investimentosController.close();
    _pendenciaController.close();
    investimentoListener.cancel();
    // TODO: implement dispose
  }

}
