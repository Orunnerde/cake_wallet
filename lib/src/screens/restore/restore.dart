import 'package:flutter/material.dart';

class Restore extends StatelessWidget{

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
          padding: EdgeInsets.all(20.0),
        )
    );

  }

}