import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

import './screens/Login.dart';
import './screens/AfterLoged/UserHome.dart';
//import './configs/userAuthConfig.dart';

import 'dart:async';


main()
{
  runApp(MyApp());
}


class MyApp extends StatefulWidget 
{
  @override
  _MyApp createState(){
    return _MyApp();
  }
}



class _MyApp extends State<MyApp> with AutomaticKeepAliveClientMixin<MyApp>
{
  bool authenticated = false;

  Future<void> _loadingPresets;

  

  @override
  void initState()
  { 
    _loadingPresets = checkIfAuthenticatedOnce();
    debugPrint("At the init state");
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    debugPrint("Building...");
    return mainModel();
  }


  Widget mainModel()
  {
    debugPrint("mainModel()");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fretex - Driver",
      theme: ThemeData(
          //primarySwatch: Colors.deepPurple,
        ),
        routes: {
          '/': (BuildContext context) => loginOrHome(context),
          '/homePage' : (BuildContext context) => UserHome(),
          
          },
        );
  }

  Widget loginOrHome(BuildContext context)
  {

    return FutureBuilder(
      future: _loadingPresets, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        debugPrint("Snapshot: " + snapshot.data.toString());
        switch(snapshot.connectionState){
          case ConnectionState.none:
            return CircularProgressIndicator();
          case ConnectionState.waiting: return CircularProgressIndicator();
          default:
            if(snapshot.hasError)
            {
              return Text("Error: ${snapshot.error}");
            }
            else
              if(snapshot.data == null && authenticated == true)
              {
                return UserHome();
              }
              else
                return Login();
        }
      },
    );

    //return authenticated == false ? Login() : UserHome();

  }

  /*

  ScopedModelDescendant<UserAuthInfo>(builder: (BuildContext context, Widget vwidget ,UserAuthInfo model){
              debugPrint("estamos no Descedant");
              return model.getAuthenticationValue == false ? Login() : UserHome();
            },
          ),

          */


  // {
  //   MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: "Fretex - Driver",
  //     //home: Login(),
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue
  //     ),
  //     routes: {
  //       '/': authenticated == true ? (BuildContext context) => UserHome() : (BuildContext context) => Login(),
  //       '/userhome': (BuildContext context) => null,
  //     },
  //   );
  // }


  Future<void> checkIfAuthenticatedOnce() async
  {
    debugPrint("Lendo Token...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      final String email = prefs.getString('useremail');
      if(token != null)
      {
        authenticated = true;
        debugPrint("Token encontrado!");
        debugPrint("Token é: " + token);
        debugPrint("email é: " + email);
        return;
      }
      debugPrint("Token não encontrado!");
      authenticated = false;
      return;
  }

  @override
  bool get wantKeepAlive => true;


  

}


