import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fundo_fe/validators/signup_validators.dart';
import 'package:rxdart/rxdart.dart';

class EditarUsuarioBloc extends BlocBase with SignUpValidators{


  final _enderecoController = BehaviorSubject<String>();
  final _bairroController = BehaviorSubject<String>();
  final _celularController = BehaviorSubject<String>();
  final _cidadeController = BehaviorSubject<String>();
  final _estadoController = BehaviorSubject<String>();
  final _numeroController = BehaviorSubject<String>();
  final _cepController = BehaviorSubject<String>();
  final _bancoController = BehaviorSubject<String>();
  final _agenciaController = BehaviorSubject<String>();
  final _contaController = BehaviorSubject<String>();
  final _digitoController = BehaviorSubject<String>();

  Stream<String> get outEndereco => _enderecoController.stream.transform(validateEndereco);
  Stream<String> get outBairro => _bairroController.stream.transform(validateBairro);
  Stream<String> get outCelular => _celularController.stream.transform(validateCelular);
  Stream<String> get outCidade => _cidadeController.stream.transform(validateCidade);
  Stream<String> get outEstado => _estadoController.stream;
  Stream<String> get outNumero => _numeroController.stream.transform(validateNumero);
  Stream<String> get outCEP => _cepController.stream.transform(validateCEP);
  Stream<String> get outBanco => _bancoController.stream;
  Stream<String> get outAgencia => _agenciaController.stream.transform(validateAgencia);
  Stream<String> get outConta => _contaController.stream.transform(validateConta);
  Stream<String> get outDigito => _digitoController.stream.transform(validateDigito);


  void setEndereco(String string)=> _enderecoController.add(string);


  Function(String) get changedCelular => _celularController.sink.add;
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


  @override
  void dispose() {
    _bairroController.close();
    _enderecoController.close();
    _celularController.close();
    _cidadeController.close();
    _estadoController.close();
    _numeroController.close();
    _cepController.close();
    _bancoController.close();
    _agenciaController.close();
    _contaController.close();
    _digitoController.close();

    // TODO: implement dispose
  }

}