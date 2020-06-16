import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class Picker<Item extends Object> extends StatelessWidget {
  Picker({
    @required this.selectedAtIndex,
    @required this.items,
    this.images,
    @required this.title,
    @required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.start
  });

  final int selectedAtIndex;
  final List<Item> items;
  final List<Image> images;
  final String title;
  final Function(Item) onItemSelected;
  final MainAxisAlignment mainAxisAlignment;

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
                      padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: GestureDetector(
                        onTap: () => null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          child: Container(
                              height: 233,
                              color: Theme.of(context).accentTextTheme.title.backgroundColor,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: Theme.of(context).dividerColor,
                                  height: 1,
                                ),
                                itemCount: items == null ? 0 : items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final image = images != null? images[index] : null;
                                  final isItemSelected = index == selectedAtIndex;

                                  final color = isItemSelected
                                      ? Theme.of(context).accentTextTheme.subtitle.decorationColor
                                      : Colors.transparent;
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
                                      height: 77,
                                      padding: EdgeInsets.only(left: 24, right: 24),
                                      color: color,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: mainAxisAlignment,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          image != null
                                          ? image
                                          : Offstage(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: image != null ? 12 : 0
                                            ),
                                            child: Text(
                                              item.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
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
