import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

// aqui é simplesmente a pagina que vai abrir quando o cliente clicar para abrir a pagina para ele poder
// ler os termos de licença/contrato da compainha.

class WebViewContainer extends StatefulWidget
{
  final String url;

  WebViewContainer(@required this.url);

  @override
  State<StatefulWidget> createState() {
    return _WebViewContainerState(this.url);
  }
}

class _WebViewContainerState extends State<WebViewContainer>
{
  final String _url;
  final _key = UniqueKey();
  _WebViewContainerState(@required this._url);
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("WebViewTest", style: TextStyle(color: Colors.black)),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.black),
            onTap:(){
                Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
              Expanded(
                child: WebView(
                  key: _key,
                  initialUrl: _url,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
          ],
        ),
      ), 
    );
  } 
}