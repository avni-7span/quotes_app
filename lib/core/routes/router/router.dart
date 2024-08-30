import 'package:auto_route/auto_route.dart';
import 'package:quotes_app/core/routes/guard/auth_guard.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, guards: [AuthGuard()]),

        /// Auth Module
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: VerificationWaitingRoute.page),

        /// Quote Module
        AutoRoute(page: CreateQuoteRoute.page),
        AutoRoute(page: AdminQuoteListRoute.page),
        AutoRoute(page: FavouriteQuoteRoute.page),
      ];
}
