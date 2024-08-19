// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:quotes_app/modules/admin_quote_list/screens/admin_quote_list_screen.dart'
    as _i1;
import 'package:quotes_app/modules/create_quote/screens/create_quote_screen.dart'
    as _i2;
import 'package:quotes_app/modules/login/screens/login_screen.dart' as _i3;
import 'package:quotes_app/modules/quotes/screens/quote_screen.dart' as _i4;
import 'package:quotes_app/modules/sign_up/screens/sign_up_screen.dart' as _i5;

/// generated route for
/// [_i1.AdminQuoteListScreen]
class AdminQuoteListRoute extends _i6.PageRouteInfo<void> {
  const AdminQuoteListRoute({List<_i6.PageRouteInfo>? children})
      : super(
          AdminQuoteListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminQuoteListRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminQuoteListScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateQuoteScreen]
class CreateQuoteRoute extends _i6.PageRouteInfo<void> {
  const CreateQuoteRoute({List<_i6.PageRouteInfo>? children})
      : super(
          CreateQuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateQuoteRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateQuoteScreen();
    },
  );
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.QuoteScreen]
class QuoteRoute extends _i6.PageRouteInfo<void> {
  const QuoteRoute({List<_i6.PageRouteInfo>? children})
      : super(
          QuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.QuoteScreen();
    },
  );
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpScreen();
    },
  );
}
