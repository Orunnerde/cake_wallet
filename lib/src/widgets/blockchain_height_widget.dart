import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/monero/get_height_by_date.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/generated/i18n.dart';

class BlockchainHeightWidget extends StatefulWidget {
  BlockchainHeightWidget({GlobalKey key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BlockchainHeightState();
}

class BlockchainHeightState extends State<BlockchainHeightWidget> {
  final dateController = TextEditingController();
  final restoreHeightController = TextEditingController();
  int get height => _height;
  int _height = 0;

  @override
  void initState() {
    restoreHeightController
        .addListener(() => _height = restoreHeightController.text != null ? int.parse(restoreHeightController.text) : 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
                child: Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: TextFormField(
                style: TextStyle(fontSize: 14.0),
                controller: restoreHeightController,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: _isDarkTheme ? PaletteDark.darkThemeGrey
                            : Palette.lightBlue),
                    hintText: S.of(context).widgets_restore_from_blockheight,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                : Palette.lightGrey,
                            width: 1.0)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                : Palette.lightGrey,
                            width: 1.0))),
              ),
            ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Text(
            S.of(context).widgets_or,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
                child: Container(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: _isDarkTheme ? PaletteDark.darkThemeGrey
                                : Palette.lightBlue),
                        hintText: S.of(context).widgets_restore_from_date,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0))),
                    controller: dateController,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ),
            ))
          ],
        ),
      ],
    );
  }

  Future _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: now.subtract(Duration(days: 1)),
        firstDate: DateTime(2014, DateTime.april),
        lastDate: now);

    if (date != null) {
      final height = getHeigthByDate(date: date);

      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(date);
        restoreHeightController.text = '$height';
        _height = height;
      });
    }
  }
}
