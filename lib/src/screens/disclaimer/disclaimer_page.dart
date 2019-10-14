import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class DisclaimerPage extends StatefulWidget{
  @override
  createState() => DisclaimerState(false);
}

class DisclaimerState extends State<DisclaimerPage>{
  static const url1 = 'https://xmr.to/app_static/html/tos.html';
  static const url2 = 'https://www.morphtoken.com/terms/';

  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  final _backArrowImageDarkTheme = Image.asset('assets/images/back_arrow_dark_theme.png');

  bool _isAccepted;
  bool _checked = false;
  String _fileText = '';

  DisclaimerState(this._isAccepted);

  launchUrl(String url) async{
    await launch(url);
  }

  Future getFileLines() async {
    _fileText = await rootBundle.loadString('assets/text/Terms_of_Use.txt');
    setState(() {
    });
  }

  _showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Terms and conditions',
              textAlign: TextAlign.center,
            ),
            content: Text('By using this app, you agree to the Terms of Agreement set forth to below',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('OK')
              ),
            ],
          );
        }
    );
  }

  _afterLayout(_) {
    _showAlertDialog(context);
  }

  @override
  void initState() {
    super.initState();
    getFileLines();
    if (_isAccepted) WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _isAccepted ? CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
              onPressed: (){Navigator.pop(context);},
              child: _isDarkTheme ? _backArrowImageDarkTheme : _backArrowImage
          ),
        ),
        middle: Text('Terms and conditions',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        border: null,
      ) : null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Expanded(
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: EdgeInsets.only(
                          left: 25.0,
                          right: 25.0
                      ),
                      child: Column(
                        children: <Widget>[
                          !_isAccepted? Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Terms and conditions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ) : Offstage(),
                          !_isAccepted? SizedBox(
                            height: 20.0,
                          ) : Offstage(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Legal Disclaimer\nAnd\nTerms of Use',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(_fileText, style: TextStyle(fontSize: 12.0),)
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Other Terms and Conditions',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: GestureDetector(
                                    onTap: () => launchUrl(url1),
                                    child: Text(url1,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: GestureDetector(
                                    onTap: () => launchUrl(url2),
                                    child: Text(url2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 12.0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _isDarkTheme ? Theme.of(context).backgroundColor.withOpacity(0.0)
                                        : Colors.white.withOpacity(0.0),
                                    _isDarkTheme ? Theme.of(context).backgroundColor
                                        : Colors.white,
                                  ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
            !_isAccepted? Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 25.0,
                          top: 10.0,
                          right: 25.0,
                          bottom: 10.0
                      ),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _checked = !_checked;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 25.0,
                              width: 25.0,
                              margin: EdgeInsets.only(
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Palette.lightGrey, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  color: Theme.of(context).backgroundColor
                              ),
                              child: _checked ? Icon(Icons.check, color: Colors.blue, size: 20.0,): null,
                            ),
                            Text('I agree to Terms of Use',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                ),
              ],
            ) : Offstage(),
            !_isAccepted? Container(
              padding: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  bottom: 25.0
              ),
              child: PrimaryButton(
                  onPressed: _checked ? (){} : null,
                  text: 'Accept',
                  color: _isDarkTheme ? PaletteDark.darkThemePurpleButton : Palette.purple,
                  borderColor: _isDarkTheme ? PaletteDark.darkThemePurpleButtonBorder : Palette.deepPink,
              ),
            ) : Offstage(),
            _isAccepted ? SizedBox(
              height: 20.0,
            ) : Offstage()
          ],
        ),
      )
    );

  }

}