import 'package:scoped_model/scoped_model.dart';

// essas informações vão ser carregadas do database e trazidas para cá, durante login, registro e/ou update de dados no perfil do usuario e muitos outros casos.
class AuthenticatedUserInfo extends Model
{
  // settings to enable authentication and/or load info per user.
  String idToken = null;
  String localId = null;
  String userDbId = null;
  //////////////// Db = Database.
  
  String nome = "Raique de Andrade";
  String email = "Raique1928@gmail.com";


  String anoNascimento = null;
  String diaNascimento = null;
  String mesNascimento = null;
  String cpf= null,rg = null;
  String cep = null;
  String bairro = null;
  String numero_casa = null;
  String rua = null;
  String complemento = null;
  String telefone = null;
  String userPhotoUrl_orDeviceLocation = "https://i.ya-webdesign.com/images/default-avatar-png-6.png";




  Map<String, bool> pagamento = {"Dinheiro":true, "Debito":true, "Credito":true};


  // [0] = cpf | [1] = rg
  void set cpf_rgStter(List<String> rg_cpf) { this.cpf = rg_cpf[0]; this.rg = rg_cpf[1]; }

  // [0] = dia | [1] = mes | [2] = ano
  void set nascimentoSetter(List<String> diaMesAno) {this.anoNascimento = diaMesAno[2]; this.diaNascimento = diaMesAno[0]; this.mesNascimento = diaMesAno[1]; }
  
  // [0] = cep | [1] = numero | [2] = bairro | [3] = rua | [4] = complemento
  void set addressSetter(List<String> address){ this.cep = address[0]; this.numero_casa = address[1]; this.bairro = address[2]; this.rua = address[3]; this.complemento = address[4]}
  
  // set telefone Number
  void set telefoneSetter(String telefone) { this.telefone = telefone; }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  
  void updateUserDados({anoNascimento, diaNascimento, mesNascimento, cpf, rg, cep, numero_casa, complemento})
  {
    this.anoNascimento = anoNascimento;
    this.diaNascimento = diaNascimento;
    this.mesNascimento = mesNascimento;
    this.cpf = cpf;
    this.rg = rg;
    this.cep = cep;
    
    this.numero_casa = numero_casa;
    
    this.complemento = complemento;

    notifyListeners();
    
    
  }
  

}