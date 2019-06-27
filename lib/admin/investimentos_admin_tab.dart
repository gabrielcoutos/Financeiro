import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/pendencias_bloc.dart';
import 'package:fundo_fe/widgets/InvestimentoAdmin_tile.dart';

class InvestimentosAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _investimentosController = BlocProvider.of<PendenciasBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
        stream: _investimentosController.outInvestimentos,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),
                )
            );
          } else if(snapshot.data.length ==0){
            return Center(
              child: Text("Nenhum investimento no momento!"),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                int indexUser = _investimentosController.todosUsuarios.indexWhere((user)=> user.documentID == snapshot.data[index]["userId"]);
                return InvestimentosAdminTile(snapshot.data[index],_investimentosController.todosUsuarios[indexUser]);

              },
            );
          }
        },
      ),
    );
  }
}
