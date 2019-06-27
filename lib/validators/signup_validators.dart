
import 'dart:async';

class SignUpValidators{

   static String _senha;

  final validateNome = StreamTransformer<String,String>.fromHandlers(
    handleData: (nome,sink){
      if(nome.length>0){
        sink.add(nome);
      }else{
        sink.addError("Insira um nome");
      }
    }
  );
  final validateRg = StreamTransformer<String,String>.fromHandlers(
      handleData: (rg,sink){
        if(rg.length ==8){
          sink.add(rg);
        }else{
          sink.addError("RG inválido");
        }
      }
  );
  final validateCpf = StreamTransformer<String,String>.fromHandlers(
      handleData: (cpf,sink){
        sink.add(cpf);
      }
  );
  final validateOrgEmissor = StreamTransformer<String,String>.fromHandlers(
      handleData: (orgEmissor,sink){
        if(orgEmissor.length>0){
          sink.add(orgEmissor);
        }else{
          sink.addError("Insira o Orgão emissor");
        }
      }
  );
  final validateDataNascimento = StreamTransformer<String,String>.fromHandlers(
      handleData: (data,sink){
        if(data.length>0){
          sink.add(data);
        }else{
          sink.addError("Insira a data de nascimento");
        }
      }
  );

  final validateCelular = StreamTransformer<String,String>.fromHandlers(
      handleData: (celular,sink){
        if(celular.length == 14){
          sink.add(celular);
        }else{
          sink.addError("Insira um número válido");
        }
      }
  );
  final validateEmail = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        if(email.length>4 && email.contains("@")){
          sink.add(email);
        }else{
          sink.addError("Insira e-mail válido");
        }
      }
  );
  final validateSenha = StreamTransformer<String,String>.fromHandlers(
      handleData: (senha,sink){
        if(senha.length>4){
          _senha = senha;
          sink.add(senha);
        }else{
          sink.addError("Insira uma senha válida!");
        }
      }
  );
  final validateConfirmarSenha = StreamTransformer<String,String>.fromHandlers(
      handleData: (senha,sink){
        if(senha == _senha){
          sink.add(senha);
        }else{
          sink.addError("As senhas não são iguais!");
        }
      }
  );

   final validateCEP = StreamTransformer<String,String>.fromHandlers(
       handleData: (cep,sink){
         if(cep.length == 8){
           sink.add(cep);
         }else{
           sink.addError("Insira um CEP válido!");
         }
       }
   );

   final validateEndereco = StreamTransformer<String,String>.fromHandlers(
       handleData: (end,sink){
         if(end.length > 1){
           sink.add(end);
         }else{
           sink.addError("Insira um endereço válido!");
         }
       }
   );
   final validateNumero  = StreamTransformer<String,String>.fromHandlers(
       handleData: (num,sink){
         if(num.length > 0){
           sink.add(num);
         }else{
           sink.addError("Insira um número válido!");
         }
       }
   );
   final validateBairro = StreamTransformer<String,String>.fromHandlers(
       handleData: (bairro,sink){
         if(bairro.length > 1){
           sink.add(bairro);
         }else{
           sink.addError("Insira um bairro válido!");
         }
       }
   );

   final validateCidade  = StreamTransformer<String,String>.fromHandlers(
       handleData: (cid,sink){
         if(cid.length > 1){
           sink.add(cid);
         }else{
           sink.addError("Insira uma cidade válida!");
         }
       }
   );

   final validateEstado = StreamTransformer<String,String>.fromHandlers(
       handleData: (estado,sink){
         if(estado.length >0){
           sink.add(estado);
         }else{
           sink.addError("Selecione um estado");
         }
       }
   );

   final validateBanco = StreamTransformer<String,String>.fromHandlers(
       handleData: (banco,sink){
         if(banco.length >1){
           sink.add(banco);
         }else{
           sink.addError("Informe seu banco");
         }
       }
   );
   final validateAgencia = StreamTransformer<String,String>.fromHandlers(
       handleData: (agencia,sink){
         if(agencia.length >1){
           sink.add(agencia);
         }else{
           sink.addError("Informe sua agência");
         }
       }
   );
   final validateConta= StreamTransformer<String,String>.fromHandlers(
       handleData: (conta,sink){
         if(conta.length >1){
           sink.add(conta);
         }else{
           sink.addError("Informe sua conta");
         }
       }
   );

   final validateDigito = StreamTransformer<String,String>.fromHandlers(
       handleData: (digito,sink){
         if(digito.length >0){
           sink.add(digito);
         }else{
           sink.addError("Informe o dígito");
         }
       }
   );

}