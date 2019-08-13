import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/restore/widgets/reset_button.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:flutter/cupertino.dart';

class Restore extends StatelessWidget{

  static const _aspectRatioImage = 2.086;

  final _imageSeedKeys = Image.asset('assets/images/seedKeys.png');
  final _imageRestoreSeed = Image.asset('assets/images/restoreSeed.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          middle: Text('Restore'),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 20.0
          ),
          child: Column(
            children: <Widget>[
              ResetButton(
                _imageSeedKeys, _aspectRatioImage,
                onPressed: (){
                  Navigator.pushNamed(context, restoreSeedKeysRoute);
                },
                title: 'Restore from seed/keys',
                description: 'Restore your wallet from your seed or keys',
                textButton: 'Next',
              ),
              SizedBox(
                height: 20.0,
              ),
              ResetButton(
                _imageRestoreSeed, _aspectRatioImage,
                onPressed: (){},
                color: Palette.lightGreen,
                title: 'Restore from a back-up file',
                description: 'Restore the whole Cake Wallet app from\nyour back-up file',
                textButton: 'Next',
              )
            ],
          ),
        )
    );

  }

}