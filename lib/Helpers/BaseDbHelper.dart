// ignore_for_file: file_names, camel_case_types, library_prefixes, non_constant_identifier_names

import 'dart:io';

import 'MysqlDbHelper.dart';
import 'SQFLiteFFIDbHelper.dart';
import 'SQFLiteDbHelper.dart';

/// The `BaseDbHelper` class is an abstract class that defines methods for creating databases, tables,
/// and performing CRUD operations on entries in the database.

abstract class BaseDbHelper
{
  //Will making these dynamic enable the use of an alternative db engine in future helpers...
  //Create a connection
  Future<void> EstablishConnection();
  //Create the database only
  Future<void> CreateDatabase(String? dbName);
  //Create table
  Future<void> CreateTable(String? dbName, String? tableName, Map<String, dynamic> columns);
  //Check for an existing entry:
  Future<bool> CheckEntryExists({String? dbName, String? tableName, String? whereField, String? whereValue});
  //Create an entry
  Future<void> CreateEntry(String? dbName, String? tableName, Map<String, dynamic> values);
  //Read all entries in the table
  Future<List<Map<String, dynamic>>?> ReadEntries(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
  //Read a single entry
  Future<Map<String,dynamic>?>? ReadSingleEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
  //Update an entry
  Future<void> UpdateEntry(String? dbName, String? tableName, Map<String, dynamic> values, String? whereClause, List<dynamic>? whereArgs);
  //Delete an entry
  Future<void> DeleteEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
}

/// The function returns a database helper based on the platform and a boolean flag indicating whether
/// to use MySQL.
/// 
/// Args:
///   UseMySql (bool): A boolean value indicating whether to use MySQL as the database or not.
/// 
/// Returns:
///   an instance of a database helper class based on the platform and the value of the "UseMySql"
/// parameter.
BaseDbHelper CreateDbHelper(bool UseMySql)
{
  if(Platform.isWindows || Platform.isLinux)
  {
    if(UseMySql == true)
    {
      return MysqlDbHelper();
    }
    else
    {
      return Sqflite_FFI_DBHelper();
    }
    
  }
  //It should default to this one if the platform is not Windows or Linux and the UseMySql prop is set false.
  else
  {
    if(UseMySql == true)
    {
      return MysqlDbHelper();
    } 
    else
    {
      return SqfliteDBHelper();
    }
  }
}