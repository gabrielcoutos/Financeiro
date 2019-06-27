import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/user_apro_bloc.dart';
import 'package:fundo_fe/widgets/investimentos_tile.dart';
class Investimentos extends StatefulWidget {
  @override
  _InvestimentosState createState() => _InvestimentosState();
}

class _InvestimentosState extends State<Investimentos> {
  @override
  Widget build(BuildContext context) {
    final _investimentosBloc = BlocProvider.of<UserBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
        stream: _investimentosBloc.outAportes,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[900]),
                )
            );
          } else if(snapshot.data.length ==0){
            return Center(
              child: Text("Nenhum investimento"),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                return InvestimentosTile(snapshot.data[index]);
              },
            );
          }

        },
      ),
    );
  }
}
