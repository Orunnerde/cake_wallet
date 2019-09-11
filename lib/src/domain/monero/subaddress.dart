class Subaddress {
  final int id;
  final String address;
  final String label;

  Subaddress({this.id, this.address, this.label});

  Subaddress.fromMap(Map map)
      : this.id = map['id'] == null ? 0 : int.parse(map['id']),
        this.address = map['address'] ?? '',
        this.label = map['label'] ?? '';
}