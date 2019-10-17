import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class LinkListRow extends StatelessWidget {
  final VoidCallback onTaped;
  final String title;
  final String link;
  final Image image;

  LinkListRow({@required this.onTaped, this.title, this.link, this.image});

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return Container(
      color: _isDarkTheme? PaletteDark.darkThemeMidGrey : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            image != null ? image : Offstage(),
            Container(
              padding: image != null ? EdgeInsets.only(left: 10) : null,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: _isDarkTheme ? PaletteDark.darkThemeTitle
                        : Colors.black
                ),
              ),
            )
          ],
        ),
        trailing: Text(
          link,
          style:
          TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
        ),
        onTap: onTaped,
      ),
    );
  }

}