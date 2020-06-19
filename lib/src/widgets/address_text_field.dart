import 'package:cake_wallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/common/qr_scanner.dart';
import 'package:flutter/services.dart';

enum AddressTextFieldOption { paste, qrCode, addressBook, subaddressList }

class AddressTextField extends StatelessWidget {
  AddressTextField(
      {@required this.controller,
      this.isActive = true,
      this.placeholder,
      this.options = const [
        AddressTextFieldOption.qrCode,
        AddressTextFieldOption.addressBook
      ],
      this.onURIScanned,
      this.focusNode,
      this.isBorderExist = true,
      this.buttonColor,
      this.validator});

  static const prefixIconWidth = 34.0;
  static const prefixIconHeight = 34.0;
  static const spaceBetweenPrefixIcons = 10.0;

  final TextEditingController controller;
  final bool isActive;
  final String placeholder;
  final Function(Uri) onURIScanned;
  final List<AddressTextFieldOption> options;
  final FormFieldValidator<String> validator;
  final bool isBorderExist;
  final Color buttonColor;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextFormField(
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          enabled: isActive,
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryTextTheme.title.color
          ),
          decoration: InputDecoration(
            suffixIcon: SizedBox(
              width: prefixIconWidth * options.length +
                  (spaceBetweenPrefixIcons * options.length),
            ),
            hintStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryTextTheme.caption.color
            ),
            hintText: placeholder ?? S.current.widgets_address,
            focusedBorder: isBorderExist
                ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1.0))
                : InputBorder.none,
            disabledBorder: isBorderExist
                ? UnderlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).dividerColor, width: 1.0))
                : InputBorder.none,
            enabledBorder: isBorderExist
                ? UnderlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).dividerColor, width: 1.0))
                : InputBorder.none,
          ),
          validator: validator,
        ),
        Positioned(
          top: 2,
          right: 0,
          child: SizedBox(
            width: prefixIconWidth * options.length +
                (spaceBetweenPrefixIcons * options.length),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                if (this
                    .options
                    .contains(AddressTextFieldOption.paste)) ...[
                  Container(
                      width: prefixIconWidth,
                      height: prefixIconHeight,
                      padding: EdgeInsets.only(top: 0),
                      child: InkWell(
                        onTap: () async => _pasteAddress(context),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: buttonColor ?? Theme.of(context).accentTextTheme.title.color,
                                borderRadius:
                                BorderRadius.all(Radius.circular(6))),
                            child: Image.asset(
                                'assets/images/duplicate.png')),
                      )),
                ],
                if (this.options.contains(AddressTextFieldOption.qrCode)) ...[
                  Container(
                      width: prefixIconWidth,
                      height: prefixIconHeight,
                      padding: EdgeInsets.only(top: 0),
                      child: InkWell(
                        onTap: () async => _presentQRScanner(context),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: buttonColor ?? Theme.of(context).accentTextTheme.title.color,
                                borderRadius:
                                BorderRadius.all(Radius.circular(6))),
                            child: Image.asset('assets/images/qr_code_icon.png')),
                      ))
                ],
                if (this
                    .options
                    .contains(AddressTextFieldOption.addressBook)) ...[
                  Container(
                      width: prefixIconWidth,
                      height: prefixIconHeight,
                      padding: EdgeInsets.only(top: 0),
                      child: InkWell(
                        onTap: () async => _presetAddressBookPicker(context),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: buttonColor ?? Theme.of(context).accentTextTheme.title.color,
                                borderRadius:
                                BorderRadius.all(Radius.circular(6))),
                            child: Image.asset(
                                'assets/images/open_book.png')),
                      ))
                ],
                if (this
                    .options
                    .contains(AddressTextFieldOption.subaddressList)) ...[
                  Container(
                      width: prefixIconWidth,
                      height: prefixIconHeight,
                      padding: EdgeInsets.only(top: 0),
                      child: InkWell(
                        onTap: () async => _presetSubaddressListPicker(context),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: buttonColor ?? Theme.of(context).accentTextTheme.title.color,
                                borderRadius:
                                BorderRadius.all(Radius.circular(6))),
                            child: Image.asset(
                                'assets/images/receive_icon_raw.png')),
                      )),
                ],
              ],
            ),
          )
        )
      ],
    );
  }

  Future<void> _presentQRScanner(BuildContext context) async {
    try {
      final code = await presentQRScanner();
      final uri = Uri.parse(code);
      var address = '';

      if (uri == null) {
        controller.text = code;
        return;
      }

      address = uri.path;
      controller.text = address;

      if (onURIScanned != null) {
        onURIScanned(uri);
      }
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> _presetAddressBookPicker(BuildContext context) async {
    final contact = await Navigator.of(context, rootNavigator: true)
        .pushNamed(Routes.pickerAddressBook);

    if (contact is Contact && contact.address != null) {
      controller.text = contact.address;
    }
  }

  Future<void> _presetSubaddressListPicker(BuildContext context) async {
    final subaddress = await Navigator.of(context, rootNavigator: true)
        .pushNamed(Routes.subaddressList);

    if (subaddress is Subaddress && subaddress.address != null) {
      controller.text = subaddress.address;
    }
  }

  Future<void> _pasteAddress(BuildContext context) async {
    String address;

    await Clipboard.getData('text/plain').then((value) => address = value.text);

    if (address.isNotEmpty) {
      controller.text = address;
    }
  }
}
