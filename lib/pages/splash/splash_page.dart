// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmdb/pages/landing_page.dart';
import '../../utils/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool isPasswordSaved = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedSplashScreen(
          backgroundColor: Colors.transparent,
          splash: 'assets/images/logo.png',
          splashIconSize: 200,
          nextScreen: const LandingPage(),
          /*nextScreen:
              isPasswordSaved ? const DeviceListPage() : const LoginPage(),*/
          duration: 3000,
          splashTransition: SplashTransition.sizeTransition,
          pageTransitionType: PageTransitionType.leftToRight,
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    if (await Permission.location.serviceStatus.isEnabled &&
        await Permission.storage.isGranted) {
    } else if (await Permission.location.serviceStatus.isDisabled &&
        await Permission.storage.isDenied) {
      await [
        Permission.storage,
        Permission.location,
      ].request();
    }
  }
}
