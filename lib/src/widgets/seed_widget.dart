import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/monero/mnemonics/english.dart';
import 'package:cake_wallet/src/domain/common/mnemotic_item.dart';

class SeedWidget extends StatefulWidget {
  final Function(List<MnemoticItem>) onMnemoticChange;

  SeedWidget({Key key, this.onMnemoticChange}) : super(key: key);

  SeedWidgetState createState() => SeedWidgetState();
}

class SeedWidgetState extends State<SeedWidget> {
  List<MnemoticItem> items = <MnemoticItem>[];
  final _seedController = TextEditingController();
  MnemoticItem selectedItem;
  bool isValid;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    isValid = true;
    _seedController.addListener(() => mnemoticFromText(_seedController.text));
  }

  void addMnemotic(String text) {
    setState(() => items.add(MnemoticItem(
        text: text.trim().toLowerCase(), dic: EnglishMnemonics.words)));
    _seedController.text = '';

    if (widget.onMnemoticChange != null) {
      widget.onMnemoticChange(items);
    }
  }

  void deleteMnemotic(MnemoticItem item) {
    setState(() => items.remove(item));

    if (widget.onMnemoticChange != null) {
      widget.onMnemoticChange(items);
    }
  }

  void mnemoticFromText(String text) {
    final splitted = text.split(' ');

    if (splitted.length >= 2) {
      for (final text in splitted) {
        if (text == ' ' || text.isEmpty) {
          continue;
        }

        if (selectedItem != null) {
          editTextOfSelectedMnemotic(text);
        } else {
          addMnemotic(text);
        }
      }
    }
  }

  void selectMnemotic(MnemoticItem item) {
    setState(() => selectedItem = item);
    _seedController
      ..text = item.text
      ..selection = TextSelection.collapsed(offset: item.text.length);
  }

  void onMnemoticTap(MnemoticItem item) {
    if (selectedItem == item) {
      setState(() => selectedItem = null);
      _seedController.text = '';
      return;
    }

    selectMnemotic(item);
  }

  void editTextOfSelectedMnemotic(String text) {
    setState(() => selectedItem.changeText(text));
    selectedItem = null;
    _seedController.text = '';

    if (widget.onMnemoticChange != null) {
      widget.onMnemoticChange(items);
    }
  }

  void onFieldSubmitted(String text) {
    if (text.isEmpty || text == null) {
      return;
    }

    if (selectedItem != null) {
      editTextOfSelectedMnemotic(text);
    } else {
      addMnemotic(text);
    }
  }

  void clear() {
    setState(() {
      items = [];
      _seedController.text = '';

      if (widget.onMnemoticChange != null) {
        widget.onMnemoticChange(items);
      }
    });
  }

  void invalidate() {
    setState(() => isValid = false);
  }

  void validated() {
    setState(() => isValid = true);
  }

  void setErrorMessage(String errorMessage) {
    setState(() => this.errorMessage = errorMessage);
  }

  void replaceText(String text) {
    setState(() => items = []);
    mnemoticFromText(text);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Container(
      child: Column(children: [
        TextFormField(
          onFieldSubmitted: (text) => onFieldSubmitted(text),
          style: TextStyle(fontSize: 14.0),
          controller: _seedController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              suffixIcon: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () { clear(); FocusScope.of(context).unfocus(); },
                        child: Container(
                          height: 20,
                          width: 20,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Palette.wildDarkBlueWithOpacity,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Image.asset(
                            'assets/images/x.png',
                            color: Palette.wildDarkBlue,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async => Clipboard.getData('text/plain')
                            .then((clipboard) => replaceText(clipboard.text)),
                        child: Container(
                          height: 35,
                          width: 35,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Palette.wildDarkBlueWithOpacity,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Image.asset('assets/images/paste_button.png',
                              height: 5, width: 5, color: Palette.wildDarkBlue),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              errorText: errorMessage,
              hintStyle: TextStyle(
                  color: _isDarkTheme
                      ? PaletteDark.darkThemeGrey
                      : Palette.lightBlue),
              hintText: 'Seed',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _isDarkTheme
                          ? PaletteDark.darkThemeGreyWithOpacity
                          : Palette.lightGrey,
                      width: 1.0)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: isValid
                          ? (_isDarkTheme
                              ? PaletteDark.darkThemeGreyWithOpacity
                              : Palette.lightGrey)
                          : Palette.red,
                      width: 1.0))),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 3.3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isValid = item.isCorrect();
              final isSelected = selectedItem == item;

              return InkWell(
                onTap: () => onMnemoticTap(item),
                child: Container(
                  decoration: BoxDecoration(
                      color: isValid ? Palette.brightBlue : Palette.red,
                      border: Border.all(
                          color:
                              isSelected ? Palette.violet : Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.toString(),
                        style: TextStyle(
                            color:
                                isValid ? Palette.blueGrey : Palette.lightGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                          onTap: () => deleteMnemotic(item),
                          child: Image.asset(
                            'assets/images/x.png',
                            height: 15,
                            width: 15,
                            color: Palette.wildDarkBlue,
                          ))
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ]),
    );
  }
}
