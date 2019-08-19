import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class RestoreButton extends StatelessWidget{

  final VoidCallback onPressed;
  final Image image;
  final double aspectRatioImage;
  final Color color;
  final String title;
  final String description;
  final String textButton;

  const RestoreButton({
    @required this.onPressed,
    @required this.image,
    @required this.aspectRatioImage,
    this.color = Palette.darkPurple,
    this.title = '',
    this.description = '',
    this.textButton = ''
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
        bottom: 20.0
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.lightGrey),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                child: AspectRatio(
                  aspectRatio: aspectRatioImage,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: image,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Palette.lightBlue,
                      fontSize: 16.0
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 56.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)
                )
              ),
              child: Center(
                child: Text(
                  textButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                  ),
                ),
              )
            )
          ],
        )
      ),
    );

  }

}