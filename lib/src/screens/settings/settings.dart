import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';

const List<String> balanceList = const <String>[
  'Full Balance',
  'Available Balance',
  'Hidden'
];

const List<String> currencyList = const <String>[
  'USD',
  'EUR',
  'GBP'
];

const List<String> feePriorityList = const <String>[
  'Slow',
  'Regular',
  'Fast',
  'Fastest'
];

class Settings extends StatefulWidget{

  final String currentNode;
  
  const Settings(this.currentNode);

  @override
  createState() => SettingsState();

}

class SettingsState extends State<Settings>{

  final _cakeArrowImage = Image.asset('assets/images/cake_arrow.png');
  final _telegramImage = Image.asset('assets/images/Telegram.png');
  final _twitterImage = Image.asset('assets/images/Twitter.png');
  final _changeNowImage = Image.asset('assets/images/change_now.png');
  final _morphImage = Image.asset('assets/images/morph_icon.png');
  final _xmrBtcImage = Image.asset('assets/images/xmr_btc.png');

  String _balance = balanceList[0];
  String _currency = currencyList[0];
  String _feePriority = feePriorityList[0];
  bool _isSaveRecipientAddressOn = true;
  bool _isAllowBiometricalAuthenticationOn = false;
  bool _isAutoBackupToCloudOn = true;

  Future <String> _walletPicker(BuildContext context, List<String> list) async {

    String _value = list[0];

    return await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Please select:'),
          content: Container(
            height: 150.0,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 45.0,
              onSelectedItemChanged: (int index) {
                _value = list[index];
              },
              children: List.generate(
                list.length,
                (int index){
                  return Center(
                    child: Text(list[index]),
                  );
                }
              )
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Cancel')
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context, _value);
              },
                child: Text('OK')
            )
          ],
        );
      }
    );
  }

  void _setBalance(BuildContext context){
    
    _walletPicker(context, balanceList).then((value){
      if (value != null){
        setState(() {
          _balance = value;
        });
      }
    });

  }

  void _setCurrency(BuildContext context){

    _walletPicker(context, currencyList).then((value){
      if (value != null){
        setState(() {
          _currency = value;
        });
      }
    });

  }

  void _setFeePriority(BuildContext context){

    _walletPicker(context, feePriorityList).then((value){
      if (value != null){
        setState(() {
          _feePriority = value;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Palette.lightGrey2,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: Offstage(),
        middle: Text('Settings',
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Palette.lightGrey2,
        border: null,
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: 20.0
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Nodes',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0
                  ),
                  title: Text('Current node',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: Text(widget.currentNode,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Palette.wildDarkBlue
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Wallets',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Display balance as',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Text(_balance,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.wildDarkBlue
                        ),
                      ),
                      onTap: (){
                        _setBalance(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Currency',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Text(_currency,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.wildDarkBlue
                        ),
                      ),
                      onTap: (){
                        _setCurrency(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Fee priority',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Text(_feePriority,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.wildDarkBlue
                        ),
                      ),
                      onTap: (){
                        _setFeePriority(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Save recipient address',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: GestureDetector(
                        onTap: (){ setState(() {
                          _isSaveRecipientAddressOn = !_isSaveRecipientAddressOn;
                        }); },
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(
                            left: 4.0,
                            right: 4.0
                          ),
                          alignment: _isSaveRecipientAddressOn ? Alignment.centerRight : Alignment.centerLeft,
                          duration: Duration(milliseconds: 250),
                          width: 55.0,
                          height: 33.0,
                          decoration: BoxDecoration(
                            color: Palette.switchBackground,
                            border: Border.all(color: Palette.switchBorder),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Container(
                            width: 25.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: _isSaveRecipientAddressOn ? Palette.cakeGreen : Palette.wildDarkBlue,
                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                            child: Icon(_isSaveRecipientAddressOn ? Icons.check : Icons.close, color: Colors.white, size: 16.0,),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Personal',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Change PIN',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Change language',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Allow biometrical authentication',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: GestureDetector(
                        onTap: (){ setState(() {
                          _isAllowBiometricalAuthenticationOn = !_isAllowBiometricalAuthenticationOn;
                        }); },
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(
                            left: 4.0,
                            right: 4.0
                          ),
                          alignment: _isAllowBiometricalAuthenticationOn ? Alignment.centerRight : Alignment.centerLeft,
                          duration: Duration(milliseconds: 250),
                          width: 55.0,
                          height: 33.0,
                          decoration: BoxDecoration(
                            color: Palette.switchBackground,
                            border: Border.all(color: Palette.switchBorder),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Container(
                            width: 25.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: _isAllowBiometricalAuthenticationOn ? Palette.cakeGreen : Palette.wildDarkBlue,
                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                            child: Icon(_isAllowBiometricalAuthenticationOn ? Icons.check : Icons.close, color: Colors.white, size: 16.0,),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Backup',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Show backup password',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Change backup password',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Auto backup to Cloud',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: GestureDetector(
                        onTap: (){ setState(() {
                          _isAutoBackupToCloudOn = !_isAutoBackupToCloudOn;
                        }); },
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(
                            left: 4.0,
                            right: 4.0
                          ),
                          alignment: _isAutoBackupToCloudOn ? Alignment.centerRight : Alignment.centerLeft,
                          duration: Duration(milliseconds: 250),
                          width: 55.0,
                          height: 33.0,
                          decoration: BoxDecoration(
                            color: Palette.switchBackground,
                            border: Border.all(color: Palette.switchBorder),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Container(
                            width: 25.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: _isAutoBackupToCloudOn ? Palette.cakeGreen : Palette.wildDarkBlue,
                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                            ),
                            child: Icon(_isAutoBackupToCloudOn ? Icons.check : Icons.close, color: Colors.white, size: 16.0,),
                          ),
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Backup now to Cloud',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Manual backup',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0
                  ),
                  title: Text('Save backup file to other location',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: _cakeArrowImage,
                  onTap: (){},
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Support',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Palette.wildDarkBlue
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Email',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      trailing: Text('support@cakewallet.io',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      leading: _telegramImage,
                      title: Text('Telegram',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('support@cakewallet.io',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      leading: _twitterImage,
                      title: Text('Twitter',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('support@cakewallet.io',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      leading: _changeNowImage,
                      title: Text('ChangeNow',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('support@changenow.io',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      leading: _morphImage,
                      title: Text('Morph',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('contact@morphtoken.com',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      leading: _xmrBtcImage,
                      title: Text('Xmr->BTC',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text('support@xmr.to',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Palette.cakeGreen
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0
                      ),
                      title: Text('Terms and conditions',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: (){},
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

}