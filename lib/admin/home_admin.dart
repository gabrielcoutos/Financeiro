import 'package:flutter/material.dart';
import 'package:fundo_fe/admin/investimentos_admin_tab.dart';
import 'package:fundo_fe/admin/pendencias_tab.dart';
import 'package:fundo_fe/admin/users_tab.dart';
import 'package:fundo_fe/blocs/pendencias_bloc.dart';
import 'package:fundo_fe/login/LoginScreen.dart';
import 'package:fundo_fe/model/Usuario.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  PageController _pageController;
  int _page = 0;

  Usuario _usuario;
  PendenciasBloc _pendenciasBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _usuario = Usuario();
    _pendenciasBloc = PendenciasBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _usuario.dispose();
    _pendenciasBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fundo FE"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              _usuario.logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.indigo[900],
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.white54),
                )),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Icon(Icons.notifications_none),
                    StreamBuilder<List>(
                      stream: _pendenciasBloc.outPendencias,
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
                                  "${_pendenciasBloc.outTotalPendencias == null ? "0" : _pendenciasBloc.outTotalPendencias}",
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
                title: Text("Pendências"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money), title: Text("Finanças")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), title: Text("Usuários")),
            ]),
      ),
      body: SafeArea(
        child: BlocProvider<Usuario>(
          bloc: _usuario,
          child: BlocProvider<PendenciasBloc>(
            bloc: _pendenciasBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                PendenciasTab(),
                InvestimentosAdmin(),
                UsersTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
