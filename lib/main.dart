import 'package:dark_view/screens/splash.dart';
import 'package:dark_view/utils/app_colors.dart';
import 'package:dark_view/utils/app_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme: ThemeData(
        
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
      ),
      home: const SplashScreen()
    );
  }
}

