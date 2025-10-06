// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'Splash/inital.dart';
void main() async {
  await Hive.initFlutter();
  await Hive.openBox("LocalDB");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'LANGGG',
          theme: ThemeData(
              fontFamily: 'Ubuntu',
              colorScheme: lightDynamic,
              useMaterial3: true),
          darkTheme: ThemeData(
              fontFamily: 'Ubuntu',
              colorScheme: darkDynamic,
              brightness: Brightness.dark,
              useMaterial3: true),
          debugShowCheckedModeBanner: false,
          home: Splash(
            dync: lightDynamic!,
          ),
        );
      },
    );
  }
}

class Splash extends StatefulWidget {
  late ColorScheme dync;
  Splash({super.key, required this.dync});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(
                dync: widget.dync,
              )));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => InitPage(
                dync: widget.dync,
              )));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.tertiaryContainer,
      body: const Center(child: Text("🐼 🐼 🐼")),
    );
  }
}
