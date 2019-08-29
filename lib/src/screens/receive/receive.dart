import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';

class Receive extends StatefulWidget{

  final String address;
  final Map<String, String> subaddressMap;

  const Receive(this.address, this.subaddressMap);

  @override
  _ReceiveState createState() => _ReceiveState();

}

class _ReceiveState extends State<Receive>{

  final _closeButtonImage = Image.asset('assets/images/close_button.png');
  final _shareButtonImage = Image.asset('assets/images/share_button.png');
  final _key = new GlobalKey<ScaffoldState>();

  int _currentWalletIndex;
  String _qrText;

  @override
  void initState() {
    super.initState();
    _currentWalletIndex = 0;
    _qrText = 'monero:' + widget.address;
  }

  void _setCheckedSubaddress(int index){
    _currentWalletIndex = index;
    setState(() {
    });
  }

  void _validateAmount(String amount){
    String p = '^[0-9]{1,10}([.][0-9]{0,10})?\$';
    RegExp regExp = new RegExp(p);
    _qrText = 'monero:' + widget.address;
    if (regExp.hasMatch(amount)){
      _qrText += '?tx_amount=' + amount;
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 37.0,
              margin: EdgeInsets.only(
                top: 5.0,
              ),
              padding: EdgeInsets.only(
                left: 18.0,
                right: 18.0
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0.0,
                    child: Container(
                      width: 37.0,
                      height: 37.0,
                      child: InkWell(
                        onTap: (){},
                        child: _closeButtonImage,
                      ),
                    )
                  ),
                  Container(
                    height: 37.0,
                    alignment: Alignment.center,
                    child: Text('Receive', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
                  ),
                  Positioned(
                    right: 10.0,
                    child: Container(
                      width: 37.0,
                      height: 37.0,
                      child: InkWell(
                        onTap: (){},
                        child: _shareButtonImage,
                      ),
                    )
                  )
                ],
              ),
            ),
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
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: GestureDetector(
                                onTap: (){
                                  Clipboard.setData(new ClipboardData(text: widget.address));
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
                                child: Text(widget.address,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                                ),
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
                      color: Palette.lightGrey2,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Subaddresses', style: TextStyle(fontSize: 16.0),),
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
                    itemCount: widget.subaddressMap.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        color: (_currentWalletIndex == index) ? Palette.purple : Palette.lightGrey2,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                (widget.subaddressMap.keys.elementAt(index) == null)||(widget.subaddressMap.keys.elementAt(index) == '') ?
                                widget.subaddressMap.values.elementAt(index) : widget.subaddressMap.keys.elementAt(index),
                                style: TextStyle(fontSize: 16.0),
                              ),
                              onTap: (){
                                _setCheckedSubaddress(index);
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
      )
    );
  }
}