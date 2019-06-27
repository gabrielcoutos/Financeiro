import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundo_fe/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';
enum RecoverState{
  IDLE,
  SUCCESS,
  ERROR,
  ENVIANDO
}


class RecuperarSenhaBloc extends BlocBase with LoginValidators{
  final _emailController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<RecoverState>();


  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<RecoverState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;


  recoverPassword(){
    _stateController.add(RecoverState.ENVIANDO);
    String email = _emailController.value;
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      _stateController.add(RecoverState.SUCCESS);
    },onError: (erro){
      print(erro);
      _stateController.add(RecoverState.ERROR);
    }).catchError((e){
      print(e);
      _stateController.add(RecoverState.ERROR);
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _stateController.close();
    // TODO: implement dispose
  }

}