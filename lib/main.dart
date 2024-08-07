import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/navigations/nav_bar.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';
import 'constants/location_stuff.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await determinePosition();
  NavigationService navigationService = NavigationService(router);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(navigationService),
        )
      ],
      child: MaterialApp.router(
        title: 'Tembea Kenya',
        themeMode: ThemeMode.dark,
        darkTheme: darkThemeData,
        theme: lightThemeData,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    ),
  );
}

class MainPage extends StatelessWidget {
  write() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/time.txt');
    await file.writeAsString('00:00:00\n00:00:00\n00:00:00');
  }

  const MainPage({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  ButtonStyle get raisedButtonStyle {
    var style = MainPage.themeNotifier.value == ThemeMode.light ? true : false;
    if (style) {
      return ElevatedButton.styleFrom(
        backgroundColor: ColorsUtil.secondaryColorLight,
        foregroundColor: ColorsUtil.textColorLight,
        minimumSize: const Size(279, 59),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    } else {
      return ElevatedButton.styleFrom(
        backgroundColor: ColorsUtil.secondaryColorDark,
        foregroundColor: ColorsUtil.textColorDark,
        minimumSize: const Size(279, 59),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    write();
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthController(NavigationService(router)).isAuthenticated(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data?['isAuthenticated'] == true) {
            if (snapshot.data?['isVerified'] == true) {
              return LayoutView(
                user: snapshot.data?['user'],
              );
            } else {
              return VerifyEmailView(
                  user: snapshot.data?['user'],
                  id: '',
                  params: null,
                  token: '');
            }
          } else {
            return const WelcomeView();
          }
        }
      },
    );
  }
}
