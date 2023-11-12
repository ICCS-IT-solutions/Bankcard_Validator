// ignore_for_file: file_names

part of "UserBloc.dart";

@immutable
sealed class UserEvent{}

class RegisterNewUser extends UserEvent
{
  final UserDataModel userData;
  RegisterNewUser(this.userData);
}
class ResetPassword extends UserEvent
{
  final String newSalt;
  final String userName;
  final String newPassword;
  final String newHashedPassword;
  ResetPassword({required this.newPassword, required this.userName, required this.newHashedPassword, required this.newSalt});
}
class UpdateExistingUser extends UserEvent
{
  final UserDataModel userData;
  UpdateExistingUser(this.userData);
}

class DeleteUser extends UserEvent
{
  final UserDataModel userData;
  DeleteUser(this.userData);
}

class GetUsersData extends UserEvent
{
  final List<UserDataModel> users;
  GetUsersData(this.users);
}
//Could possibly use this event to handle logging users in.
class GetCurrentUserData extends UserEvent
{
  final UserDataModel userData;
  GetCurrentUserData(this.userData);
}
class LoginUser extends UserEvent
{
  final String userName;
  final String password;
  LoginUser(this.userName, this.password);
}
//Log off is only available if the user is logged in, so therefore it does not need any additional data.
//It simply needs to trigger a emitted state change with isAuthenticated = false.
class LogoffUser extends UserEvent
{
  LogoffUser();
}
