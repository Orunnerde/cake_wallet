import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';

class CurrencyPicker extends StatelessWidget {
  CurrencyPicker({
    @required this.selectedAtIndex,
    @required this.items,
    @required this.title,
    @required this.onItemSelected,
  });

  final int selectedAtIndex;
  final List<CryptoCurrency> items;
  final String title;
  final Function(CryptoCurrency) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(color: PaletteDark.darkNightBlue.withOpacity(0.75)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: GestureDetector(
                      onTap: () => null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          height: 400,
                          width: 300,
                          color: Theme.of(context).dividerColor,
                          child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              childAspectRatio: 1.25,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              children: List.generate(15, (index) {

                                if (index == 14) {
                                  return Container(
                                    color: Theme.of(context).primaryTextTheme.display1.color,
                                  );
                                }

                                final item = items[index];
                                final isItemSelected = index == selectedAtIndex;

                                final color = isItemSelected
                                    ? Theme.of(context).accentTextTheme.subtitle.decorationColor
                                    : Theme.of(context).primaryTextTheme.display1.color;
                                final textColor = isItemSelected
                                    ? Colors.blue
                                    : Theme.of(context).primaryTextTheme.title.color;

                                return GestureDetector(
                                  onTap: () {
                                    if (onItemSelected == null) {
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                    onItemSelected(item);
                                  },
                                  child: Container(
                                    color: color,
                                    child: Center(
                                      child: Text(
                                        item.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            color: textColor
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}