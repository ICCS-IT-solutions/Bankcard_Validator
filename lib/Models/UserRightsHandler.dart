// ignore_for_file: file_names, non_constant_identifier_names

import 'UserDataModel.dart';

class UserRightsHandler
{
  static List<UserRight> GetUserRights(Role role)
  {
    //Using sql-style names for these values:
    //Rights: register_card, register_country ,view_cards, view_countries, register_user, view_users, ban_country, ban_card, edit_ban_country, edit_ban_card
    switch(role)
    {
      case Role.Administrator:
        return _AdminRights();
      case Role.Manager:
        return _ManagerRights();
      case Role.User:
        return _UserRights();
      case Role.Guest:
        return _GuestRights();
      default:
        return [];
    }
  }
  static List<UserRight> _AdminRights()
  {
    return [
      UserRight.createDatabase,
      UserRight.createTable,
      UserRight.setRootUsername,
      UserRight.setRootPassword,
      UserRight.createDbConnectionConfig,
      UserRight.editDbConnectionConfig,
      UserRight.registerCard,
      UserRight.registerCountry,
      UserRight.viewCards,
      UserRight.viewCountries,
      UserRight.registerUser,
      UserRight.resetPassword,
      UserRight.viewUsers,
      UserRight.banCountry,
      UserRight.banCard,
      UserRight.banUser,
      UserRight.editBanCountry,
      UserRight.editBanCard,
      UserRight.editBanUser
    ];
  }
  static List<UserRight> _ManagerRights()
  {
    return [
      UserRight.viewCards,
      UserRight.viewCountries,
      UserRight.registerCard,
      UserRight.registerCountry,
      UserRight.registerUser,
      UserRight.viewUsers,
      UserRight.banCard,
      UserRight.banCountry      
    ];
  }
  static List<UserRight> _UserRights()
  {
    return [
      UserRight.viewCards,
      UserRight.viewCountries,
      UserRight.registerCard,
      UserRight.registerCountry
    ];
  }
  static List<UserRight> _GuestRights()
  {
    return [
      UserRight.viewCards,
      UserRight.viewCountries
    ];
  }
  static bool ValidateRoleRights(Role role, List<UserRight> rights)
  {
    final expectedUserRights = GetUserRights(role);
    return expectedUserRights.every(rights.contains) && expectedUserRights.length == rights.length;
  }
}