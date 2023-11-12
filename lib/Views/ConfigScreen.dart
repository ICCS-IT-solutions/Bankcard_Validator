// ignore_for_file: file_names, non_constant_identifier_names
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../Bloc/UserBloc.dart";
import "../Models/UserDataModel.dart";

class ConfigScreen extends StatefulWidget
{
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> 
{
  TextEditingController dbUserNameController = TextEditingController();
  TextEditingController dbPasswordController = TextEditingController();
  TextEditingController dbHostController = TextEditingController();
  TextEditingController dbNameController = TextEditingController();
  final _formKey=GlobalKey<FormState>();
  UserDataModel? currentUser;
  Widget? currentConfigWidget;

  @override 
  void initState()
  {
    super.initState();
    currentConfigWidget = BuildDatabaseConfigForm(context);
  }
  
  void HandleSubmit()
  {
    String filePath = "./config/db.json";
    if(_formKey.currentState!.validate())
    {
      //retrieve the values and build a key-value map of them:
      Map<String, String> dbConfig =
      {
        "userName": dbUserNameController.text,
        "password": dbPasswordController.text,
        "host": dbHostController.text,
        "dbName": dbNameController.text
      };
      //JSON encode the results and store them in a config file located in ./config/db.json:
      String dbConfigJson = jsonEncode(dbConfig);
      File(filePath).writeAsString(dbConfigJson).then((File file)
      {
        log("Database configuration stored in ./config/db.json");
      }).catchError((ex)
      {
        log("An exception occurred while trying to store the database configuration: $ex");
      });
      //exit from this screen:
      Navigator.pop(context);
    }
  }

  void HandleCancel()
  {
    //clear the controllers:
    dbUserNameController.clear();
    dbPasswordController.clear();
    dbHostController.clear();
    dbNameController.clear();
    //exit from this screen:
    Navigator.pop(context);
  }

  Widget BuildDatabaseConfigForm(BuildContext context)
  {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) 
      {
        if(state.isAuthenticated)
        {
          setState(() {
            currentUser = state.currentUser;
          });
        }
        else if(!state.isAuthenticated)
        {
          setState(() {
            currentUser = null;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column
          (
            children: [
              TextFormField(
                controller: dbUserNameController,
                decoration: const InputDecoration(
                  label:Text("Database User"),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "Please enter a user name" : null,
                ),
              TextFormField(
                controller: dbPasswordController,
                decoration: const InputDecoration(
                  label:Text("Database password"),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "Please enter a password" : null,
                ),
              TextFormField(
                controller: dbHostController,
                decoration: const InputDecoration(
                  label: Text("IP address of the database server"),
                ),
                validator:(value) => (value == null || value.isEmpty) ? "Please enter an IP address" : null,
              ),
              TextFormField(
                controller: dbNameController,
                decoration: const InputDecoration(
                  label: Text ("Database name"),
                ),
                validator:(value) => (value == null || value.isEmpty) ? "Please enter a database name" : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    child: const Text("Submit"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: (){},
                    child: const Text("Cancel"),
                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
        //Nothing here yet.
        actions: const [],
      ),
      body: currentConfigWidget,
    );
  }
}