import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum LoginState{
  IDLE,
  LOADING,
  ADMIN,
  USER,
  USERNOTAPROVED,
  FAIL
}

class LoginBloc extends BlocBase with LoginValidators{
  final _emailController = BehaviorSubject<String>();
  final _senhaController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();
  final prefs = SharedPreferences.getInstance();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outSenha => _senhaController.stream.transform(validateSenha);
  Stream<LoginState> get outState => _stateController.stream;
  Stream<bool>  get outSubmitValid => Observable.combineLatest2(
     outEmail, outSenha, (a,b)=>true
  );

   DocumentSnapshot userDados;
   FirebaseUser userAuth;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeSenha => _senhaController.sink.add;

  StreamSubscription _streamSubs;

  LoginBloc(){
    _stateController.add(LoginState.LOADING);
    prefs.then((value) async {
      bool conectado =value.getBool("manterConectado")?? false;
      if(!conectado){
        FirebaseAuth.instance.signOut();
      }
    });
    _streamSubs = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      print(user);
      if(user != null){
        if(await verifyPrivileges(user)) {
          _stateController.add(LoginState.ADMIN);
        }else if(await verifyUserAproved(user)){
          _stateController.add(LoginState.USER);
          userAuth = user;
          //FirebaseAuth.instance.signOut();
        }else{
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.USERNOTAPROVED);
        }
      }else{
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void submit(){
    final email = _emailController.value;
    final senha = _senhaController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha)
    .catchError((e){
      print(e);
      _stateController.add(LoginState.FAIL);
    }).then((user){

    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async{
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){
      if(doc.data !=null){
        return true;
      }else{
        return false;
      }

    }).catchError((e){
      print(e);
      return false;
    });
  }

  Future<bool> verifyUserAproved(FirebaseUser user) async{
    return await Firestore.instance.collection("usuarios").document(user.uid).get().then((doc){
      if(doc.data !=null){
        if(doc.data[InfoContato.APROVADO] == InfoContato.SITUACAO_APROVADO){
          userDados = doc;
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _senhaController.close();
    _stateController.close();
    _streamSubs.cancel();
  }
}
