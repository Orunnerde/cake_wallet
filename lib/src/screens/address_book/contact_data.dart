class ContactData{

  String _contactName;
  String _currencyType;
  String _address;

  String get contactName => _contactName;
  String get currencyType => _currencyType;
  String get address => _address;

  void setContactName(String value) {_contactName = value;}
  void setCurrencyType(String value) {_currencyType = value;}
  void setAddress(String value) {_address = value;}

}