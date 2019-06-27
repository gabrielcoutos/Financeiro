import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/validators/signup_validators.dart';
import 'package:rxdart/rxdart.dart';


enum CadastroState{
  SUCCESS,
  FAIL,
  LOADING,
  IDLE,
}
class SignUpBloc extends BlocBase with SignUpValidators {
  final _nomeController = BehaviorSubject<String>();
  final _rgController = BehaviorSubject<String>();
  final _cpfController = BehaviorSubject<String>();
  final _orgEmissorController = BehaviorSubject<String>();
  final _dataNasciController = BehaviorSubject<String>();
  final _celularController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _senhaController = BehaviorSubject<String>();
  final _confirmarSenhaController = BehaviorSubject<String>();
  final _cepController = BehaviorSubject<String>();
  final _enderecoController = BehaviorSubject<String>();
  final _numeroController = BehaviorSubject<String>();
  final _bairroController = BehaviorSubject<String>();
  final _cidadeController = BehaviorSubject<String>();
  final _estadoController = BehaviorSubject<String>();
  final _bancoController = BehaviorSubject<String>();
  final _agenciaController = BehaviorSubject<String>();
  final _contaController = BehaviorSubject<String>();
  final _digitoController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<CadastroState>();

  Map<String,dynamic> _dadosUser = Map();

  String get estadoValue => _estadoController.value;
  String get bancoValue => _bancoController.value;

  // definição das saidas dos strems com a validação
  Stream<String> get outName => _nomeController.stream.transform(validateNome);
  Stream<String> get outRg => _rgController.stream.transform(validateRg);
  Stream<String> get outCpf => _cpfController.stream;
  Stream<String> get outOrgEmissor => _orgEmissorController.stream.transform(validateOrgEmissor);
  Stream<String> get outDataNascimento => _dataNasciController.stream.transform(validateDataNascimento);
  Stream<String> get outCelular => _celularController.stream.transform(validateCelular);
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outSenha => _senhaController.stream.transform(validateSenha);
  Stream<String> get outConfirmaSenha => _confirmarSenhaController.stream.transform(validateConfirmarSenha);
  Stream<String> get outCEP => _cepController.stream.transform(validateCEP);
  Stream<String> get outEndereco => _enderecoController.stream.transform(validateEndereco);
  Stream<String> get outNumero=> _numeroController.stream.transform(validateNumero);
  Stream<String> get outBairro=> _bairroController.stream.transform(validateBairro);
  Stream<String> get outCidade=> _cidadeController.stream.transform(validateCidade);
  Stream<String> get outEstado => _estadoController.stream.transform(validateEstado);
  Stream<String> get outBanco => _bancoController.stream;
  Stream<String> get outAgencia => _agenciaController.stream.transform(validateAgencia);
  Stream<String> get outConta => _contaController.stream.transform(validateConta);
  Stream<String> get outDigito => _digitoController.stream.transform(validateDigito);
  Stream<CadastroState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outEmail, outSenha, (a,b)=>true);



//Entrada dos dados no streamers ao mudar o estado dos inputs
  Function(String) get changedName => _nomeController.sink.add;
  Function(String) get changedRg => _rgController.sink.add;
  Function(String) get changedCpf => _cpfController.add;
  Function(String) get changedOrgEmissor => _orgEmissorController.sink.add;
  Function(String) get changedDataNasc => _dataNasciController.sink.add;
  Function(String) get changedCelular => _celularController.sink.add;
  Function(String) get changedEmail=> _emailController.sink.add;
  Function(String) get changedSenha=> _senhaController.sink.add;
  Function(String) get changedConfirmaSenha => _confirmarSenhaController.sink.add;
  Function(String) get changedCEP => _cepController.sink.add;
  Function(String) get changedEndereco => _enderecoController.sink.add;
  Function(String) get changedNumero => _numeroController.sink.add;
  Function(String) get changedBairro => _bairroController.sink.add;
  Function(String) get changedCidade => _cidadeController.sink.add;
  Function(String) get changedEstado => _estadoController.sink.add;
  Function(String) get changedBanco => _bancoController.sink.add;
  Function(String) get changedAgencia => _agenciaController.sink.add;
  Function(String) get changedConta => _contaController.sink.add;
  Function(String) get changedDigito => _digitoController.sink.add;

  SignUpBloc(){
    _stateController.add(CadastroState.IDLE);
  }

  void submitnewUser(){
    _stateController.add(CadastroState.LOADING);

    final email = _emailController.value;
    final senha = _senhaController.value;

    Map<String,dynamic> getData = {
      InfoContato.NAME:_nomeController.value,
      InfoContato.RG: _rgController.value,
      InfoContato.CPF:_cpfController.value,
      InfoContato.ORG_EMISSOR:_orgEmissorController.value,
      InfoContato.CELULAR:_celularController.value,
      InfoContato.EMAIL:_emailController.value,
      InfoContato.CEP:_cepController.value,
      InfoContato.ENDERECO:_enderecoController.value,
      InfoContato.NUM:_numeroController.value,
      InfoContato.BAIRRO:_bairroController.value,
      InfoContato.CIDADE:_cidadeController.value,
      InfoContato.ESTADO:_estadoController.value,
      InfoContato.BANCO:_bancoController.value,
      InfoContato.AGENCIA:_agenciaController.value,
      InfoContato.CONTA:_contaController.value,
      InfoContato.DIGITO:_digitoController.value,
      InfoContato.APROVADO: InfoContato.SITUACAO_PENDENTE,
      InfoContato.DATA_NASC:_dataNasciController.value,
    };

    _dadosUser = getData;

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha).then((user) async {

      if(user != null){

        await _submitDataNewUser(user);

        _stateController.add(CadastroState.SUCCESS);
      }else{
        _stateController.add(CadastroState.FAIL);

      }
    })
    .catchError((e){
      _stateController.add(CadastroState.FAIL);

    });
  }

  Future<Null> _submitDataNewUser(FirebaseUser user) async{
    await Firestore.instance.collection("usuarios").document(user.uid).setData(this._dadosUser);
    FirebaseAuth.instance.signOut();
  }


  @override
  void dispose() {
   _nomeController.close();
   _rgController.close();
   _cpfController.close();
   _orgEmissorController.close();
   _dataNasciController.close();
   _celularController.close();
   _emailController.close();
   _senhaController.close();
   _confirmarSenhaController.close();
   _cepController.close();
   _enderecoController.close();
   _numeroController.close();
   _bairroController.close();
   _cidadeController.close();
   _estadoController.close();
   _bancoController.close();
   _agenciaController.close();
   _contaController.close();
   _digitoController.close();
   _stateController.close();
  }
}
