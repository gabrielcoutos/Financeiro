import 'package:flutter/material.dart';
import 'package:fundo_fe/login/LoginScreen.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fundo FE',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.indigo[900],

        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

      );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 0,end: 300).animate(controller)..addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
      }
    });
    controller.forward();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:ImgSplashScreen(animation),color: Colors.blueGrey[100],);
  }
}

class ImgSplashScreen extends AnimatedWidget {

  ImgSplashScreen(Animation<double> animation): super(listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Image.asset("imagens/logo_FFE.png",
        height: animation.value,
        width: animation.value,
      ),
    );
  }

}

