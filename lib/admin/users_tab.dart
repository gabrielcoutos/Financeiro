import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/model/Usuario.dart';
import 'package:fundo_fe/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<Usuario>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _userBloc.outUsuario,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),),);
          }
          else if (snapshot.data.length == 0){
            return Center(
              child: Text("Nenhum usuário encontrado!"),
            );
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return UserTile(snapshot.data[index]);
              },
            );
          }
        }
      ),
    );
  }
}
