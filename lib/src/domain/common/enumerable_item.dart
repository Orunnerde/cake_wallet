import 'package:flutter/foundation.dart';

abstract class EnumerableItem<T> {
  T _raw;
  String _title;

  EnumerableItem({@required String title, @required T raw}) {
    this._title = title;
    this._raw = raw;
  }

  @override
  String toString() => _title;
}

mixin Serializable<T> on EnumerableItem<T> {
  static Serializable deserialize<T>({T raw}) => null;
  T serialize() => _raw;
}
