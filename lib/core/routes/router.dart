import 'package:auto_route/auto_route.dart';
import 'package:quotes_app/core/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignUpRoute.page, path: '/', initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: QuoteRoute.page),
        AutoRoute(page: CreateQuoteRoute.page),
        AutoRoute(page: AdminQuoteListRoute.page),
      ];
}
