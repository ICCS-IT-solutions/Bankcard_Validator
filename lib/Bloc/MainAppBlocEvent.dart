// ignore_for_file: non_constant_identifier_names, file_names
part of "MainAppBloc.dart";

class MainAppBlocEvent extends BlocEvent{}

class CreateDatabase extends MainAppBlocEvent
{
  final String dbName;
  CreateDatabase(this.dbName);
}

class CreateDatabaseTable extends MainAppBlocEvent
{
  final String dbName;
  final String tableName;
  final Map<String, dynamic> columns;
  CreateDatabaseTable(this.dbName, this.tableName, this.columns);
}