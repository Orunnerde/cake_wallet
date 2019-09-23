import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/address_book/contact.dart';
import 'package:cake_wallet/src/screens/address_book/contact_data.dart';

class AddressBookList extends StatefulWidget{

  final Map<String,String> contactsList; // key: contact name, value: currency type

  AddressBookList(this.contactsList);

  @override
  createState() => AddressBookListState(contactsList);

}

class AddressBookListState extends State<AddressBookList>{

  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  Map<String,String> _contactsList;

  AddressBookListState(this._contactsList);

  Color getCurrencyBackgroundColor(String currency){
    Color color;
    switch(currency){
      case 'XMR':
        color = Palette.cakeGreenWithOpacity;
        break;
      case 'BTC':
        color = Colors.orange;
        break;
      case 'ETH':
        color = Colors.black;
        break;
      case 'LTC':
        color = Colors.blue[200];
        break;
      case 'BCH':
        color = Colors.orangeAccent;
        break;
      case 'DASH':
        color = Colors.blue;
        break;
      default:
        color = Colors.white;
    }
    return color;
  }

  Color getCurrencyTextColor(String currency){
    Color color;
    switch(currency){
      case 'XMR':
        color = Palette.cakeGreen;
        break;
      case 'LTC':
        color = Palette.lightBlue;
        break;
      default:
        color = Colors.white;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){ Navigator.pop(context); },
            child: backArrowImage
          ),
        ),
        middle: Text('Address Book', style: TextStyle(fontSize: 16.0),),
        trailing: Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.purple
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Palette.violet, size: 20.0),
                ButtonTheme(
                  minWidth: 28.0,
                  height: 28.0,
                  child: FlatButton(
                    shape: CircleBorder(),
                    onPressed: () async {
                      ContactData data = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Contact()));
                      if (data != null){
                        setState(() {
                          if (_contactsList == null) _contactsList = new Map();
                          _contactsList[data.contactName] = data.currencyType;
                        });
                      }
                    },
                    child: Offstage()
                  ),
                )
              ],
            )
        ),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
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
                    padding: EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0
                    ),
                    child: ListView.builder(
                        itemCount: _contactsList == null? 0 : _contactsList.length,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    height: 25.0,
                                    width: 48.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: getCurrencyBackgroundColor(_contactsList.values.elementAt(index)),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(_contactsList.values.elementAt(index),
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: getCurrencyTextColor(_contactsList.values.elementAt(index)),
                                      ),
                                    ),
                                  ),
                                  title: Text(_contactsList.keys.elementAt(index),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Palette.lightGrey,
                                  height: 3.0,
                                )
                              ],
                            ),
                          );
                        }
                    )
                  )
                ],
              )
            )
          ],
        )
      ),
    );
  }

}