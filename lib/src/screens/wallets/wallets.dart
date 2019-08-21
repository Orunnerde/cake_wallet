import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/palette.dart';

class Wallets extends StatefulWidget{

  @override
  createState() => _WalletsState();

}

class _WalletsState extends State<Wallets>{
  List<String> _list = ['Test we', 'Wallet', 'Main'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        middle: Text('Main'),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(_list[index]),
                          onTap: (){},
                        ),
                        (index < (_list.length - 1)) ?
                        Divider(
                          color: Palette.lightBlue,
                          height: 1.0,
                        ) : Offstage()
                      ],
                    ),
                  );
                }
              )
            ),
            PrimaryIconButton(
              onPressed: (){},
              widget: RoundAdd(),
              text: 'Create New Wallet'
            ),
            SizedBox(
              height: 10.0,
            ),
            PrimaryIconButton(
              onPressed: (){},
              widget: RoundRefresh(),
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

class RoundAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.0,
      height: 26.0,
      margin: EdgeInsets.only(
        left: 5.0,
        right: 10.0
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.deepPink
      ),
      child: Icon(Icons.add, color: Colors.deepPurpleAccent, size: 20.0,),
    );
  }
}

class RoundRefresh extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.0,
      height: 26.0,
      margin: EdgeInsets.only(
          left: 5.0,
          right: 10.0
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Palette.deepIndigo
      ),
      child: Icon(Icons.refresh, color: Colors.black, size: 20.0,),
    );
  }
}