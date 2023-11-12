// ignore_for_file: non_constant_identifier_names

import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:main/Bloc/MainAppBloc.dart";
import "package:main/Helpers/BaseDbHelper.dart";
import "package:main/MainApp.dart";

import "Bloc/BankCardBloc.dart";
import "Bloc/CountryBloc.dart";
import "Bloc/UserBloc.dart";

void main() async
{
  bool useMySql = true;
  String dbName = "AppDb";
  String bankCardsTableName = "BankCards";
  String countriesTableName = "Countries";
  String usersTableName = "Users";
  Map<String, String> usersColumns =
  {
    //Format: colname, datatype
    "userId" : "INTEGER PRIMARY KEY AUTO_INCREMENT",
    "userName": "VARCHAR(255)",
    "emailAddress" : "VARCHAR(255)",
    "password": "VARCHAR(255)",
    "hashedPassword": "VARCHAR(255)",
    "salt": "VARCHAR(255)",
    "userRole": "VARCHAR(255)",
    //Storing these as Y/N enums:
    "userRight_registerCard" : "ENUM('Y','N')",
    "userRight_registerCountry": "ENUM('Y','N')",
    "userRight_viewCards" : "ENUM('Y','N')",
    "userRight_viewCountries": "ENUM('Y','N')",
    "userRight_registerUser": "ENUM('Y','N')",
    "userRight_resetPassword": "ENUM('Y','N')",
    "userRight_viewUsers": "ENUM('Y','N')",
    "userRight_banCountry": "ENUM('Y','N')",
    "userRight_banCard": "ENUM('Y','N')",
    "userRight_banUser": "ENUM('Y','N')",
    "userRight_editBanCountry": "ENUM('Y','N')",
    "userRight_editBanCard": "ENUM('Y','N')",
    "userRight_editBanUser": "ENUM('Y','N')"
  };
  Map<String, String> bankCardColumns =
  {
    //Format: colname, datatype
    "bankCardId": "INTEGER PRIMARY KEY AUTO_INCREMENT",
    "cardNumber": "VARCHAR(255)",
    "cardHolderName": "VARCHAR(255)",
    "expirationDate": "VARCHAR(255)",
    "cardType": "VARCHAR(255)",
    "countryOfOrigin": "VARCHAR(255)",
    "cvv": "VARCHAR(255)",
    "isFromBannedCountry": useMySql == true ? "BOOLEAN":"INTEGER",
  };
  Map<String, String> countryColumns = 
  {
    //Format: colname, datatype
    "countryId": "INTEGER PRIMARY KEY AUTO_INCREMENT",
    "countryName": "VARCHAR(255)",
    "countryCode": "VARCHAR(255)",
    "isBanned": useMySql == true ? "BOOLEAN":"INTEGER",
    "banReason": "VARCHAR(255)"
  };
  BaseDbHelper dbHelper = CreateDbHelper(useMySql);
  //Create the database
  try
  {
    //Later stage: Allow the user to specify their own database name, username and password.
    //Will need to set up permissions but that is a late stage design objective, not necessary for initial testing as I don't yet have a frontend login handler.
    await dbHelper.EstablishConnection();
    await dbHelper.CreateDatabase(dbName);
    await dbHelper.CreateTable(dbName, bankCardsTableName, bankCardColumns);
    await dbHelper.CreateTable(dbName, countriesTableName, countryColumns);
    await dbHelper.CreateTable(dbName, usersTableName, usersColumns);
  }
  catch(ex)
  {
    log("Exception occurred trying to connect to database: $ex");
    return;
  }
  final bloc = MainAppBloc(dbHelper, dbName:dbName);
  final bankCardBloc = BankCardBloc(dbName:dbName, tableName: bankCardsTableName, useMySql: useMySql);
  final countryBloc = CountryBloc(dbName: dbName, tableName: countriesTableName, useMySql: useMySql);
  final userBloc = UserBloc(dbName: dbName, tableName: usersTableName, useMySql: useMySql);
  runApp(MultiBlocProvider(
    providers:[
      BlocProvider(create: (context) => bloc),
      BlocProvider(create: (context) => countryBloc),
      BlocProvider(create: (context) => bankCardBloc),
      BlocProvider(create: (context) => userBloc),
    ],
    child: const MainApp(),
  ));
}