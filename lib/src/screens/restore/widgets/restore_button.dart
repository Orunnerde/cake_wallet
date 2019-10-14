import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class RestoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Image image;
  final double aspectRatioImage;
  final Color color;
  final Color titleColor;
  final String title;
  final String description;
  final String textButton;

  const RestoreButton(
      {@required this.onPressed,
      @required this.image,
      @required this.aspectRatioImage,
      @required this.color,
      @required this.titleColor,
      this.title = '',
      this.description = '',
      this.textButton = ''});

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
          color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(23, 46, 77, 0.129207),
              blurRadius: 10,
              offset: Offset(
                0,
                12,
              ),
            )
          ]),
      child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: titleColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(
                              color: _isDarkTheme ? Palette.wildDarkBlue : Palette.lightBlue,
                              fontSize: 14.0,
                              height: 1.4),
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
                    border: Border(
                        top: BorderSide(
                            color: _isDarkTheme ? PaletteDark.darkThemeDarkGrey : Palette.darkGrey,
                            width: 1.15)),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      textButton,
                      style: TextStyle(
                          color: color,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          )),
    );
  }
}
