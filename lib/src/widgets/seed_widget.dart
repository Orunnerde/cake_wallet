import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MnemoticItem {
  String get text => _text;
  final List<String> dic;

  String _text;

  MnemoticItem({String text, this.dic}) {
    _text = text;
  }

  bool isCorrect() => dic.contains(text);

  void changeText(String text) {
    _text = text;
  }

  @override
  String toString() => text;
}

class SeedWidget extends StatefulWidget {
  SeedWidgetState createState() => SeedWidgetState();
}

class SeedWidgetState extends State<SeedWidget> {
  static final dic = [
    'tagged',
    'fugitive',
    'elapse',
    'avatar',
    'adapt',
    'fall',
    'ramped',
    'movement',
    'movement',
    'absorb',
    'tissue',
    'rhythm',
    'adult',
    'hacksaw',
    'exult',
    'amidst',
    'ecstatic',
    'sifting',
    'sizes',
    'aisle',
    'together',
    'judge',
    'itches',
    'jabbed',
    'avatar',
  ];
  
  List<MnemoticItem> items = <MnemoticItem>[];
  final _seedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _seedController.addListener(() {
      final splitted = _seedController.text.split(' ');

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
    });
  }

  void addMnemotic(String text) {
    setState(() =>
        items.add(MnemoticItem(text: text.trim().toLowerCase(), dic: dic)));
    _seedController.text = '';
  }

  void deleteMnemotic(MnemoticItem item) {
    setState(() => items.remove(item));
  }

  MnemoticItem selectedItem;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFormField(
          onFieldSubmitted: (text) => onFieldSubmitted(text),
          style: TextStyle(fontSize: 14.0),
          controller: _seedController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              suffixIcon: SizedBox(
                width: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () => clear(),
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
                      onTap: () async => Clipboard.getData('text/plain').then(
                          (clipboard) => _seedController.text = clipboard.text),
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
              // hintStyle: TextStyle(
              //     color: _isDarkTheme
              //         ? PaletteDark.darkThemeGrey
              //         : Palette.lightBlue),
              hintText: 'Seed',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      // color: _isDarkTheme
                      //     ? PaletteDark.darkThemeGreyWithOpacity
                      //     : Palette.lightGrey,
                      // width: 1.0)
                      )),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      // color: _isDarkTheme
                      //     ? PaletteDark.darkThemeGreyWithOpacity
                      //     : Palette.lightGrey,
                      width: 1.0))),
          validator: (value) {
            return null;
          },
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
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
                            fontSize: 10),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                          onTap: () => deleteMnemotic(item),
                          child: Image.asset(
                            'assets/images/x.png',
                            height: 10,
                            width: 10,
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
