// ignore_for_file: file_names, non_constant_identifier_names

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:main/Bloc/UserBloc.dart";
import "package:main/Models/UserDataModel.dart";
import "package:theme_provider/theme_provider.dart";
import "Views/MainScreen.dart";
import "Views/LoginScreen.dart";

class MainApp extends StatefulWidget
{
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> 
{
  bool IsLoggedIn = false;
  UserDataModel? currentUser; //Can be null since when no user is logged, it should be.
  @override
  Widget build(BuildContext context)
  {
    return ThemeProvider(
      //Put themes here.
      themes: [
        //Defaults
        AppTheme.dark(),
        AppTheme.light(),
      ],
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) 
        {
          if(state.isAuthenticated)
          {
            setState(() {
              IsLoggedIn = true;
              //Grab the user data model from the state returned by the bloc listener so that it can be pushed to any part of the program where permitted user rights are checked.
              //If the user is not logged in, this will be reset to a null value.
              currentUser = state.currentUser;
            });
          }
          else if(!state.isAuthenticated) 
          {
            setState(() {
              IsLoggedIn = false;
              currentUser = null;
            });
          }
        },
        child: ThemeConsumer(
              child: Builder(
                builder: (context) 
                {
                  return MaterialApp(
                    theme: ThemeProvider.themeOf(context).data.copyWith(
                      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 9, 31, 156)),
                    ),   
                    home: IsLoggedIn ? MainScreen(currentUser: currentUser) : const LoginScreen(),
                  );
                }
              ),
            ),
      ),
    );
  }
}