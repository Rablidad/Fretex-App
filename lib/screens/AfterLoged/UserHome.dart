
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';


import 'package:flutter/services.dart';



import './ScopedModel/AuthenticatedUserInfo.dart';
import '../AfterLoged/usersConfig/perfil.dart';
import '../Login.dart';
import '../../configs/userAuthConfig.dart';


import 'dart:convert';


class UserHomeNoState extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AuthenticatedUserInfo>(model: AuthenticatedUserInfo(),
      child: UserHome(),
    );
  }

}

class UserHome extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    return _UserHome();
  }

}

class _UserHome extends State<UserHome>{
  
  double height;
  double width;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool permission = false;

  List<Color> driverNotification = [Colors.grey, Colors.red];
  int indexUserNotification = 0;

  
  

  @override
  void initState()
  {
    debugPrint("initState user home");
    
    getPermission();

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    debugPrint("Chamou user home");
    
    return ScopedModel<AuthenticatedUserInfo>(
      model: AuthenticatedUserInfo(), 
        child: Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: driverNotification[indexUserNotification],
        icon: Icon(Icons.near_me), 
        label: Text("Viagens"),
        onPressed: (){
          // code to open request pages
        },
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.menu, color: Colors.black, size: 25.0,),
          onTap: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: ScopedModelDescendant<AuthenticatedUserInfo>(builder: (context, widget, model){
        return drawerWidget(model);
      },),
      body: ScopedModelDescendant<AuthenticatedUserInfo>(builder: (context, widget,model){
        return homePage(model);
      },),
    ),


      );
    
    
    
  }


  Widget homePage(AuthenticatedUserInfo model){
    return Container();
  }


  void getSettingsOnDeviceandClear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance().then((SharedPreferences shar){
      shar.clear();
    });
  }

  Widget drawerWidget(AuthenticatedUserInfo model)
  {
    return Drawer(
        child: Column(children: <Widget>[
              Container(height: height/5 , color: Colors.blueGrey, 
                child: Row(children: <Widget>[
                  Container(width: width/20,),
                  GestureDetector(onTap: (){
                    gotoPerfil();
                  },
                    child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: height/20,
                    child: Image.network(model.userPhotoUrl_orDeviceLocation,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                    
                    Padding(padding: EdgeInsets.only(left: width/20), child: Text( model.nome.toString(), style: TextStyle(color: Colors.white, fontSize: height/40),),),

                  ],
                ),
              ),

              SizedBox(height: height/20,),

              Divider(),
              ListTile(
                leading: Icon(Icons.person, size: height/25 ,color: Colors.grey),title: Text("Perfil", style: TextStyle(fontSize: height/40, color: Colors.black54)),
                onTap: (){
                  gotoPerfil();
                },
              ),

              Divider(),
              ListTile(leading: Icon(Icons.image, size: height/25 , color: Colors.grey,), title: Text("Fotos do caminhão", style: TextStyle(fontSize: height/40, color: Colors.black54),), onTap:(){
                // code to go to fotos do caminhão
              }),
              Divider(),
              ListTile(leading: Icon(Icons.exit_to_app, size: height/25 ,color: Colors.red,),title: Text("Sair", style: TextStyle(fontSize: height/40, color: Colors.black54)),onTap: (){
                  configAndExit();
                },
              ),
              Divider(),

              Divider(),
            ],
          ),
        );
  }

  void configAndExit()
  {
    getSettingsOnDeviceandClear();
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3), content: Row(children: <Widget>[Icon(Icons.exit_to_app), SizedBox(width: 10,) ,Text("Saindo...")],),),);
    Future<void>.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context){
        return Login();
      }));
    });
  }

  void gotoPerfil()
  {
    Navigator.pop(context);
    Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context){
      return Perfil(height, width);
    }));
  }

  void getPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }

  void checkPermission()async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    debugPrint("Valor da permissao: " + permission.value.toString());
  }

  void openSettings() async{
    await PermissionHandler().openAppSettings();
  }

  void seUsuarioNaoPreencheuPerfil(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text("Music"),
                onTap: () => {}
              ),
              new ListTile(
                leading: Icon(Icons.person),
                title: Text("Teste"),
                onTap: (){},
              ),
            ],
          )
        );
      }
    );
  }

}

class GetScopedModelInfo{
  
  static AuthenticatedUserInfo authModel;
  static bool resultadosSaoNull = false;

  

  /*
  static bool estaoOsCamposDoPerfilPreenchidos()
  {
    bool resultado = authModel.cpf_rg_pagamento_sao_null();
    if(resultado == true)
    {
      return false;
    }
    return true;
  }
  */
    
}