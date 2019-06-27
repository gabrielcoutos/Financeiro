import 'dart:async';
class InvestimentoValidator{

  final validateValorInvestido = StreamTransformer<double,double>.fromHandlers(
      handleData: (valor,sink){
        if(valor<30000.00){
          sink.addError("Valor mínimo é R\$ 30.000,00");
        }else
          sink.add(valor);
      }
  );

  final validateAcumulado = StreamTransformer<bool,bool>.fromHandlers(handleData: (bool valor,sink){
    sink.add(valor);
  });
  final validateRendaFixa = StreamTransformer<bool,bool>.fromHandlers(handleData: (bool valor,sink){
    sink.add(valor);
  });

}