import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


class Recover extends StatefulWidget
{
  final GlobalKey<ScaffoldState> _scaffoldkey;
  
  var _formKey3;
  Recover(this._formKey3, @required this._scaffoldkey);

  @override
  State<StatefulWidget> createState() {
    return _Recover(_formKey3);
  }
}

class _Recover extends State<Recover>
{


  final snackBar = new SnackBar(
    content: new Text("Recuperação solicitada, cheque o seu e-mail.", style: TextStyle(color: Colors.red),),
    duration: new Duration(seconds: 5),
  );



  var _formKey3;
  _Recover(this._formKey3);
  TextEditingController email_phone_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return recover(width, height, _formKey3);
  }
  
  Widget recover(double width, double height, var _formKey3)
  {

    

    return Form(
      key: _formKey3,
      child: ListView(
        children: <Widget>[
          Center(
            child:Column(
              children: <Widget>[

                SizedBox(height: height/2.5,
                  child: Column(children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: height/5), 
                          child: Center(
                            child:Icon(Icons.refresh, size: height/20,color: Colors.red, 
                            ),
                          ),
                        ),
                      ), 
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:email_phone_Controller,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.cyan,
                    validator: (String email_to_phone_validator){
                      if(email_to_phone_validator.isEmpty)
                      {
                        return "Insira seu e-mail.";
                     }
                      return null;
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "E-mail"
                    ),
                  ),
                ),

                SizedBox(height: height/40,),

                

                RaisedButton(
                  onPressed: ()
                  {
                    if(_formKey3.currentState.validate())
                    {
                      submit_recoverAcount(email_phone_Controller.text);
                      // code to perform database server authentication
                    }
                  },
                  child: Text("Recuperar"),
                  elevation: 0.0,
                  color: Colors.red,
                )


              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submit_recoverAcount(String email) async {

    String endpointRequest = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getOobConfirmationCode?key=";
    String apiKey = "AIzaSyBWJ_NKL2kTYHBXjuO-Bk_QELvKSsdOVbg";


    Map<String, dynamic> user_payload = {'requestType':'PASSWORD_RESET','email':email};

    final http.Response response = await http.post(endpointRequest + apiKey, headers:{'Content-Type':'application/json'}, body: json.encode(user_payload) ).then((http.Response responseData){
      
      checkResponse(responseData);
      return;
      
    });

    return;
  }

  void checkResponse(http.Response responsedata)
  {
    Map<String, dynamic> authResponse = json.decode(responsedata.body);
    if(authResponse.containsKey('kind') || authResponse.containsKey('email')){
      showSnackBar('Pedido enviado, cheque o seu e-mail.');
    }else if(authResponse['error']['message'] == 'EMAIL_NOT_FOUND'){
      showSnackBar("E-mail não encontrado.");
    }
    foco_tela();
  }


  void foco_tela()
  {
    FocusScope.of(context).requestFocus(FocusNode());
  }



  void showSnackBar(String message)
  {
    final snackBar = new SnackBar(
    content: new Text(message, style: TextStyle(color: Colors.red),),
    duration: new Duration(seconds: 5),
  );

    widget._scaffoldkey.currentState.showSnackBar(snackBar);
  }

}