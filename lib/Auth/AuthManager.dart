// ignore_for_file: file_names, non_constant_identifier_names

import "dart:convert";
import "dart:math";
import "package:crypto/crypto.dart";

class AuthManager
{
static String HashPassword(String password, String salt)
  {
    final key = utf8.encode(password);
    final bytes = utf8.encode(salt);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }
  static bool ValidatePassword(String enteredPassword, String storedHash, String salt)
  {
    //Salt will come in via the stored value in the db, and the password entered by the user, then these will be compared
    final newHash = HashPassword(enteredPassword,salt);
    return newHash == storedHash;
  }
  static String GenerateSalt()
  {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64.encode(saltBytes);
  }
}