import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var welcomeImg = new AssetImage('lib/src/screens/welcome/images/welcomeImg.png');
    var image = new Image(image: welcomeImg, fit: BoxFit.contain);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Center(
              child: image,
            ),
            Text('WELCOME\n TO CAKE WALLET',
              style: TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('Awesome wallet\nfor Monero',
              style: TextStyle(fontSize: 30.0, color: Colors.indigoAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 25.0,
            ),
            Text('Please make a selection below to either create a new wallet or restore a wallet',
              style: TextStyle(fontSize: 18.5, color: Colors.indigoAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 25.0,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              buttonColor: Colors.deepPurpleAccent,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text('Create new',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              buttonColor: Colors.cyan,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text('Restore',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),
              ),
            )
          ],
        )
      )
    );
  }
}