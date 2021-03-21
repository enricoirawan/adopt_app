import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/providers/user.dart';
import 'package:app_adopt/screens/adopt.dart';
import 'package:app_adopt/screens/detail.dart';
import 'package:app_adopt/screens/get_started.dart';
import 'package:app_adopt/screens/history.dart';
import 'package:app_adopt/screens/home.dart';
import 'package:app_adopt/screens/overview.dart';
import 'package:app_adopt/screens/profile.dart';
import 'package:app_adopt/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
        ChangeNotifierProxyProvider<User, Adopt>(
          create: null,
          update: (ctx, userData, _) {
            return Adopt(email: userData.email, token: userData.token);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Helena',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Ubuntu-Regular',
          canvasColor: Colors.transparent,
          primaryColor: Colors.black,
        ),
        home: SplashScreen(),
        routes: {
          SplashScreen.routeName: (ctx) => SplashScreen(),
          GetStartedScreen.routeName: (ctx) => GetStartedScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          DetailScreen.routeName: (ctx) => DetailScreen(),
          AdoptScreen.routeName: (ctx) => AdoptScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          OverviewScreen.routeName: (ctx) => OverviewScreen(),
          HistoryScreen.routeName: (ctx) => HistoryScreen(),
        },
      ),
    );
  }
}
