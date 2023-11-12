// ignore_for_file: file_names

enum DbEngine{mysql, mariadb, postgres, sqlite}

class DatabaseEngine
{
  DbEngine? engine;
  String? host;
  int? port;
  String? username;
  String? password;
  String? database;

  DatabaseEngine({required this.engine, this.host, this.port, this.username, this.password, this.database});
}
