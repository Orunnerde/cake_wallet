import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';

class ShowKeys extends StatefulWidget {

  final String viewKeyPublic;
  final String viewKeyPrivate;
  final String spendKeyPublic;
  final String spendKeyPrivate;

  const ShowKeys(this.viewKeyPublic, this.viewKeyPrivate, this.spendKeyPublic, this.spendKeyPrivate);

  @override
  createState() => ShowKeysState(viewKeyPublic, viewKeyPrivate, spendKeyPublic, spendKeyPrivate);

}

class ShowKeysState extends State<ShowKeys>{

  final _closeButtonImage = Image.asset('assets/images/close_button.png');

  String _viewKeyPublic;
  String _viewKeyPrivate;
  String _spendKeyPublic;
  String _spendKeyPrivate;

  Map<String,String> _keysMap = new Map();

  ShowKeysState(this._viewKeyPublic, this._viewKeyPrivate, this._spendKeyPublic, this._spendKeyPrivate);

  @override
  void initState() {
    super.initState();

    _keysMap['View key (public):'] = _viewKeyPublic;
    _keysMap['View key (private):'] = _viewKeyPrivate;
    _keysMap['Spend key (public):'] = _spendKeyPublic;
    _keysMap['Spend key (private):'] = _spendKeyPrivate;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: _closeButtonImage
          ),
        ),
        middle: Text('Wallet keys', style: TextStyle(fontSize: 16.0),),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0
          ),
          child: ListView.builder(
            itemCount: _keysMap.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(_keysMap.keys.elementAt(index),
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Container(
                      padding: EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Text(_keysMap.values.elementAt(index),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.wildDarkBlue
                        ),
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 20.0
                    ),
                    child: Divider(
                      color: Palette.lightGrey,
                    ),
                  ),
                ],
              );
            }
          )
        )
      ),
    );

  }
}