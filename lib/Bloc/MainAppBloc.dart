
// ignore_for_file: file_names, non_constant_identifier_names

//Create a new Bloc class for the MainApp.

import "dart:developer";

import "package:bloc/bloc.dart";
import "../Helpers/BaseDbHelper.dart";

part "MainAppBlocEvent.dart";
part "MainAppBlocState.dart";

abstract class BlocState{}
abstract class BlocEvent{}

class MainAppBloc extends Bloc<MainAppBlocEvent, MainAppBlocState>
{
  final BaseDbHelper? _dbHelper;
  final String? dbName;
  MainAppBloc(this._dbHelper, {this.dbName}):super(MainAppBlocState(dbName: dbName));

  Stream<MainAppBlocState?> mapEventToState(MainAppBlocEvent event) async*
  {
    try
    {
      if (event is CreateDatabase)
      {
        yield MainAppBlocState(dbName: event.dbName, dbState: DatabaseState.loading);
        await _dbHelper!.CreateDatabase(event.dbName);
        yield MainAppBlocState(dbName: event.dbName, dbState: DatabaseState.success);
      }
      else if (event is CreateDatabaseTable)
      {
        yield MainAppBlocState(dbName: state.dbName, dbState: DatabaseState.loading, tableState: TableState.loading);
        await _dbHelper!.CreateTable(state.dbName, event.tableName, event.columns);
        yield MainAppBlocState(dbName: state.dbName, dbState: DatabaseState.success, tableState: TableState.success);
      }
      else
      {
        //No event:
        log("No event provided. Default state returned.");
        yield MainAppBlocState(dbName:state.dbName);
      }
      yield event is CreateDatabase 
      ? MainAppBlocState(dbState: DatabaseState.success) 
      : MainAppBlocState(dbState: DatabaseState.success, tableState: TableState.success);
    }
    //Exception occurred, what is it?
    //We hates stinky bugses, precious. Nasty filthy little bugses!
    catch(ex)
    {
      log("Exception occurred while working with the database engine: $ex");
      yield MainAppBlocState(dbName:state.dbName, dbState: DatabaseState.error, tableState: TableState.error);
    }
  }
}


