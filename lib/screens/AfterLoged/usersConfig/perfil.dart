import 'package:Fretex/screens/AfterLoged/ScopedModel/AuthenticatedUserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:convert';



class Perfil extends StatelessWidget
{
  
  double width;
  double height;
  Perfil(@required this.height, @required this.width);
  


  @override
  Widget build(BuildContext context) {
    return ScopedModel<AuthenticatedUserInfo>(
      model: AuthenticatedUserInfo(),
      child: Scaffold(
      key: Keys.scaffoldKey,
      appBar: AppBar(
        title: Text("Editar Perfil"),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        elevation: 0.0, 
        backgroundColor: Colors.blueGrey,),
      body: ScopedModelDescendant<AuthenticatedUserInfo>(builder:(context, widget, model){
        return UserPerfil(width, height, model);
      }),
    ),
    );
  } // build
}

class UserPerfil extends StatefulWidget{
  AuthenticatedUserInfo _model;
  double width;
  double height;
  UserPerfil(@required this.width, @required this.height, @required this._model);


  @override
  State<StatefulWidget> createState() {
    return _Perfil();
  }
}

class _Perfil extends State<UserPerfil>{
  
  List<Color> submitButtonCollor = [Colors.blueGrey, Colors.green];
  int indexButtonCollor = 0;
  String saveData = "Salvar";
  var _ano = [];
  var _meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
  var _dias = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
  String _mesEscolhido = "Janeiro";
  String _diaEscolhido = "1";
  String _anoEscolhido = "1900";
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState(){
    for(int i = 0; i<=120 ;i++)
    {
      _ano.add( 1900 + i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(padding: EdgeInsets.all(20),
          children: [

            // foto
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){

                    getPermissionToLoadPhoto();
                    debugPrint("Clicou");
                  },
                    child: ClipOval(
                    child: Image.network(widget._model.userPhotoUrl_orDeviceLocation,
                      width: widget.height/3,
                      height: widget.width/3,
                      fit: BoxFit.contain,
                      ),
                    ),),
                    SizedBox(height: widget.height/70,),
                    GestureDetector(onTap: (){
                      debugPrint("Clicou nome");
                    },
                      child:Text( widget._model.nome.toString() , style: TextStyle(fontSize: widget.height/30, ),),),
              ],
            ),

            // apenas um espacinho
            SizedBox(height: widget.height/40  ,),

            // Botão para mudar a foto          
            FlatButton(
              color: Colors.blueGrey,
              highlightColor: Colors.white,
              onPressed: (){
              getPermissionToLoadPhoto();
              debugPrint("Mudar foto");
            },
              child: Text("Mudar Foto", style: TextStyle(color: Colors.white),), ),
            SizedBox(height: widget.height / 30,),
            Divider(),
            
            Text("Nome ", style: TextStyle(color: Colors.grey),),
            SizedBox(height: widget.height/150,),
            GestureDetector(
              child:Text(widget._model.nome.toString(), style: TextStyle(color: Colors.blueGrey   , fontSize: widget.height/40),),
              onTap: (){
                // on change name
              },
            ),
      /*
            // nome field
            TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: Controllers.nome,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                labelText: "Nome Completo",
              ),
            ),
*/
            // apenas para dar um espacinho.
            SizedBox(height: widget.height/30,),


            Text("Email ", style: TextStyle(color: Colors.grey),),
            SizedBox(height: widget.height/150,),
            GestureDetector(
              child: Text(widget._model.email.toString(), style: TextStyle(color: Colors.blueGrey   , fontSize: widget.height/40),),
              onTap: (){
                // to change the email
              },
            ),

            /*
            // email
            TextFormField(
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.emailAddress,
              controller: Controllers.email,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                labelText: "E-mail",
              ),
            ),
            */

            SizedBox(height: widget.height/30,),

            // data de nascimento label
            Row(children: <Widget>[Text("* ", style: TextStyle(color: Colors.red),) ,Text("Nascimento", style: TextStyle(color: Colors.grey)),],),
            
            SizedBox(height: widget.height/90,),

            // data de nascimento items de drop down menu
            Row(children: <Widget>[
              Flexible(child:  DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              isDense: true,
              items: _meses.map((String mesEscolhido){
                return DropdownMenuItem<String>(value: mesEscolhido, child: Text(mesEscolhido));
              }).toList(),
              value: _mesEscolhido,
              onChanged: (String newMesEscolhido){
                setState((){
                  _mesEscolhido = newMesEscolhido;
                  widget._model.notifyListeners();
                });
              },
              hint: Text("Mes"),
            ),
              ),

              SizedBox(width: widget.width/30,),

              Flexible(child:  DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              isDense: true,
              items: _dias.map((int diaEscolhido){
                return DropdownMenuItem<String>(value: diaEscolhido.toString(), child: Text(diaEscolhido.toString()));
              }).toList(),
              value: _diaEscolhido.toString(),
              onChanged: (String newDiaEscolhido){
                setState((){
                  _diaEscolhido = newDiaEscolhido;
                });
              },
              hint: Text("Dia"),
            ),
              ),


              SizedBox(width: widget.width/40,),

              Flexible(child:  DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              isDense: true,
              items: _ano.map((var anoEscolhido){
                return DropdownMenuItem<String>(value: anoEscolhido.toString(), child: Text(anoEscolhido.toString()));
              }).toList(),
              value: _anoEscolhido.toString(),
              onChanged: (String newAnoEscolhido){
                setState((){
                  _anoEscolhido = newAnoEscolhido;
                });
              },
              hint: Text("Ano"),
            ),
              ),

              ],
            ),
            

            // apenas para dar um espacinho.
            SizedBox(height: widget.height/40,),

            // rg e cpf um do lado do outro
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              // CPF
              Flexible(child: widget._model.cpf == null ?
                TextFormField(
                  validator: (String cpfInput){
                    if(cpfInput.isEmpty)
                    {
                      return "CPF necessário.";
                    }else if(!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(cpfInput))
                    {
                      return "Cpf Inválido.";
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: Controllers.cpf,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*" + "CPF",
                  ),
                )
                : Column(children: <Widget>[
                    Text("CPF: ", style: TextStyle(color: Colors.grey),),
                    SizedBox(height: widget.height/150,),
                    Text(widget._model.cpf.toString(), style: TextStyle(color: Colors.blueGrey, fontSize: widget.height/30),),
                  ],
                ),
              ),            

              // apenas um espacinho
              SizedBox(width: widget.width/40,),
              VerticalDivider(color: Colors.black,width: 5.0,),

              // RG
              Flexible(child: widget._model.rg == null ?
                TextFormField(
                  validator: (String rgValidator){
                    if(rgValidator.isEmpty)
                    {
                      return "RG necessário.";
                    }else if(!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(rgValidator))
                    {
                      return "RG inválido.";
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: Controllers.rg,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*" + "RG",
                  ),
                )
                : Column(children: <Widget>[
                    Text("RG: ", style: TextStyle(color: Colors.grey),),
                    SizedBox(height: widget.height/150,),
                    Text(widget._model.rg.toString(), style: TextStyle(color: Colors.blueGrey, fontSize: widget.height/30),),
                  ],
                ),
              ),
              
              ],
            ),
            
            // apenas para dar um espacinho.
            SizedBox(height: widget.height/30,),
            SizedBox(height: widget.height/100),
            
            FlatButton(
              color: Colors.red,
              child: Text("Formas de Pagamento", style: TextStyle(color: Colors.white,),),
              onPressed: (){
                // code to perform
              }, 
            ),

              SizedBox(height: widget.height/80,),
            
            // CheckBox: Dinheiro, Débito, Crédito.
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[  
                
                
                Column(
                  children: <Widget>[ 
                    // dinheiro
                    Checkbox(
                      onChanged: (bool valor){
                        setState((){
                          widget._model.pagamento['Dinheiro'] = valor;
                          widget._model.notifyListeners();
                        });
                      },
                      value: widget._model.pagamento['Dinheiro'],
                      activeColor: Colors.cyan,
                    ),
                    Image.asset("images/coins.png", height: 35, width: 35,), 
                    Text("Dinheiro", style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(width: widget.width/10,),

                 Column(
                    children: <Widget>[ 
                     // crédito
                      Checkbox(
                        onChanged: (bool valor){
                          setState((){
                          widget._model.pagamento['Credito'] = valor;
                          widget._model.notifyListeners();
                        });
                      },
                      value: widget._model.pagamento['Credito'],
                      activeColor: Colors.cyan,
                    ),
                     Image.asset("images/credit-card.png", height: 35, width: 35,), 
                     Text("Crédito", style: TextStyle(color: Colors.grey),
                     ),
                    ],
                  ),

                SizedBox(width: widget.width/10,),

                // débito
                Column(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (bool valor){
                        setState((){
                          widget._model.pagamento['Debito'] = valor;
                          widget._model.notifyListeners();
                        });
                      },
                      value: widget._model.pagamento['Debito'],
                      activeColor: Colors.cyan,
                    ), 
                    Image.asset("images/debit.png", height: 35, width: 35,), 
                    Text("Débito", style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

              ],
            ),
            
            
            SizedBox(height: widget.height/30,),

          // cep

           widget._model.cep == null ? TextFormField(
             validator: (String cepValidator){
               if(cepValidator.isEmpty)
               {
                 return "Cep Inválido.";
               }
             },
                  keyboardType: TextInputType.number,
                  controller: Controllers.cep,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*Cep",
                    hintText: "12211-510"
                  ),
                ) : Column(
                  children: <Widget>[
                    Text("CEP:"),
                    SizedBox(height: widget.height/150,),
                    GestureDetector(
                      child: Text(widget._model.cep.toString(), style: TextStyle(fontSize: widget.height/30, color: Colors.blueGrey),
                      ),
                      onTap: (){
                        // code to change cep
                      }
                    ),
                  ],
                ),

              widget._model.cep == null ? SizedBox(height: 0, width: 0,) : Divider(color: Colors.grey,),

            Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              Flexible( 
                child: widget._model.cep == null ? TextFormField(
                  keyboardType: TextInputType.text,
                  controller: Controllers.bairro,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*Bairro",
                    hintText: "Santana"
                  ),
                )  : Column(
                  children: <Widget>[
                    Text("Bairro:"),
                    SizedBox(height: widget.height/150,),
                    GestureDetector(child: Text(widget._model.bairro.toString(),textAlign: TextAlign.center ,style: TextStyle(color: Colors.blueGrey, fontSize: widget.height / 40),),
                    onTap:(){
                      // code to change bairro
                    }
                    ),
                  ],
                ),
              ),
              VerticalDivider(),
              SizedBox(width: widget.width/40,),

              Flexible(
                child: widget._model.cep == null ? TextFormField(
                  keyboardType: TextInputType.text,
                  controller: Controllers.rua,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*Rua",
                    hintText: "Avenida Simões Darcila",
                  ),
                ) : Column(
                  children: <Widget>[
                    Text("Rua: "),
                    SizedBox(height: widget.height/150,),
                    Text(widget._model.rua.toString(), style: TextStyle(color: Colors.blueGrey, fontSize: widget.height/40), textAlign: TextAlign.center,),
                      
                    
                  ],
                ),
              ),

              

              ],
            ),
            // Número casa
            Row(children: <Widget>[
                Flexible(
                child: TextFormField(
                  validator: (String numeroCasa){
                    if(numeroCasa.isEmpty)
                    {
                      return "Número necessario.";
                    }else if(!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(numeroCasa))
                    {
                      return "Número Inválido.";  
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: Controllers.numeroCasa,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "*Número",
                    hintText: "123",
                  ),
                ),
              ),
              SizedBox(width: widget.width/40,),
              // Complemento
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: Controllers.complemento,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
                    labelText: "Complemento",
                    hintText: "Edificio Genesis, apto 1:2",
                  ),
                ),
              ),

              ],
            ),

            SizedBox(height: widget.height/30,),  
            FlatButton(

              color: submitButtonCollor[indexButtonCollor],
              highlightColor: Colors.white,
              onPressed: (){
              if(_formKey.currentState.validate()){
              
                if(_diaEscolhido == 1 && _mesEscolhido == "Janeiro" && _anoEscolhido == "1900")
                {
                  showSnackBar("Necessário alterar a data de nascimento.", 3);
                  return;
                }

                // AQUI É ONDE OS DADOS VÂO SER ESTORADOS.

                
                //atualizeAuthenticatedUserInfo(anoNascimento: _anoEscolhido, diaNascimento: _diaEscolhido, mesNascimento: _mesEscolhido, cep: Controllers.cep.text, cpf: Controllers.cpf.text, rg: Controllers.rg.text, complemento: Controllers.complemento.text, numero: Controllers.numeroCasa.text);
                widget._model.cpfChange = Controllers.cpf.text;
                setState((){
                  indexButtonCollor = 1;
                  Controllers.clearFields();
                });
                //debugPrint("Salvar Dados");

              }
            },
            
            child: indexButtonCollor == 1 ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check, color: Colors.white,),
                SizedBox(width: widget.width/80,),
                Text("Salvo", style: TextStyle(color: Colors.white),),
              ],
            ) 
            
            : Text(saveData, style: TextStyle(color: Colors.white),), ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message, int seconds)
  {
    final snackBar = new SnackBar(
    content: new Text(message, style: TextStyle(color: Colors.red),),
    duration: new Duration(seconds: seconds),
  );

    Keys.scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void atualizeAuthenticatedUserInfo({String rg, String cpf,String diaNascimento, String mesNascimento, String anoNascimento, bool dinheiro, bool debito, bool credito, String cep, String numero, String complemento}){
    setState((){

      // Nascimento info
      widget._model.diaNascimento = diaNascimento;
      widget._model.mesNascimento = mesNascimento;
      widget._model.anoNascimento = anoNascimento;


      widget._model.cpf = cpf;
      widget._model.rg = rg;

      // Payment info
      widget._model.pagamento['Dinheiro'] = dinheiro;
      widget._model.pagamento['Debito'] = debito;
      widget._model.pagamento['Credito'] = credito;

      // Address info
      widget._model.cep = cep;   
      widget._model.numero_casa = numero;
      widget._model.complemento = complemento;
      
      // notify others that also implements Scoped Model from AuthenticatedUserInfo that some of its fields has changed.
      widget._model.notifyListeners();
    });
  }


  void getPermissionToLoadPhoto() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Widget _simplePopUp() => PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(value: 1, child: Text("First")),
      PopupMenuItem(value: 2, child: Text("Second")),
    ],
  );

}

class Controllers{
  //static TextEditingController nome = new TextEditingController();
//  static TextEditingController email = new TextEditingController();
  static TextEditingController cep = new TextEditingController();
  static TextEditingController bairro = new TextEditingController();
  static TextEditingController rg = new TextEditingController();
  static TextEditingController cpf = new TextEditingController();
  static TextEditingController rua = new TextEditingController();
  static TextEditingController complemento = new TextEditingController();
  static TextEditingController numeroCasa = new TextEditingController();
  
  static void clearFields()
  {
    cep.clear();
    bairro.clear();
    rg.clear();
    cpf.clear();
    rua.clear();
    complemento.clear();
    numeroCasa.clear();
  }


}

class Keys{
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}


class GetScopedModelInfo{
  
  static AuthenticatedUserInfo authModel;
  static bool resultadosSaoNull = false;
    
}