import 'dart:convert';

import './AfterLoged/UserHome.dart';
import './Register.dart';
import './Recover.dart';

//
import '../configs/userAuthConfig.dart';
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget
{ 
  @override
  State<StatefulWidget> createState() {
    return LLogin();
  }
  
}



class LLogin extends State<Login>
{

  
  bool _loading = false;

  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;

  

  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  var _formKey3 = GlobalKey<FormState>();
  double height;
  double width;

  bool authenticated;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    debugPrint("Entrei antes que o token fosse encontrado.");

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            key: _scaffoldKey,
            bottomNavigationBar: TabBar(
            onTap: (index){
              if(this.emailController.text.isNotEmpty)
              {
                this.emailController.text = "";
                this.passwordController.text = "";  
              }
            },
            
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home), text: "Entrar",),
              Tab(icon: Icon(Icons.create), text: "Registrar",),
              Tab(icon: Icon(Icons.refresh), text: "Recuperar",),
              
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.cyan,
            indicatorColor: Colors.cyan,
          ),
          body: TabBarView(
            children: <Widget>[
              loginPage(),
              RegisterPage(_formKey2, _scaffoldKey),
              Recover(_formKey3, _scaffoldKey),
            ],
          ),
        ),),
      ),
    );
    
  }


  Widget loginPage()
  {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Center(
            child:Column(
              children: <Widget>[
                Container(height: height/2.5,),

                // email
                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.cyan,
                    validator: (String emailvalidator){
                      if(emailvalidator.isEmpty || !emailvalidator.contains("@"))
                      {
                        return "";
                     }
                      return null;
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "E-mail"
                    ),
                  ),
                ),

                Container(height: height/40,),

                // senha
                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:passwordController,
                    cursorColor: Colors.cyan,
                    validator: (String password){
                      if(password.length < 6 || password.isEmpty)
                      {
                        return "";
                      }
                      return null;
                    },
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "Senha",
                    ),
                  ),
                ),
                Container(height: height/40,),

                RaisedButton(
                  onPressed: ()
                  {
                    if(_formKey.currentState.validate())
                    {
                        showSnackBar("Carregando...", 3);
                        print("Loading: " + this._loading.toString()); 
                        loginValidator(emailController.text, passwordController.text);  
                        
                        
                        // Using CupertinoPageRoute it will make the transition from right to left
                        //Navigator.pushReplacement(context, CupertinoPageRoute(builder: (BuildContext context){
                         // return UserHome();
                        //},));
                    }
                  },
                  child: Text("Entrar"),
                  elevation: 0.0,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  

  void loginValidator(String email, String password) async
  {

      final Map<String, dynamic> authData = {
        'email':email,
        'password':password,
        'returnSecureToken': true  
      };

      String apiKey = "AIzaSyBWJ_NKL2kTYHBXjuO-Bk_QELvKSsdOVbg";
      String endPointRequest = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=";
    

      // send the request to the site to login a user
      final http.Response response = await http.post(endPointRequest + apiKey, body:json.encode(authData), headers: {'Content-Type':'application/json'}).then((http.Response responsedata){
      checkResponse(responsedata);
    });

    return;
  }


  void showSnackBar(String message, int seconds)
  {
    final snackBar = new SnackBar(
    content: new Text(message, style: TextStyle(color: Colors.red),),
    duration: new Duration(seconds: seconds),
  );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void checkResponse(@required http.Response responseData)async{
    
    final Map<String, dynamic> authResponse = json.decode(responseData.body);

    if(authResponse.containsKey('localId') || authResponse.containsKey('idToken')){
      
      storeUserAuthenticationSettings(authResponse);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
        return UserHomeNoState();
      }));
    }
    else if(authResponse['error']['message'] == 'EMAIL_NOT_FOUND')
    {
      showSnackBar("Email não encontrado.", 5);
    }else if(authResponse['error']['message'] == 'INVALID_PASSWORD'){
      showSnackBar("Senha incorreta.", 5);
    }else{
      showSnackBar("Erro no login.", 5);
    }

    return;
  }

  void storeUserAuthenticationSettings(Map<String, dynamic> authResponse) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance().then((SharedPreferences result){
      result.setString('token', authResponse['idToken']);
      result.setString('useremail', authResponse['email']);
      return;
    });
    return; 
  }
  
}