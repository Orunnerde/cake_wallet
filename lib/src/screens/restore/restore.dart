import 'package:flutter/material.dart';
import 'package:cake_wallet/src/widgets/secondary_button.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';

class Restore extends StatelessWidget{

  static const _aspectRatioImage = 2.086;

  final _imageSeedKeys = Image.asset('assets/images/seedKeys.png');
  final _imageRestoreSeed = Image.asset('assets/images/restoreSeed.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
              Navigator.pop(context);
            }),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Restore', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 20.0
          ),
          child: Column(
            children: <Widget>[
              SecondaryButton(
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
              SecondaryButton(
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