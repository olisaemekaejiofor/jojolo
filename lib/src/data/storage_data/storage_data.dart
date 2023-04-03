import 'package:jojolo_mobile/src/data/models/user_models.dart';

abstract class Storage {
  Future<bool> isAuthenticated();
  Future<bool> setAuthentication(AuthUser user);
  Future<String?> getToken();
  Future<String?> getId();
  Future<String?> getUserType();
  Future<String?> getRole();
  Future<String?> getName();
  void deleteToken();
}
