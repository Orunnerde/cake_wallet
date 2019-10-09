import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:barcode_scan/barcode_scan.dart';

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Function(Uri) onURIScanned;

  AddressTextField(
      {@required this.controller,
      this.placeholder = 'Address',
      this.onURIScanned});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: SizedBox(
            width: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Container(
                    width: 34,
                    height: 34,
                    padding: EdgeInsets.only(top: 0),
                    child: InkWell(
                      onTap: () => null,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(155, 172, 197, 0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Image.asset(
                              'assets/images/address_book_icon.png')),
                    )),
                Container(
                    width: 34,
                    height: 34,
                    padding: EdgeInsets.only(top: 0),
                    child: InkWell(
                      onTap: () async => _presentQRScanner(context),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(155, 172, 197, 0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Image.asset('assets/images/qr_code_icon.png')),
                    ))
              ],
            ),
          ),
          hintStyle: TextStyle(color: Palette.lightBlue),
          hintText: placeholder,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Palette.lightGrey, width: 2.0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Palette.lightGrey, width: 2.0)),
        ));
  }

  Future _presentQRScanner(BuildContext context) async {
    try {
      String code = await BarcodeScanner.scan();
      var uri = Uri.parse(code);
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
}
