import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:rxdart/rxdart.dart';

class Usuario extends BlocBase{

  final _usuarioController = BehaviorSubject<List>();

  Stream<List> get outUsuario => _usuarioController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _usuarios = [];
  
  Usuario(){
    _addUsersListener();
  }
  
  void _addUsersListener(){
    _firestore.collection("usuarios").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change){
        String id = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _usuarios.add(change.document);
            break;
          case DocumentChangeType.modified:
           _usuarios.removeWhere((usuario) => usuario.documentID==id);
           _usuarios.add(change.document);
            break;
          case DocumentChangeType.removed:
            _usuarios.removeWhere((usuario) => usuario.documentID==id);
            break;
        }
      });
      _sortByName();
    });
  }

  void _sortByName(){
    _usuarios.sort((a,b)=> a.data[InfoContato.NAME].toString().compareTo(b.data[InfoContato.NAME].toString()));
    _usuarioController.add(_usuarios);
  }


  Future updateUsuarioAprovado(String id, bool aprovado) async {
    Map<String,dynamic> data = {
      InfoContato.APROVADO: aprovado
    };
    await Firestore.instance.collection("usuarios").document(id).setData(data);
  }

  void logout(){
    FirebaseAuth.instance.signOut();
  }
  

  @override
  void dispose() {
    _usuarioController.close();
    // TODO: implement dispose
  }

}