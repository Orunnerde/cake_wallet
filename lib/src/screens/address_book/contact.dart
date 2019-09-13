import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/address_book/contact_data.dart';

const List<String> currency = const <String>[
  'XMR',
  'BTC',
  'ETH',
  'LTC',
  'BCH',
  'DASH'
];

class Contact extends StatefulWidget{

  @override
  createState() => ContactState();

}

class ContactState extends State<Contact>{

  final formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _currencyTypeController = TextEditingController();
  final _addressController = TextEditingController();
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');
  static final qrImage = Image.asset('assets/images/qr_icon.png');
  ContactData _contactData;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _currencyTypeController.text = 'XMR';
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _currencyTypeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  _setCurrencyType(BuildContext context) async {
    String _currencyType;

    _currencyTypeController.text = await showDialog(
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
                _currencyType = currency[index];
              },
              children: List.generate(
                currency.length,
                (int index){
                  return Center(
                    child: Text(currency[index]),
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
                Navigator.pop(context, _currencyType);
              },
              child: Text('OK')
            )
          ],
        );
      }
    );
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
            onPressed: (){ Navigator.pop(context, _isSaved? _contactData : null); },
            child: backArrowImage
          ),
        ),
        middle: Text('Contact', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(38.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Contact Name',
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
                                controller: _contactNameController,
                                validator: (value){
                                  String p = '[^ ]';
                                  RegExp regExp = new RegExp(p);
                                  if (regExp.hasMatch(value)) return null;
                                  else return 'Please enter a contact name';
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: InkWell(
                                  onTap: (){
                                    _setCurrencyType(context);
                                  },
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 14.0),
                                      decoration: InputDecoration(
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
                                      controller: _currencyTypeController,
                                      validator: (value){
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 20.0),
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Address',
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
                                  ),
                                  suffixIcon: Container(
                                    margin: EdgeInsets.all(4.0),
                                    width: 34.0,
                                    height: 34.0,
                                    decoration: BoxDecoration(
                                      color: Palette.wildDarkBlueWithOpacity,
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        qrImage,
                                        FlatButton(
                                          onPressed: (){},
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                          child: Offstage()
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                controller: _addressController,
                                validator: (value){
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                          padding: EdgeInsets.only(right: 8.0),
                          child: PrimaryButton(
                            onPressed: (){
                              setState(() {
                                _contactNameController.text = '';
                                _currencyTypeController.text = 'XMR';
                                _addressController.text = '';
                                _contactData = null;
                                _isSaved = false;
                              });
                            },
                            text: 'Reset',
                            color: Palette.indigo,
                            borderColor: Palette.deepIndigo,
                          ),
                        )
                    ),
                    Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: PrimaryButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()){
                                _isSaved = true;
                                _contactData = new ContactData();
                                _contactData.setContactName(_contactNameController.text);
                                _contactData.setCurrencyType(_currencyTypeController.text);
                                _contactData.setAddress(_addressController.text);
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Saved', textAlign: TextAlign.center,),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK')
                                        )
                                      ],
                                    );
                                  }
                                );
                              }
                            },
                            text: 'Save'
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          )
        )
      ),
    );
  }

}