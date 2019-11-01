import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/faq/faq_items.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/palette.dart';

class FaqPage extends BasePage {
  String get title => 'FAQ';

  @override
  Widget body(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        final itemTitle = FaqItems.map.keys.elementAt(index);
        final itemChild = FaqItems.map.values.elementAt(index);

        return ExpansionTile(
          title: Text(
            itemTitle
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0
                    ),
                    child: Text(
                      itemChild,
                    ),
                  )
                )
              ],
            )
          ],
        );
      },
      separatorBuilder: (_, __) => Divider(
        color: _isDarkTheme
            ? PaletteDark.darkThemeGreyWithOpacity
            : Palette.lightGrey,
        height: 1.0,
      ),
      itemCount: FaqItems.map.length == null ? 0 : FaqItems.map.length,
    );
  }

}