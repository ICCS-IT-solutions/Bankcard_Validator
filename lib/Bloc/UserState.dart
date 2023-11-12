// ignore_for_file: file_names

part of "UserBloc.dart";

@immutable
class UserState
{
  final List<UserDataModel> users;
  final UserDataModel? currentUser;
  final bool isLoading;
  final bool isAuthenticated;
  final String errorMessage;

  const UserState({required this.users, required this.currentUser, required this.isLoading, required this.isAuthenticated, required this.errorMessage});

  factory UserState.initial()
  {
    return const UserState(
      users: [],
      currentUser: null,
      isLoading: false,
      isAuthenticated: false,
      errorMessage: ""
    );
  }

  factory UserState.loading()
  {
    return const UserState(
      users: [],
      currentUser: null,
      isLoading: true,
      isAuthenticated: false,
      errorMessage: ""
    );
  }

  factory UserState.success(List<UserDataModel> users, UserDataModel? currentUser)
  {
    return UserState(
      users: users,
      currentUser: currentUser,
      isLoading: false,
      isAuthenticated: true,
      errorMessage: ""
    );
  }

  factory UserState.error(String errorMessage)
  {
    return UserState(
      users: const [],
      currentUser: null,
      isLoading: false,
      isAuthenticated: false,
      errorMessage: errorMessage
    );
  }
}