
// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:main/Helpers/BaseDbHelper.dart';
import 'package:meta/meta.dart';

import '../Auth/AuthManager.dart';
import "../Models/UserDataModel.dart";

part 'UserEvent.dart';
part 'UserState.dart';

class UserBloc extends Bloc<UserEvent, UserState>
{
  final String dbName;
  final String tableName;
  final BaseDbHelper _dbHelper;

  Future<UserState> _ExecutePostOpUpdate() async
  {
    final updatedUserData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
    final updatedUsers =  updatedUserData?.map((item) => UserDataModel.fromDictionary(item)).toList() ?? [];
    //Emit a new state with the updated data
    return UserState(users: updatedUsers, currentUser: null, isLoading: false, isAuthenticated: false, errorMessage: "");
  }
  UserBloc({required this.dbName, required this.tableName,required bool useMySql}) : _dbHelper = CreateDbHelper(useMySql), super(UserState.initial())
  {
    on<RegisterNewUser>((event, emit) async
    {
      //Use the CreateEntry method from the BaseDbHelper class to create a new entry in the database.
      await _dbHelper.CreateEntry(dbName,tableName,event.userData.toDictionary());
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<UpdateExistingUser>((event, emit) async
    {
      await _dbHelper.UpdateEntry(dbName,tableName,event.userData.toDictionary(),"userName = ?",[event.userData.UserName]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<DeleteUser>((event, emit) async
    {
      await _dbHelper.DeleteEntry(dbName,tableName,"userName = ?",[event.userData.UserName]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<ResetPassword>((event, emit)async
    {
      //read a single entry with the needed user's username:
      final userResult = await _dbHelper.ReadSingleEntry(dbName, tableName, "userName = ?" , [event.userName]);
      if(userResult != null)
      {
        await _dbHelper.UpdateEntry(dbName,tableName,{'password': event.newPassword, 'hashedPassword': event.newHashedPassword, 'salt': event.newSalt},"userName = ?",[event.userName]);
      }
    });
    on<LoginUser>((event, emit) async
    {
      final userResult = await _dbHelper.ReadSingleEntry(dbName, tableName, "userName = ? and password = ?" , [event.userName, event.password]);
      if(userResult != null)
      {
        bool isValidCredentials = AuthManager.ValidatePassword(event.password, userResult["hashedPassword"]!, userResult["salt"]!);
        if(isValidCredentials)
        {
          emit (UserState(users: const [], currentUser: UserDataModel.fromDictionary(userResult), isLoading: true, isAuthenticated: true, errorMessage: ""));
        }
        else
        {
          emit (const UserState(users: [], currentUser: null, isLoading: false, isAuthenticated: false, errorMessage: "Incorrect username or password."));
        }
      }
      else
      {
        emit (const UserState(users: [], currentUser: null, isLoading: false, isAuthenticated: false, errorMessage: "Incorrect username or password."));
      }
    });
    on<LogoffUser>((event, emit) async
    {
      emit (const UserState(users: [], currentUser: null, isLoading: false, isAuthenticated: false, errorMessage: ""));
    });
    on<GetCurrentUserData> ((event, emit) async
    {
      try
      {
        String? newWhereClause;
        List<dynamic> newWhereArgs;
        //If logging in with a username:
        if(!event.userData.UserName!.contains("@"))
        {
          newWhereClause = "userName = ? AND password = ?";
          //email address is null, so we use a placeholder value
          newWhereArgs = [event.userData.UserName, event.userData.Password];
        }
        //Else if logging in with an email address:
        else
        {
          String emailAddress = event.userData.UserName!;
          newWhereClause = "emailAddress = ? AND password = ?";
          newWhereArgs = [emailAddress, event.userData.Password];
        }
        if(newWhereClause.isNotEmpty)
        {
        final currentUserData = await _dbHelper.ReadSingleEntry(dbName, tableName, newWhereClause, newWhereArgs);
        //Emit a new state with the current data
        log(UserDataModel.fromDictionary(currentUserData!).toString());
        //Default emit with isAuthenticated set false 
        emit(UserState(users: const [], currentUser: UserDataModel.fromDictionary(currentUserData), isLoading: false, isAuthenticated: false, errorMessage: ""));
        }
        else
        {
          emit(const UserState(users: [],currentUser: null ,isLoading: false, isAuthenticated: false, errorMessage: "No where clause provided."));
        }
      }
      catch(ex)
      {
        log("Exception occurred attempting to get current user data: $ex");
      }
    });
    on<GetUsersData>((event, emit) async
    {
      final currentUserData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
      //Emit a new state with the current data
      emit(UserState(users: currentUserData?.map((item) => UserDataModel.fromDictionary(item)).toList() ?? [], currentUser: null, isLoading: false, isAuthenticated: false, errorMessage: ""));
    });
  }
}