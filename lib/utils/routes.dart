import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/sign_In_page.dart';

import '../views/homePage.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/login': (_) => const SignInPage(),
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}