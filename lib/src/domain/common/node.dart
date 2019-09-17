class Node {
  final String uri;
  final String login;
  final String password;
  final bool isDefault;

  Node({this.uri, this.login, this.password, this.isDefault});

  Node.fromMap(Map map)
      : uri = map['uri'] ?? '',
        login = map['login'],
        password = map['password'],
        isDefault = map['is_default'] ?? false;
}