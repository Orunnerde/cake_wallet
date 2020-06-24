import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/seed_language/seed_language_store.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/widgets/alert_background.dart';
import 'package:cake_wallet/src/widgets/alert_close_button.dart';

List<Image> flagImages = [
  Image.asset('assets/images/usa.png'),
  Image.asset('assets/images/china.png'),
  Image.asset('assets/images/holland.png'),
  Image.asset('assets/images/germany.png'),
  Image.asset('assets/images/japan.png'),
  Image.asset('assets/images/portugal.png'),
  Image.asset('assets/images/russia.png'),
  Image.asset('assets/images/spain.png'),
];

List<String> languageCodes = [
  'Eng',
  'Chi',
  'Ned',
  'Ger',
  'Jap',
  'Por',
  'Rus',
  'Esp',
];

class SeedLanguagePicker extends StatefulWidget {
  @override
  SeedLanguagePickerState createState() => SeedLanguagePickerState();
}

class SeedLanguagePickerState extends State<SeedLanguagePicker> {
  final closeButton = Image.asset('assets/images/close.png');

  @override
  Widget build(BuildContext context) {
    final seedLanguageStore = Provider.of<SeedLanguageStore>(context);

    return AlertBackground(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  S.of(context).seed_choose,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  child: Container(
                    height: 300,
                    width: 300,
                    color: Theme.of(context).dividerColor,
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      children: List.generate(9, (index) {

                        if (index == 8) {

                          return gridTile(
                              isCurrent: false,
                              image: null,
                              text: '',
                              onTap: null);

                        }

                        final code = languageCodes[index];
                        final flag = flagImages[index];
                        final isCurrent = index == seedLanguages.indexOf(seedLanguageStore.selectedSeedLanguage);

                        return gridTile(
                            isCurrent: isCurrent,
                            image: flag,
                            text: code,
                            onTap: () {
                              seedLanguageStore.setSelectedSeedLanguage(seedLanguages[index]);
                              Navigator.of(context).pop();
                            }
                        );
                      }),
                    ),
                  ),
                ),
              )
            ],
          ),
          AlertCloseButton(image: closeButton)
        ],
      )
    );
  }

  Widget gridTile({
    @required bool isCurrent,
    @required Image image,
    @required String text,
    @required VoidCallback onTap}) {

    final color = isCurrent
        ? Theme.of(context).accentTextTheme.subtitle.decorationColor
        : Theme.of(context).primaryTextTheme.display1.color;
    final textColor = isCurrent
        ? Colors.blue
        : Theme.of(context).primaryTextTheme.title.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        color: color,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              image != null
              ? image
              : Offstage(),
              Padding(
                padding: image != null
                  ? EdgeInsets.only(left: 10)
                  : EdgeInsets.only(left: 0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: textColor
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}