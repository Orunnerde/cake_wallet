import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

const Map<String,String> _languages = {
  'en' : 'English',
  'ru' : 'Русский (Russian)',
  'es' : 'Español (Spanish)',
  'ja' : '日本 (Japanese)',
  'ko' : '한국어 (Korean)',
  'hi' : 'हिंदी (Hindi)',
  'de' : 'Deutsch (German)',
  'zh' : '中文 (Chinese)',
  'pt' : 'Português (Portuguese)',
  'pl' : 'Polskie (Polish)',
  'nl' : 'Nederlands (Dutch)'
};

class ChangeLanguage extends BasePage{
  get title => 'Change language';

  @override
  Widget body(BuildContext context) {

    final notCurrentColor = Theme.of(context).accentTextTheme.subhead.backgroundColor;

    return Container(
        padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0
        ),
        child: ListView.builder(
          itemCount: _languages.values.length,
          itemBuilder: (BuildContext context, int index){

            return Container(
              margin: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0
              ),
              color: notCurrentColor,
              child: ListTile(
                title: Text(_languages.values.elementAt(index),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryTextTheme.title.color
                  ),
                ),
                onTap: () {},
              ),
            );
          },
        )
    );
  }
}