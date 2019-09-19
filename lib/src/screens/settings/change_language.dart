import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';

const List<String> languagesList = const <String>[
  'English',
  'Русский (Russian)',
  'Español (Spanish)',
  '日本 (Japanese)',
  '한국어 (Korean)',
  'हिंदी (Hindi)',
  'Deutsch (German)',
  '中文 (Chinese)',
  'Português (Portuguese)',
  'Polskie (Polish)',
  'Nederlands (Dutch)'
];

class ChangeLanguage extends StatefulWidget{

  @override
  createState() => ChangeLanguageState();

}

class ChangeLanguageState extends State<ChangeLanguage>{

  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){Navigator.pop(context);},
            child: backArrowImage
          ),
        ),
        middle: Text('Change language',
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0
          ),
          child: ListView.builder(
            itemCount: languagesList.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0
                ),
                color: Palette.lightGrey2,
                child: ListTile(
                  title: Text(languagesList[index],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              );
            }
          ),
        )
      ),
    );
  }

}