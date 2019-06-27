import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundo_fe/blocs/user_apro_bloc.dart';
import 'package:fundo_fe/login/LoginScreen.dart';
import 'package:fundo_fe/user/investimentos.dart';
import 'package:fundo_fe/user/investir_tab.dart';
import 'package:fundo_fe/user/pendenciasUser_tab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fundo_fe/widgets/edit_user.dart';

class HomeUser extends StatefulWidget {
  FirebaseUser _firebaseAuth;
  HomeUser(this._firebaseAuth);
  @override
  _HomeUserState createState() => _HomeUserState(_firebaseAuth);
}

class _HomeUserState extends State<HomeUser> {

  PageController _pageController;
  int _page =0;
  FirebaseUser _auth;
  UserBloc _bloc;
  _HomeUserState(this._auth);
  List<String> choiceMenu = ["Meus dados","Sair"];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bloc = UserBloc(_auth);
    _bloc.getUserName();
  }


  @override
  void dispose() {
    _pageController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: _bloc.outNameUser,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Text("${snapshot.data}",overflow: TextOverflow.ellipsis,);
            }else{
              return Text("Fundo FE");
            }
          }
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            elevation: 3.2,
            initialValue: choiceMenu[0],
            onSelected: (select){
              switch(select){
                case 'Meus dados':
                  if(_bloc.dadosUsuarioLogado == null){
                    Fluttertoast.showToast(
                      msg: "Erro ao carregar os dados, tente novamente.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );

                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditUsuario(usuarioEdit: _bloc.dadosUsuarioLogado,isAdm: false,)));
                  }
                  break;
                case 'Sair':
                  _bloc.logoutUser();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context){
              return choiceMenu.map((text){
                return PopupMenuItem<String>(
                    child: Text(text),value: text,);
              }).toList();
            },

          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.indigo[900],
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white54,),
          )
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
            onTap:(p){
            _pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.notifications_none),
                      StreamBuilder<List>(
                          stream: _bloc.outRetiradas,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return Positioned(
                                right: 0,
                                child: Container(
                                    padding: EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      "${_bloc.outRetiradasLenght == null ? "0" : _bloc.outRetiradasLenght}",
                                      style: TextStyle(color: Colors.white, fontSize: 8),
                                      textAlign: TextAlign.center,
                                    )),
                              );
                            }else{
                              return Container();
                            }
                          }
                      )
                    ],
                  ),
                  title: Text("Pendências")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  title: Text("Investir")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text("Histórico")
              ),
            ]
        ),
      ),
      body: SafeArea(
          child: BlocProvider<UserBloc>(
            bloc: _bloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p){
                setState(() {
                  _page =p;
                });
              },
              children: <Widget>[
                PendenciasUserTab(),
                StreamBuilder<DocumentSnapshot>(
                  stream: _bloc.outUser,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Investir(usuario: _bloc.dadosUsuarioLogado,);
                    }else{
                      return Center(child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),);
                    }
                  }
                ),
                Investimentos(),
              ],
            ),
          ),
      ),
    );
  }
}
