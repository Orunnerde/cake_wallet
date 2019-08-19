import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class Seed extends StatefulWidget {

  @override
  createState() => _SeedState();

}

class _SeedState extends State<Seed>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
          middle: Text('Seed', style: TextStyle(fontWeight: FontWeight.normal),),
          backgroundColor: Colors.white,
          border: null,
          trailing: InkWell(
            onTap: (){},
            child: Text('Done',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
          )
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 30.0,
                        top: 30.0,
                        right: 30.0,
                        bottom: 30.0
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 20.0
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.lightGrey,
                                                width: 1.0
                                            )
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.lightGrey,
                                                width: 1.0
                                            )
                                        )
                                    ),
                                    initialValue: 'MyAwesomeWallet',
                                    textAlign: TextAlign.center,
                                    validator: (value){
                                      if (value.isEmpty) return 'Please write a seed';
                                      return null;
                                    },
                                  ),
                                )
                            )
                          ],
                        ),
                        Text(
                          'umbrella hire boat adopt sieve money business '
                          'royal zones repent inflamed eavesdrop cube '
                          'umpire javelin pulp dash bikini major aloof '
                          'hippo shocking lopped merger money',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 30.0,
                      bottom: 30.0
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Please share, copy, or write down your seed. The seed '
                          'is used to recover your wallet. This is your PRIVATE '
                          'seed. DO NOT SHARE this seed with other people!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Palette.lightBlue,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 20.0
                          ),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    right: 15.0
                                  ),
                                  child: PrimaryButton(
                                    onPressed: (){},
                                    color: Palette.indigo,
                                    borderColor: Palette.deepIndigo,
                                    text: 'Save'
                                  ),
                                )
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 15.0
                                  ),
                                  child: PrimaryButton(
                                    onPressed: (){},
                                    text: 'Copy'
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      )
    );
  }

}