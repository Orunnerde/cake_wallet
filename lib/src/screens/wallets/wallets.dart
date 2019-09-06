import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/palette.dart';

class Wallets extends StatefulWidget{

  final List<String> listWallets;

  const Wallets(this.listWallets);

  @override
  createState() => _WalletsState();

}

class _WalletsState extends State<Wallets>{

  final _closeButtonImage = Image.asset('assets/images/close_button.png');
  int _currentWalletIndex = 0;

  void _setCheckedWallet(int index){
    _currentWalletIndex = index;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){},
            child: _closeButtonImage
          ),
        ),
        middle: Text('Monero Wallet', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 10.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Palette.lightGrey2,
                          Colors.white
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(0.0, 1.0),
                      )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.listWallets == null ? 0 : widget.listWallets.length,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(widget.listWallets[index],
                                        style: TextStyle(
                                          color: _currentWalletIndex == index ? Palette.cakeGreen : Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      trailing: _currentWalletIndex == index ? Icon(Icons.check, color: Palette.cakeGreen, size: 20.0,) : null,
                                      onTap: (){
                                        _setCheckedWallet(index);
                                      },
                                    ),
                                    (index < (widget.listWallets.length - 1)) ?
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
                          iconColor: Palette.violet,
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
                ],
              )
            )
          ],
        )
      ),
    );
  }

}