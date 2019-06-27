import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/user_apro_bloc.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/widgets/resgateMensalUser.dart';
import 'package:fundo_fe/widgets/retiradas.dart';
class PendenciasUserTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _pendenciasRetiradas = BlocProvider.of<UserBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
        stream: _pendenciasRetiradas.outRetiradas,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),
                )
            );
          } else if(snapshot.data.length ==0){
            return Center(
              child: Text("Nenhuma pendência no momento!"),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                if(snapshot.data[index][InfoContato.RESGATE_MENSAL_APROVADO]){
                  return ResgateMensal(snapshot.data[index]);
                }else {
                  return Retiradas(snapshot.data[index]);
                }
              },
            );
          }
        }
      ),
    );
  }
}
