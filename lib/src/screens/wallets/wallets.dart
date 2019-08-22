import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/palette.dart';

class Wallets extends StatefulWidget{

  @override
  createState() => _WalletsState();

}

class _WalletsState extends State<Wallets>{
  List<String> _listWallets = ['Test we', 'Wallet', 'Main', '', 'Vchcjcucu'];
  int _currentWalletIndex = 2;
  String _appBarTitle;

  @override
  void initState() {
    super.initState();
    _appBarTitle = _listWallets[_currentWalletIndex];
  }

  void _setCheckedWallet(int index){

    _currentWalletIndex = index;
    _appBarTitle = _listWallets[_currentWalletIndex];

    setState(() {
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: FlatButton(
          onPressed: (){},
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.close, size: 20.0,),
              ],
            ),
          )
        ),
        middle: Text(_appBarTitle),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _listWallets.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(_listWallets[index],
                            style: TextStyle(
                              color: (_currentWalletIndex == index) ? Colors.blue : Colors.black
                            ),
                          ),
                          trailing: (_currentWalletIndex == index) ? Icon(Icons.check, color: Colors.blue, size: 20.0,) : null,
                          onTap: (){
                            _setCheckedWallet(index);
                          },
                        ),
                        (index < (_listWallets.length - 1)) ?
                        Divider(
                          color: Palette.lightGrey,
                          height: 3.0,
                        ) : Offstage()
                      ],
                    ),
                  );
                }
              )
            ),
            SizedBox(
              height: 10.0,
            ),
            PrimaryIconButton(
              onPressed: (){},
              iconData: Icons.add,
              iconColor: Colors.deepPurpleAccent,
              text: 'Create New Wallet'
            ),
            SizedBox(
              height: 10.0,
            ),
            PrimaryIconButton(
              onPressed: (){},
              iconData: Icons.refresh,
              text: 'Restore Wallet',
              color: Palette.indigo,
              borderColor: Palette.deepIndigo,
            ),
          ],
        ),
      ),
    );
  }

}