import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';

class Receive extends StatefulWidget{

  final Map<String, String> walletMap;

  const Receive(this.walletMap);

  @override
  _ReceiveState createState() => _ReceiveState();

}

class _ReceiveState extends State<Receive>{
  final _key = new GlobalKey<ScaffoldState>();
  int _currentWalletIndex = 0;
  String _address = 'Address';
  String _qrText = '';

  @override
  void initState() {
    super.initState();
    _qrText = 'monero:'+_address;
  }

  void _setCheckedWallet(int index){
    _currentWalletIndex = index;
    setState(() {
    });
  }

  void _validateAmount(String amount){
    String p = '^[0-9]{1,256}([.][0-9]{0,256})?\$';
    RegExp regExp = new RegExp(p);
    _qrText = 'monero:'+_address;
    if (regExp.hasMatch(amount)){
      _qrText += '?tx_amount='+amount;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){},
            color: Palette.lightGrey2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Icon(Icons.close, color: Colors.black, size: 16.0,)
          ),
        ),
        middle: Text('Receive'),
        trailing: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
              onPressed: (){},
              color: Colors.white,
              child: Icon(CupertinoIcons.share, color: Palette.lightBlue, size: 24.0,)
          ),
        ),
        border: null,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(35.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: QrImage(
                          data: _qrText,
                          backgroundColor: Colors.white,
                        ),
                      )
                    ),
                    Spacer(
                      flex: 1,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Clipboard.setData(new ClipboardData(text: _address));
                              _key.currentState.showSnackBar(
                                 SnackBar(
                                   content: Text('Copied to Clipboard',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(color: Colors.black),
                                   ),
                                   backgroundColor: Palette.purple,
                                 )
                              );
                            },
                            child: Text(_address),
                          ),
                        ),
                      )
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Palette.lightBlue),
                          hintText: 'Amount',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.lightGrey,
                              width: 2.0
                            )
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Palette.lightGrey,
                              width: 2.0
                            )
                          )
                        ),
                        onSubmitted: (value){
                          _validateAmount(value);
                        },
                      )
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Subaddresses'),
                        trailing: Container(
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                            color: Palette.purple,
                            shape: BoxShape.circle
                          ),
                          child: InkWell(
                            onTap: (){},
                            borderRadius: BorderRadius.all(Radius.circular(14.0)),
                            child: Icon(Icons.add, color: Palette.violet, size: 20.0,),
                          ),
                        ),
                      ),
                      Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      )
                    ],
                  ),
                )
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.walletMap.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  color: (_currentWalletIndex == index) ? Palette.purple : Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          (widget.walletMap.keys.elementAt(index) == null) ?
                           widget.walletMap.values.elementAt(index) : widget.walletMap.keys.elementAt(index),
                        ),
                        onTap: (){
                          _setCheckedWallet(index);
                        },
                      ),
                      Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      )
                    ],
                  ),
                );
              }
            )
          )
        ],
      ),
    );
  }
}