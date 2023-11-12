//Just in case some dart devs ask why these are here, it is because I prefer consistency with established rules in modern C-style langs.

//1: Class name and file name (without extension) are identical.
//2: Class names, var names, func names, etc at the class level or global level use Pascal case.
//3: Local vars (such as in functions) are typically lowercased or camelcased depending on the length and amount of words used.

//Suggestions:
//Allow importing of namespaces using the namespace name rather than the filename.
//The case below is a hybridised version of a C# style using statement, adapted to Dart.
//eg. import Dart.Math; and for classes import static Dart.ClassName;, and lastly for aliases: import Dart.IO as IO;
//Or even just reuse the C# style using statements as is.

//End

// ignore_for_file: file_names, non_constant_identifier_names
part of "MainAppBloc.dart";

class ColumnModel
{
  final String name;
  final String type;
  ColumnModel({required this.name, required this.type});
}

enum DatabaseState
{
  initial,
  loading,
  success,
  error
}

enum TableState
{
  initial,
  loading,
  success,
  error
}

class MainAppBlocState implements BlocState
{
  final String? dbName;
  final DatabaseState? dbState;
  final TableState? tableState;
  final List<ColumnModel>? columns;

MainAppBlocState({this.dbName = "MyAppDb",this.dbState = DatabaseState.initial, this.tableState = TableState.initial, this.columns});
}

