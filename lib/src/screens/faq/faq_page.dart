import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/palette.dart';
import 'dart:convert';
import 'package:cake_wallet/generated/i18n.dart';

class FaqPage extends BasePage {
  String get title => S.current.faq;

  @override
  Widget body(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return FutureBuilder(
      builder: (context, snapshot) {
        var faqItems = json.decode(snapshot.data.toString());

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final itemTitle = faqItems[index]["question"];
            final itemChild = faqItems[index]["answer"];

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
          itemCount: faqItems == null ? 0 : faqItems.length,
        );
      },
      future: rootBundle.loadString('assets/faq/faq.json'),
    );
  }

}