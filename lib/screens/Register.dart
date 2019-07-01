import 'dart:convert';



import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

import './webView.dart';
import './AfterLoged/ScopedModel/AuthenticatedUserInfo.dart';

class RegisterPage extends StatelessWidget{
  var _formKey2;
  var _scaffoldKey;

  RegisterPage(@required this._formKey2, @required this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    
    return ScopedModel<AuthenticatedUserInfo>(
      model: AuthenticatedUserInfo(),
      child: Register(_formKey2, _scaffoldKey),

    );
  }
  
}


class Register extends StatefulWidget
{
  
  var _formKey2;
  final GlobalKey<ScaffoldState> _scaffoldkey;
  Register(@required this._formKey2, @required this._scaffoldkey);
  @override
  State<StatefulWidget> createState() {
    return RRegister(_formKey2);
  }
}


class RRegister extends State<Register>
{  
  final Key checkBoxKey = Key('__R1KEY__');

  bool termos = false;
  

  final snackBar = new SnackBar(
    content: new Text(resultadoCadastro, style: TextStyle(color: Colors.green),),
    duration: new Duration(seconds: 5),
  );


  static String resultadoCadastro = "";

  String id;
  var _formKey2;
  RRegister(this._formKey2);

  ScrollController listViewController = new ScrollController();
  TextEditingController remailController = new TextEditingController();
  TextEditingController rpasswordController = new TextEditingController();
  TextEditingController rtelefoneController = new TextEditingController();
  TextEditingController rnomeController = new TextEditingController();
  TextEditingController rcidadeController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    // checar p ver se o usuario deslizou a tela.
    printar_temp();
    ////////////////////////////////////////////
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return registro(width, height, _formKey2);

  }
  
  Future<void> printar_temp() async{
    while(true){
      await Future.delayed(Duration(seconds: 2), (){
        print("scrooled: " + listViewController.position.toString()); 
      });
    }
  }

  Widget registro(final double width, final double height, var _formKey2)
  {
    return ScopedModelDescendant<AuthenticatedUserInfo>(builder: (context, widget, model){
      return Form(
      key: _formKey2,
      child: ListView(
        controller: listViewController,
        children: <Widget>[
          Center(
            child:Column(
              children: <Widget>[
                Container(height: height/5.5,),

                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    autocorrect: true,
                    controller:rnomeController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.cyan,
                    validator: (String nomevalidator){
                      if(nomevalidator.isEmpty)
                      {
                        return "Nome inválido.";
                     }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "Nome Completo"
                    ),
                  ),
                ),

                Container(height: height/40,),

                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:remailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.cyan,
                    validator: (String emailvalidator){
                      if(emailvalidator.isEmpty || !emailvalidator.contains("@"))
                      {
                        return "E-mail inválido.";
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

                Container(height: height/40,),

                // cerurar
                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:rtelefoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.cyan,
                    validator: (String telefonevalidator){
                      if(telefonevalidator.isEmpty || telefonevalidator.length != 11)
                      {
                        return "Celular inválido.";
                      }else if(!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(telefonevalidator))
                      return "Celular inválido.";
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "Telefone",
                      hintText: "11981234567",
                    ),
                  ),
                ),

                Container(height: height/40,),

                // senha
                Padding(
                  padding: EdgeInsets.only(right: width/5, left: width /5),
                  child: TextFormField(
                    controller:rpasswordController,
                    cursorColor: Colors.cyan,
                    validator: (String password){
                      if(password.length < 6 || password.isEmpty)
                      {
                        return "Mínimo de 6 caracteres.";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: "Senha",
                    ),
                  ),
                ),
            

                Container(height: height/40,),

                Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                
                children: <Widget>[

                    Checkbox(

                      checkColor: Colors.black,
                      value: termos,
                      activeColor: Colors.white,
                      onChanged: (bool termosValue){
                        setState((){
                          this.termos = termosValue;
                        });
                      },
                    ),

                    GestureDetector(
                      child: RichText(
                        text: TextSpan(children: [
                            TextSpan(text: "Aceitar "),
                            TextSpan(text: "Termos de licença.", style: TextStyle(color: Colors.cyan)),
                          ],
                       ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext contexto){
                          return WebViewContainer("https://www.google.com/search?ei=vJgSXZKwDvG85OUP6dm8mAo&q=termos+de+licen%C3%A7a&oq=termos+de+licen%C3%A7a&gs_l=psy-ab.3..35i39j0i203j0i22i30l3.552.1121..1421...0.0..0.214.749.0j4j1......0....1..gws-wiz.......0i71.A_mRvdkkMkc");
                        }));
                      },
                    ),
                    

                  ],
                ),
                
                RaisedButton(
                      onPressed: ()
                      {
                        if(_formKey2.currentState.validate())
                        {
                          registro_e_status(rnomeController.text, rtelefoneController.text, remailController.text, rpasswordController.text);
                        }
                      },
                      child: Text("Registrar"),
                      elevation: 0.0,
                      color: Colors.red,
                    ),

              ],
            ),
          ),
        ],
      ),
    );
    },);
  }



  void fillDefaultUserDbInfo()
  {
    Map<String, dynamic> userInfo = {
      'nome':'',
      'email':"",
      'pagamento':[true, true, true],
      'diaNascimento':'',
      'mesNascimento':'',
      'anoNascimento':'',
      'cpf':'',
      'rg':'',
      'bairro':'',
      'rua':'',
      'numeroCasa':'',
      'cep':'',
      'complemento':'',
      'telefone':'',
      
    }; 
  }

  Future<void> registro_e_status(String nome, String telefone, String email, String password) async
  {
    if(this.termos != true)
    {
      showSnackBar("Necessário concordar com os termos de licença.");
      return;
    }
    String apiKey = "AIzaSyBWJ_NKL2kTYHBXjuO-Bk_QELvKSsdOVbg";
    String endPointRequest = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=";

    final Map<String, dynamic> authData = {
      'email':email,
      'password':password,
      'returnSecureToken':true
    };

     

    final http.Response response = await http.post(endPointRequest + apiKey, body: json.encode(authData), headers:{'Content-Type':'application/json'}).then((http.Response responseData){
      
      responseCheck(responseData);
      return;

    });
    return;
  }


void responseCheck(http.Response responsedata) async
{
  Map<String, dynamic> authResponse = json.decode(responsedata.body);
  bool success = false;
  String message = "Um erro foi encontrado.";

  if(authResponse.containsKey('idToken'))
  {
    //saveTokenOnDevice(authResponse);
    showSnackBar("Cadastro realizado com sucesso.");

  }else if(authResponse['error']['message'] == 'EMAIL_EXISTS'){
    showSnackBar("E-mail já cadastrado.");
  }

  clean_fields();

}


/*
  void saveTokenOnDevice(Map<String, dynamic> authResponse) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', authResponse['idToken']);
    prefs.setString('useremail', authResponse[remailController.text]);
    return;
  }
*/


  void clean_fields()
  {
    setState((){
      this.remailController.text = "";
      this.rpasswordController.text = "";
      this.rnomeController.text = "";
      this.rtelefoneController.text = "";
    });
  }

  void focar_teclado()
  {
    FocusScope.of(context).requestFocus(FocusNode());
    return;
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