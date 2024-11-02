import 'package:ayni_flutter_app/feature_iam/login_screens/splash_screen.dart';
import 'package:ayni_flutter_app/firebase_options.dart';
import 'package:ayni_flutter_app/home_screens/screens/products_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayni App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      //home: ProductsListScreen()
    );
  }
}
