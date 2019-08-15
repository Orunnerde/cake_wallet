import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class RestoreFromSeed extends StatefulWidget{

  @override
  createState() => _RestoreFromSeedState();
  
}

class _RestoreFromSeedState extends State<RestoreFromSeed>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        middle: Text('Restore from seed'),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.lightBlue),
                              hintText: 'Wallet name',
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
                          validator: (value){
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.lightBlue),
                              hintText: 'Restore from blockheight',
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
                          validator: (value){
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
              ),
              Text(
                'or',
                style: TextStyle(fontSize: 16.0),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.lightBlue),
                              hintText: 'Restore from date',
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
                          validator: (value){
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.lightBlue),
                              hintText: 'Seed',
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
                          validator: (value){
                            return null;
                          },
                        ),
                      ],
                    ),
                  )
              ),
              Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: PrimaryButton(
                        onPressed: (){},
                        text: 'Recover'
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }

}