import "dart:async";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qarzsiz/store/app/app_store.dart';
import 'package:qarzsiz/utils/env.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/utils/network/dependency_injection.dart';
import 'package:qarzsiz/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:qarzsiz/utils/extensions.dart';
import 'package:qarzsiz/screens/splash/splash_screen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


const Color themeColor = Color(0xff00bc56);

String? packageVersion;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  
  runApp(const MainApp());
  
  DependencyInjection.init();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
}


class MainApp extends StatelessWidget {

  const MainApp({
    super.key,
  });

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: themeColor.swatch,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: themeColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GlobalState>(
      store: store,
      child:  RefreshConfiguration(
        child:
      MaterialApp(
        localizationsDelegates: const [
              RefreshLocalizations.delegate,
            ],
        onGenerateTitle: (context) => 'WeShot',
        theme: ThemeData(),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.init,
        routes: AppRoutes.getRoutes(),
        title: Environments.appName,
        debugShowCheckedModeBanner: Environments.showDebugBanner == "true",
        home: const SplashScreen(),
        builder: (BuildContext c, Widget? w) {
          return ScrollConfiguration(
            behavior: const NoGlowScrollBehavior(),
            child: w!,
          );
        },
      ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}


Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
}

