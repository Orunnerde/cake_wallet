import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class Picker<Item extends Object> extends StatelessWidget {
  final int selectedAtIndex;
  final List<Item> items;
  final String title;
  final Function(Item) onItemSelected;

  Picker(
      {@required this.selectedAtIndex,
      @required this.items,
      @required this.title,
      this.onItemSelected});

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.55)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => null,
                  child: Container(
                      width: double.infinity,
                      height: 300,
                      color: Theme.of(context).backgroundColor,
                      child: ListView.separated(
                        itemCount: items.length + 1,
                        separatorBuilder: (_, index) => index == 0
                            ? SizedBox()
                            : Divider(
                                height: 1,
                                color: Color.fromRGBO(235, 238, 242, 1)),
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return Container(
                              height: 100,
                              width: double.infinity,
                              color: Theme.of(context).backgroundColor,
                              child: Center(
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      color: _isDarkTheme ? Colors.white : Colors.black
                                  ),
                                ),
                              ),
                            );
                          }

                          index -= 1;
                          final item = items[index];

                          return Padding(
                            padding: EdgeInsets.only(top: 18, bottom: 18),
                            child: Center(
                              child: GestureDetector(
                                  onTap: () {
                                    if (onItemSelected == null) { return; }
                                    Navigator.of(context).pop();
                                    onItemSelected(item);
                                  },
                                  child: Text(
                                    item.toString(),
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: index == selectedAtIndex
                                            ? Color.fromRGBO(138, 80, 255, 1)
                                            : _isDarkTheme ? Colors.white : Colors.black
                                    ),
                                  )),
                            ),
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
