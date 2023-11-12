// ignore_for_file: file_names, non_constant_identifier_names, constant_identifier_names
import 'package:main/Auth/AuthManager.dart';

import 'UserRightsHandler.dart';

enum Role {Administrator, Manager, User, Guest}
enum UserRight {
  //Administrator-only:
  createDatabase,
  createTable,
  setRootUsername,
  setRootPassword,
  createDbConnectionConfig,
  editDbConnectionConfig,
  //App-specific:
  registerCard,
  registerCountry,
  viewCards,
  viewCountries,
  registerUser,
  resetPassword,
  viewUsers,
  banCountry,
  banCard,
  banUser,
  editBanCountry,
  editBanCard,
  editBanUser
}

class UserDataModel
{
  final String? UserName;
  final String? Password;
  final String? HashedPassword;
  final String? Salt;
  final String? EmailAddress;
  final Role? UserRole;
  final List<UserRight>? UserRights;
//Made these all nullable - reason: I want to handle logging users in with either their email address or username
UserDataModel({this.UserName, this.Password, this.HashedPassword, this.Salt, this.EmailAddress, this.UserRole, this.UserRights});
  //Factory -> Constructor
  factory UserDataModel.fromDictionary(Map<String,dynamic> dictionary)
  {
    return UserDataModel(
      UserName : dictionary["userName"],
      EmailAddress : dictionary["emailAddress"],
      Password : dictionary["password"],
      HashedPassword: dictionary["hashedPassword"],
      Salt: dictionary["salt"],
      UserRole : MapRoleNameToRole(dictionary["userRole"]),
      UserRights :[
        if(dictionary["userRight_createDatabase"] == 'Y') UserRight.createDatabase,
        if(dictionary["userRight_createTable"] == 'Y') UserRight.createTable,
        if(dictionary["userRight_setRootUsername"] == 'Y') UserRight.setRootUsername,
        if(dictionary["userRight_setRootPassword"] == 'Y') UserRight.setRootPassword,
        if(dictionary["userRight_createDbConnectionConfig"] == 'Y') UserRight.createDbConnectionConfig,
        if(dictionary["userRight_editDbConnectionConfig"] == 'Y') UserRight.editDbConnectionConfig,
        if(dictionary["userRight_registerCard"] == 'Y') UserRight.registerCard,
        if(dictionary["userRight_registerCountry"] == 'Y') UserRight.registerCountry,
        if(dictionary["userRight_viewCards"] == 'Y') UserRight.viewCards,
        if(dictionary["userRight_viewCountries"] == 'Y') UserRight.viewCountries,
        if(dictionary["userRight_registerUser"] == 'Y') UserRight.registerUser,
        if(dictionary["userRight_resetPassword"] == 'Y') UserRight.resetPassword,
        if(dictionary["userRight_viewUsers"] == 'Y') UserRight.viewUsers,
        if(dictionary["userRight_banCountry"] == 'Y') UserRight.banCountry,
        if(dictionary["userRight_banCard"] == 'Y') UserRight.banCard,
        if(dictionary["userRight_banUser"] == 'Y') UserRight.banUser,
        if(dictionary["userRight_editBanCountry"] == 'Y') UserRight.editBanCountry,
        if(dictionary["userRight_editBanCard"] == 'Y') UserRight.editBanCard,
        if(dictionary["userRight_editBanUser"] == 'Y') UserRight.editBanUser
      ]
    );
  }

  Map<String, dynamic> toDictionary() 
  {
    final salt = AuthManager.GenerateSalt();
    final userRightsMap = 
    {
      'userName': UserName,
      'emailAddress': EmailAddress,
      'password': Password,
      'hashedPassword': AuthManager.HashPassword(Password!, salt),
      'salt': salt,
      'userRole': MapRoleToRoleName(UserRole!)
    };
    final userRights = UserRightsHandler.GetUserRights(UserRole!);
    const rightsEnumValues = UserRight.values;
    for (final right in rightsEnumValues) 
    {
      final rightString = right.toString().split('.').last;
      userRightsMap['userRight_$rightString'] =
        userRights.contains(right) ? 'Y' : 'N';
    }
    return userRightsMap;
  }
}
Role? MapRoleNameToRole(String enumString)
{
  switch(enumString)
  {
    case "Administrator":
      return Role.Administrator;
    case "Manager":
      return Role.Manager;
    case "User":
      return Role.User;
    case "Guest":
      return Role.Guest;
    default:
      return null;
  }
}

String MapRoleToRoleName(Role role)
{
  switch(role)
  {
    case Role.Administrator:
      return "Administrator";
    case Role.Manager:
      return "Manager";
    case Role.User:
      return "User";
    case Role.Guest:
      return "Guest";
    default:
      return "";
  }
}