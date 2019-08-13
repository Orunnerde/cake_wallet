import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class ResetButton extends StatefulWidget{

  @required VoidCallback _onPressed;
  Image _image;
  double _aspectRatioImage;
  Color _color;
  String _title;
  String _description;
  String _textButton;

  ResetButton(this._image, this._aspectRatioImage,
  {@required VoidCallback onPressed,
  Color color = Palette.darkPurple, String title = '',
  String description = '', String textButton = ''}){
    _onPressed = onPressed;
    _color = color;
    _title = title;
    _description = description;
    _textButton = textButton;
  }

  @override
  createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton>{
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
          onTap: widget._onPressed,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Palette.lightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: AspectRatio(
                                aspectRatio: widget._aspectRatioImage,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: widget._image,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(widget._title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: widget._color,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(widget._description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Palette.lightBlue,
                                    fontSize: 16.0
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  ),
                  SizedBox(
                      height: 20.0
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              height: 56.0,
                              decoration: BoxDecoration(
                                  color: widget._color,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)
                                  )
                              ),
                              child: Center(
                                child: Text(widget._textButton,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0
                                  ),
                                ),
                              )
                          )
                      )
                    ],
                  )
                ],
              )
          ),
        )
    );
  }
}