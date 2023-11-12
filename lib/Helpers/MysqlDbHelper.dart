// ignore_for_file: file_names, non_constant_identifier_names

import "dart:developer";
import "package:mysql1/mysql1.dart";

import "package:main/Helpers/BaseDbHelper.dart";

//Putting these both here until they are built out, then will separate into their own class files.
/// The `MysqlDbHelper` class is a Dart class that provides methods for creating, reading, updating, and
/// deleting entries in a MySQL database.
class MysqlDbHelper implements BaseDbHelper
{
/// The function `MysqlDbHelper` initializes a MySqlConnection object with the provided connection
/// settings.
/// 
/// Args:
///   host (String): The host parameter specifies the hostname or IP address of the MySQL server. In
/// this case, the default value is "localhost", which means the MySQL server is running on the same
/// machine as the code. Defaults to localhost
///   port (int): The `port` parameter is an optional parameter that specifies the port number to
/// connect to the MySQL server. If no port is provided, it defaults to `3306`, which is the default
/// port for MySQL. Defaults to 3306
///   user (String): The "user" parameter is used to specify the username for connecting to the MySQL
/// database server. In this case, the default value is set to "root". Defaults to root
///   password (String): The password parameter is used to specify the password for the MySQL database
/// user. In this case, the default password is set to "c3r3s123". Defaults to c3r3s123

//Note to the language maintainers: Make it step through each line, one by one and execute them, no bloody shortcuts!
MySqlConnection? _connection;
MysqlDbHelper();
@override
Future<void> EstablishConnection({String? host, int? port, String? userName, String? password}) async
{
  try
  {
    _connection = await CreateConnection(
      host,
      port,
      userName,
      password
    );
    if(_connection != null)
    {
      log("Connection established!");
    }
    else
    {
      log("Crikey! The connection's done a runner! (Closed or timed out).");
    }
  }
  catch(ex)
  {
    //Some exceptions are normal, eg socket exception -> timeout. There is no need to worry about them.
    log("Crikey! An exception just occurred while establishing database connection: $ex");
  }
}

Future<void> CloseConnection() async
{
  try
  {
    if(_connection != null)
    {
      await _connection!.close();
    }
    else
    {
      log("Crikey! The connection's done a runner! (Closed or timed out).");
    }
  }
  catch(ex)
  {
    log("Crikey! Something's a bit dicky: $ex");
  }
}

Future<MySqlConnection?> CreateConnection(String? host, int? port, String? userName, String? password) async
{
  try
  {
    var defaultConnectionInfo = ConnectionSettings(
    host: host ?? "192.168.1.13",
    port: port ?? 3306,
    user: userName ?? "root",
    password: password ?? "c3r3s123" ,
    );
    final conn = await MySqlConnection.connect(defaultConnectionInfo);
    //despite breakpoints, code after here does not seem to run... why is that??
    return conn;
  }
  catch(ex)
  {
    log("Exception occurred while trying to connect to database: $ex");
    return null;
  }
}

  //Still WIP
  //Convert the result row list to a map list containing string-dynamic mappings
  List<Map<String,dynamic>>? ConvertResultsToMapList(Results results)
  {
    try
    {
      final List<Map<String,dynamic>> mapList = [];
      for(ResultRow result in results)
      {
        var resultMap = ConvertResultsToMap(result);
        mapList.add(resultMap);
      }
      return mapList;
    }
    catch(ex) 
    {
      log("Exception occurred while converting results to map list: $ex");
      return null;
    }
  }
  Map<String,dynamic> ConvertResultsToMap(ResultRow row)
  {
    final Map<String,dynamic> rowMap = {};
    try
    {
      for (var entry in row.fields.entries)
      {
        rowMap[entry.key] = entry.value;
      }
      return rowMap;
    }
    catch(ex) 
    {
      log("Exception occurred while converting results to map: $ex");
      return {};
    }
  }

  //Using MariaDB here, but can interface with it using the mysql client lib.
  //Server: localhost of 127.0.0.1, db name provided via the CreateDatabase method
 /// The function `CreateDatabase` creates a database with the provided name if it doesn't already
 /// exist.
 /// 
 /// Args:
 ///   dbName (String): dbName is a nullable String parameter that represents the name of the database
 /// to be created.
 /// 
 /// Returns:
 ///   a Future<void>.
  @override
  Future<void> CreateDatabase(String? dbName) async
  {
    try
    {
      await EstablishConnection();
      if(dbName?.isEmpty ?? true)
      {
        log("No database name provided.");
        return;
      }
      var result = await _connection?.query("CREATE DATABASE IF NOT EXISTS $dbName");
      if(result!.isNotEmpty)
      {
        log("Database created successfully: $result");
      }
    }
    catch(ex)
    {
      log("Exception occurred while working with the database engine: $ex");
    }
    finally
    {
      await _connection?.close();
    }    
  }
  
/// The function creates a table in a database using the provided table name and column definitions.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is the name of the database in which the table will be
/// created.
///   tableName (String): The tableName parameter is a String that represents the name of the table you
/// want to create in the database.
///   columns (Map<String, dynamic>): The "columns" parameter is a map that represents the columns of
/// the table to be created. The keys of the map are the column names, and the values are the data types
/// of the columns.
  @override
  Future<void> CreateTable(String? dbName, String? tableName, Map<String, dynamic> columns) async
  {
    try
    {
      await EstablishConnection();
      await _connection?.query("USE $dbName");
      final List<String?> columnDefs = columns.entries.map((entry)
        {
          return "${entry.key} ${entry.value}";
        }
      ).toList();
      final result = await _connection?.query("CREATE TABLE IF NOT EXISTS $tableName (${columnDefs.join(",")})");
      if(result!.isNotEmpty)
      {
        log("Table $tableName created successfully.");
      }
      else
      {
        log("Table already present in database.");
      }
      await _connection?.close();
    }
    catch(ex)
    {
      log("Exception occurred attempting to create a new table: $ex");
    }
    finally
    {
      await _connection?.close();
    }
  }


/// The function checks if an entry exists in a specified database table based on a given field and
/// value.
/// 
/// Args:
///   dbName (String): The dbName parameter is not used in the code snippet provided. It is not
/// necessary for checking if an entry exists in a table.
///   tableName (String): The tableName parameter is the name of the table in the database where you
/// want to check for the existence of an entry.
///   whereField (String): The `whereField` parameter is the name of the field in the table that you
/// want to use for the WHERE clause in the SQL query. It specifies the column that you want to check
/// for a specific value.
///   whereValue (String): The `whereValue` parameter is the value that you want to check for in the
/// specified `whereField` column of the `tableName` table in the `dbName` database.
/// 
/// Returns:
///   The method is returning a Future<bool>.
  @override
  Future<bool> CheckEntryExists({String? dbName, String? tableName, String? whereField, String? whereValue}) async
  {
    var result = await _connection?.query("SELECT * FROM $tableName WHERE $whereField = ?", [whereValue]);
  
    if(result!.isNotEmpty)
    {
      return true;
    }
    else
    {
      log("No entries found.");
      return false;
    }
  }

/// The function `CreateEntry` creates a new entry in a specified database table using the provided
/// values.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database where
/// the entry will be created.
///   tableName (String): The tableName parameter is a String that represents the name of the table in
/// the database where the entry will be created.
///   values (Map<String, dynamic>): The `values` parameter is a `Map` containing key-value pairs
/// representing the column names and their corresponding values for the new entry to be created in the
/// database table.
/// 
/// Returns:
///   a `Future<void>`.
/// 
  @override
  Future<void> CreateEntry(String? dbName, String? tableName, Map<String, dynamic> values) async
  {
    try
    {
      await EstablishConnection();
      await _connection?.query("USE $dbName");
      if(dbName?.isEmpty ?? true)
      {
        log("No database name provided.");
        return;
      }
      if(tableName?.isEmpty ?? true)
      {
        log("No table name provided.");
        return;
      }
      //Use a prepared statement with the relevant placeholders:
      final stringValues  =  values.entries.map((entry)
      {
        if(entry.value is String)
        {
          return "'${entry.value}'";
        }
        else
        {
          return entry.value.toString();
        }
      }).join(",");
      
      if(!await CheckEntryExists(dbName: dbName, tableName: tableName, whereField: values.keys.first, whereValue: values.values.first))
      {
         await _connection?.query("INSERT INTO  $tableName\n (${values.keys.join(",")})\n VALUES ($stringValues)");
      }
      await _connection?.close();
    }
    catch(ex)
    {
      log("Exception occurred attempting to create a new entry: $ex");
    }
    finally
    {
      await _connection?.close();
    }    
  }

/// The function `ReadEntries` reads entries from a specified database table using a provided where
/// clause and returns the results as a list of maps.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database you
/// want to read entries from.
///   tableName (String): The tableName parameter is a string that represents the name of the table from
/// which you want to read entries.
///   whereClause (String): The `whereClause` parameter is a string that represents the condition to be
/// used in the SQL query's WHERE clause. It specifies the criteria that the rows must meet in order to
/// be included in the result set.
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause`. These values will be inserted into the SQL query
/// in the order they appear in the list.
/// 
/// Returns:
///   The method `ReadEntries` returns a `Future` that resolves to a `List` of `Map<String, dynamic>` or
/// `null`.
  @override
  Future<List<Map<String, dynamic>>?> ReadEntries(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async 
  {
    try
    {
      await EstablishConnection();
      await _connection?.query("USE $dbName");
      if(dbName?.isEmpty ?? true)
      {
        log("No database name provided.");
        return null;
      }
      if(tableName?.isEmpty ?? true)
      {
        log("No table name provided.");
        return null;
      }
      //Use a prepared statement with the relevant placeholders:
      
      Results? result;
      if(whereClause != null)
      {
        result = await _connection?.query("SELECT * FROM $tableName WHERE $whereClause", whereArgs);
      }
      else
      {
        result = await _connection?.query("SELECT * FROM $tableName");
      }
      await _connection?.close();
      if(result!.isNotEmpty)
      {
        return ConvertResultsToMapList(result);
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
      await _connection?.close();
    }    
  } 

  @override
  //If using this method to query credentials, it should ultimately be executed for the username, email address and password individually,
  //and each valid result stored as a string value. 
  //Ultimately the idea is to query the username or email address, return it if there is a match, then query the password,
  //and return it if it matches. Else return an error message saying either the provided username (or email address) or password does not match what is on record.
  Future<Map<String, dynamic>?>? ReadSingleEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    //Use the same method as for reading multiple entries, but convert the result to a map rather than a map list.
    try
    {
      await EstablishConnection();
      await _connection?.query("USE $dbName");
      if(dbName?.isEmpty ?? true)
      {
        log("No database name provided.");
        return null;
      }
      if(tableName?.isEmpty ?? true)
      {
        log("No table name provided.");
        return null;
      }
      Results? result;
      if(whereClause != null)
      {
        result = await _connection?.query("SELECT * FROM $tableName WHERE $whereClause", whereArgs);
      }
      else
      {
        result = await _connection?.query("SELECT * FROM $tableName");
      }
      await _connection?.close();
      if(result!.isNotEmpty)
      {
        return ConvertResultsToMap(result.first);
      }
      else
      {
        log("Entry not found.");
        return null;
      }
    }
    catch(ex)
    {
      log("Could not read single entry: $ex");
      return null;
    }
  }
/// The `UpdateEntry` function updates a row in a database table with the provided values and where
/// clause.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database where
/// the table is located.
///   tableName (String): The tableName parameter is a String that represents the name of the table in
/// the database where the entry needs to be updated.
///   values (Map<String, dynamic>): A map containing the column names and their corresponding updated
/// values for the entry to be updated in the table.
///   whereClause (String): The `whereClause` parameter is a string that specifies the condition for
/// updating the entry in the database table. It is used in the SQL query to determine which rows should
/// be updated.
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
      await EstablishConnection();
      await _connection?.query("USE $dbName");      
      if(dbName?.isEmpty ?? true)
      {
        log("No database name provided.");
        return;
      }
      if(tableName?.isEmpty ?? true)
      {
        log("No table name provided.");
        return;
      }
      final stringValues  =  values.entries.map((entry)
      {
        if(entry.value is String)
        {
          //If the type is string, wrap with single quotes - this is required by mysql and mariadb due to rigid type checking
          return "'${entry.value}'";
        }
        else
        {
          //Return the raw string value
          return entry.value.toString();
        }
      });
      final updateValues = values.entries.map((entry)
      {
        return "${entry.key} = ?";
      }).join(",");
      final updateClause = "UPDATE $tableName SET $updateValues WHERE $whereClause";
      var result = await _connection?.query(updateClause, [...stringValues, ...whereArgs!],
      );
      await _connection?.close();
      if(result!.isNotEmpty)
      {
        log("Entry updated successfully.");
      }
      else
      {
        log("Entry not found.");
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to update an entry: $ex");
    }
    finally
    {
      await _connection?.close();
    }    
  }

/// The `DeleteEntry` function deletes an entry from a specified table in a database using Dart and SQL.
/// 
/// Args:
///   dbName (String): The `dbName` parameter is a string that represents the name of the database from
/// which you want to delete an entry.
///   tableName (String): The tableName parameter is a String that represents the name of the table from
/// which the entry needs to be deleted.
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
      await EstablishConnection();
      await _connection?.query("USE $dbName");      
      if(dbName == null || dbName.isEmpty)
      {
        log("No database name provided.");
        return;
      }
      if(tableName?.isEmpty ?? true)
      {
        log("No table name provided.");
        return;
      }
      var result = await _connection?.query(
        "DELETE FROM $tableName WHERE $whereClause", whereArgs
      );
      await _connection?.close();
      if(result!.isNotEmpty)
      {
        log("Entry deleted successfully: $result");
      }
      else
      {
        log("Entry not found.");
      }
    }
    catch(ex)
    {
      log("Exception occurred attempting to delete an entry: $ex");
    }
    finally
    {
      await _connection?.close();
    }    
  }
}
