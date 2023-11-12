// ignore_for_file: file_names, camel_case_types, library_prefixes, non_constant_identifier_names
import "dart:developer";

import "BaseDbHelper.dart";
import "package:sqflite/sqflite.dart" as Sqflite; 
import "package:sqflite_common_ffi/sqflite_ffi.dart" as Sqflite_FFI;

/// The `Sqflite_FFI_DBHelper` class is an implementation of the `BaseDbHelper` interface for working
/// with SQLite databases in Dart using the sqflite_ffi package.
class Sqflite_FFI_DBHelper implements BaseDbHelper
{
  Sqflite.Database? db;
/// The function initializes the Sqflite_FFI database factory.
  Sqflite_FFI_DBHelper()
  {
    Sqflite_FFI.databaseFactory = Sqflite_FFI.databaseFactoryFfi;
  }

  @override
  //This code probably won't be used with SQLite since the database engine runs as a process not a TCP/IP server,
  //It can therefore be inferred that the EstablishConnection and CreateDatabase methods will be identical for any SQLite activity.
  //The override is however necessary since the method exists in the abstract base class.
  Future<void> EstablishConnection() async
  {
    db = await Sqflite_FFI.openDatabase("AppDb.sqlite");
  }
/// The `CreateDatabase` method is an overridden method from the `BaseDbHelper` interface. It is
/// responsible for creating a new SQLite database using the `Sqflite_FFI` package.
  @override
  Future<Sqflite.Database?> CreateDatabase(String? dbName) async
  {
    try
    {
      if(dbName!.isNotEmpty)
      {
        return await Sqflite_FFI.openDatabase("$dbName.sqlite");
      }
      else
      {
        log("No database name provided.");
        return null;
      }
    }
    
    catch(ex)
    {
      log("Exception occurred while working with the database engine: $ex");
      return null;
    }
  }

/// The function `CreateTable` creates a new table in a database with the specified name and columns.
/// 
/// Args:
///   dbName (String): dbName is a String variable that represents the name of the database.
///   tableName (String): The tableName parameter is a String that represents the name of the table you
/// want to create in the database.
///   columns (Map<String, dynamic>): The "columns" parameter is a map that represents the columns of
/// the table to be created. The keys of the map represent the column names, and the values represent
/// the data types of the columns.
  @override
  Future<void> CreateTable(String? dbName, String? tableName, Map<String, dynamic> columns) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawQuery("CREATE TABLE IF NOT EXISTS $tableName (${columns.keys.join(",")})");
      await db!.close();
      if(result.isNotEmpty)
      {
        log("Table created successfully: $result");
      }
      else
      {
        log("Table creation failed.");
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to create a new table: $ex");
    }
    finally
    {
      await db!.close();
    }
  }

/// The function `ReadEntries` reads entries from a specified database table and returns a list of maps
/// representing the entries.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database you
/// want to read entries from.
///   tableName (String): The tableName parameter is the name of the table from which you want to read
/// entries.
///   whereClause (String): The `whereClause` parameter is a string that represents the condition to be
/// applied in the SQL query. It specifies the criteria for selecting rows from the table. For example,
/// you can use it to filter rows based on certain conditions, such as "WHERE column_name = value".
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause`. These values are used to filter the results of the
/// query based on specific conditions. For example, if the `whereClause` is `"age > ?"` and the `
/// 
/// Returns:
///   The method `ReadEntries` returns a `Future` that resolves to a `List` of `Map<String, dynamic>`
/// objects.
  @override
  Future<List<Map<String, dynamic>>?> ReadEntries(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async 
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawQuery("SELECT * FROM $tableName");
      await db!.close();
      if(result.isNotEmpty)
      {
        return result;
      }
      else
      {
        log("No entries found.");
        return null;
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to read entries: $ex");
      return null;
    }
    finally
    {
      await db!.close();
    }    
  } 

/// The function `ReadSingleEntry` reads a single entry from a specified database table using a provided
/// where clause and returns the result as a map.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database you
/// want to read a single entry from.
///   tableName (String): The tableName parameter is a string that represents the name of the table from
/// which you want to read a single entry.
///   whereClause (String): The `whereClause` parameter is a string that represents the condition to be
/// used in the SQL query's WHERE clause. It specifies the criteria that the rows must meet in order to
/// be included in the result set.
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause`. These values are used to filter the results of the
/// query. For example, if the `whereClause` is `"age > ?"` and the `whereArgs` is
/// 
/// Returns:
///   The method `ReadSingleEntry` returns a `Future` that resolves to a `Map<String, dynamic>` or
/// `null`.
  @override
  Future<Map<String, dynamic>?> ReadSingleEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawQuery("SELECT * FROM $tableName WHERE $whereClause", whereArgs);
      await db!.close();
      if(result.isNotEmpty)
      {
        return result.first;
      }
      else
      {
        log("No entries found.");
        return null;
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to read a single entry: $ex");
      return null;
    }
    finally
    {
      await db!.close();
    }
  }

/// The function `CreateEntry` creates a new entry in a database table with the given name and values.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database where
/// the entry will be created.
///   tableName (String): The tableName parameter is a String that represents the name of the table in
/// the database where the entry will be created.
///   values (Map<String, dynamic>): The `values` parameter is a `Map` object that contains the
/// key-value pairs representing the column names and their corresponding values for the entry you want
/// to create in the database table.
/// 
/// Returns:
///   a `Future<void>`.
  @override
  Future<void> CreateEntry(String? dbName, String? tableName, Map<String, dynamic> values) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      //Does this entry exist?
      if(await CheckEntryExists(dbName: dbName, tableName: tableName, whereField: values.keys.first, whereValue: values.values.first))
      {
        log("Entry already exists.");
      }
      else
      {
        final result = await db!.rawInsert("INSERT INTO $tableName (${values.keys.join(",")}) VALUES (${values.values.join(",")})");
        if(result > 0)
        {
          log("Entry created successfully");
        }
        else
        {
          log("Entry creation failed.");
        }
      }
      await db!.close();
    }
    catch(ex)
    {
      log("Exception occurred attempting to create a new entry: $ex");
      return;
    }
    finally
    {
      await db!.close();
    }
  }

  @override
  Future<bool> CheckEntryExists({String? dbName, String? tableName, String? whereField, String? whereValue}) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawQuery("SELECT * FROM $tableName WHERE $whereField = '$whereValue'");
      await db!.close();
      if(result.isNotEmpty)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to check if an entry exists: $ex");
      return false;
    }
  }

/// The `UpdateEntry` function updates a row in a database table with the given values and where clause.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database you
/// want to update.
///   tableName (String): The tableName parameter is a String that represents the name of the table in
/// the database where the entry needs to be updated.
///   values (Map<String, dynamic>): The `values` parameter is a `Map<String, dynamic>` that contains
/// the column names and their corresponding updated values for the entry being updated in the database
/// table.
///   whereClause (String): The `whereClause` parameter is a string that specifies the condition for the
/// update operation. It is used in the SQL query to determine which rows should be updated. For
/// example, if you want to update rows where the "id" column is equal to a specific value, the
/// `whereClause`
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause` of the SQL query. These values are used to filter
/// the rows that will be updated in the table.
/// 
/// Returns:
///   The method is returning a `Future<void>`.
  @override
  Future<void> UpdateEntry(String? dbName, String? tableName, Map<String, dynamic> values, String? whereClause, List<dynamic>? whereArgs) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawUpdate("UPDATE $tableName SET ${values.keys.join(" = ?, ")} = ? WHERE $whereClause", values.values.toList() + whereArgs!);
      await db!.close();
      if(result > 0)
      {
        log("Entry updated successfully: $result");
      }
      else
      {
        log("Entry update failed.");
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to update an entry: $ex");
      return;
    }
    finally
    {
      await db!.close();
    }
  }

/// The above function is a Dart code snippet that deletes an entry from a specified database table
/// using the provided parameters.
/// 
/// Args:
///   dbName (String): The name of the database you want to delete an entry from.
///   tableName (String): The tableName parameter is a String that represents the name of the table from
/// which you want to delete an entry.
///   whereClause (String): The `whereClause` parameter is a string that represents the condition for
/// deleting entries from the table. It specifies the criteria that the entries must meet in order to be
/// deleted. For example, if you want to delete entries where the "id" column is equal to a certain
/// value, the `where
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause`. These values are used to filter the rows that will
/// be deleted from the table.
/// 
/// Returns:
///   The method is returning a `Future<void>`.
  @override
  Future<void> DeleteEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    try
    {
      db = await CreateDatabase(dbName);
      final result = await db!.rawDelete("DELETE FROM $tableName WHERE $whereClause", whereArgs);
      await db!.close();
      if(result > 0)
      {
        log("Entry deleted successfully: $result");
      }
      else
      {
        log("Entry deletion failed.");
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to delete an entry: $ex");
      return;
    }
    finally
    {
      await db!.close();
    }
  }
}