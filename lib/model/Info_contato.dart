
enum SITUACAO{
  APROVADO,
  REPROVADO,
  PENDENDTE,
}
class  InfoContato{
  static const String NAME= "nome";
  static const String RG= "rg";
  static const String CPF= "cpf";
  static const String ORG_EMISSOR= "orgEmissor";
  static const String DATA_NASC= "dataNasci";
  static const String CELULAR= "celular";
  static const String EMAIL= "email";
  static const String CEP= "cep";
  static const String ENDERECO= "endereco";
  static const String NUM= "numero";
  static const String BAIRRO= "bairro";
  static const String CIDADE= "cidade";
  static const String ESTADO= "estado";
  static const String BANCO="banco";
  static const String AGENCIA="agencia";
  static const String CONTA="conta";
  static const String DIGITO="digito";
  static const String APROVADO ="situacao";
  static const String DATA_APROVACAO ="dataConclusaoPendencia";
  static const String DATA_RETIRADA_SOLICITADA ="dataRetiradaSolicitada";
  static const String DATA_RETIRADA_CONFIRMADA ="dataRetiradaConfirmada";
  static const int SITUACAO_APROVADO =1;
  static const int SITUACAO_REPROVADO =2;
  static const int SITUACAO_PENDENTE =0;
  static const int RETIRADA_PENDENTE =3;
  static const int RETIRADA_APROVADA =4;
  static const int MESES_CARENCIA =6;
  static const int QTD_DIAS_MES =30;
  static const String NOVO_APORTE ="novoAporte";
  static const String RESGATE_MENSAL ="resgateMensalRetirado";
  static const String RESGATE_MENSAL_APROVADO ="resgateMensalAprovado";


}