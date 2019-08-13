import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/restore/widgets/reset_button.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter/cupertino.dart';

class RestoreSeedKeys extends StatelessWidget{

  static const _aspectRatioImage = 2.086;

  final _imageSeed = Image.asset('assets/images/seedIco.png');
  final _imageKeys = Image.asset('assets/images/keysIco.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                _imageSeed, _aspectRatioImage,
                onPressed: (){},
                title: 'Restore from seed',
                description: 'Restore your wallet from either the 25 word\nor 13 word seed',
                textButton: 'Next',
              ),
              SizedBox(
                height: 20.0,
              ),
              ResetButton(
                _imageKeys, _aspectRatioImage,
                onPressed: (){},
                color: Palette.lightGreen,
                title: 'Restore from keys',
                description: 'Restore your wallet from your private keys',
                textButton: 'Next',
              )
            ],
          ),
        )
    );

  }

}