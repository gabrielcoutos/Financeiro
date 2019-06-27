import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/pendencias_bloc.dart';
import 'package:fundo_fe/model/Info_contato.dart';
import 'package:fundo_fe/widgets/pendenciaMensalTile.dart';
import 'package:fundo_fe/widgets/pendencias_tile.dart';
import 'package:fundo_fe/widgets/user_tile.dart';
class PendenciasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pendenciasBloc = BlocProvider.of<PendenciasBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
        stream: _pendenciasBloc.outPendencias,
        builder: (context, snapshot) {
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
                if(snapshot.data[index][InfoContato.EMAIL]!=null){
                  return UserTile(snapshot.data[index]);
                }else if(snapshot.data[index][InfoContato.APROVADO] != InfoContato.SITUACAO_APROVADO){
                  int indexUser =_pendenciasBloc.todosUsuarios.indexWhere((test)=> test.documentID == snapshot.data[index]["userId"]);
                  return PendenciasTile(snapshot.data[index],_pendenciasBloc.todosUsuarios[indexUser]);
                }else{
                  int indexUser =_pendenciasBloc.todosUsuarios.indexWhere((test)=> test.documentID == snapshot.data[index]["userId"]);
                  return PendenciaMensalTile(snapshot.data[index],_pendenciasBloc.todosUsuarios[indexUser]);
                }
              },
            );
          }
        }
      ),
    );
  }
}
