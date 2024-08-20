// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:quotes_app/modules/admin-quote-list/screens/admin_quote_list_screen.dart'
    as _i1;
import 'package:quotes_app/modules/create-quote/screens/create_quote_screen.dart'
    as _i2;
import 'package:quotes_app/modules/login/screens/login_screen.dart' as _i3;
import 'package:quotes_app/modules/quotes/screens/quote_screen.dart' as _i4;
import 'package:quotes_app/modules/sign-up/screens/sign_up_screen.dart' as _i5;
import 'package:quotes_app/splash_screen.dart' as _i6;

/// generated route for
/// [_i1.AdminQuoteListScreen]
class AdminQuoteListRoute extends _i7.PageRouteInfo<void> {
  const AdminQuoteListRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AdminQuoteListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminQuoteListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminQuoteListScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateQuoteScreen]
class CreateQuoteRoute extends _i7.PageRouteInfo<void> {
  const CreateQuoteRoute({List<_i7.PageRouteInfo>? children})
      : super(
          CreateQuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateQuoteRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateQuoteScreen();
    },
  );
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.QuoteScreen]
class QuoteRoute extends _i7.PageRouteInfo<void> {
  const QuoteRoute({List<_i7.PageRouteInfo>? children})
      : super(
          QuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.QuoteScreen();
    },
  );
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i6.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SplashScreen();
    },
  );
}
