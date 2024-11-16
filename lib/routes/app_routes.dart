part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SCANNER = _Paths.SCANNER;
  static const USER = _Paths.USER;
  static const SETTINGS = _Paths.SETTINGS;
  static const WARRANTY = _Paths.WARRANTY;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const LOGIN = _Paths.LOGIN;

}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/dashboard';
  static const SCANNER = '/scanner';
  static const USER = '/user';
  static const SETTINGS = '/settings';
  static const WARRANTY = '/warranty';
  static const NOTIFICATION = '/notification';
}
