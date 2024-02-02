import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/notification_service.dart';


import 'utils/class/Theme.dart';
import 'views/sign_In_page.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "SaudeConecta",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
        ? ThemeMode.dark
        : ThemeMode.light,
      home: const SignInPage()
    );
  }
}







