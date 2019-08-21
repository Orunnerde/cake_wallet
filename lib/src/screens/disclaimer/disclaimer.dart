import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:url_launcher/url_launcher.dart';

class Disclaimer extends StatefulWidget{
  @override
  createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer>{
  static const url1 = 'https://xmr.to/app_static/html/tos.html';
  static const url2 = 'https://www.morphtoken.com/terms/';

  bool _checked = false;
  String _fileText = '';

  Future getFileLines() async {
    _fileText = await rootBundle.loadString('assets/text/Terms_of_Use.txt');
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getFileLines();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Expanded(
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 25.0,
                        right: 25.0
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Terms and conditions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Legal Disclaimer\nAnd\nTerms of Use',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(_fileText, style: TextStyle(fontSize: 12.0),)
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text('Other Terms and Conditions',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                                  onTap: () => launch(url1),
                                  child: Text(url1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                                  onTap: () => launch(url2),
                                  child: Text(url2,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 12.0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white,
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    top: 10.0,
                    right: 25.0,
                    bottom: 10.0
                  ),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _checked = !_checked;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25.0,
                          width: 25.0,
                          margin: EdgeInsets.only(
                            right: 10.0,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Palette.lightGrey, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              color: Colors.white
                          ),
                          child: _checked ? Icon(Icons.check, color: Colors.blue, size: 20.0,): null,
                        ),
                        Text('I agree to Terms of Use',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: 25.0
            ),
            child: PrimaryButton(
              onPressed: _checked ? (){} : null,
              text: 'Accept'
            ),
          ),
        ],
      ),
    );

  }

}