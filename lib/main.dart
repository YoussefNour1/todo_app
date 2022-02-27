import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/layout/home_layout.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.indigo,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).primaryTextTheme.apply(
          displayColor: Colors.black,
          bodyColor: Colors.black
        ))
      ),
      title: "TODO App",
      home: EasySplashScreen(
        logo: Image.asset("assets/images/icon.png"),
        navigator: HomeLayout(),
        backgroundColor: Colors.indigo,
        showLoader: true,
        logoSize: 80,
        loaderColor: Colors.white,
        durationInSeconds: 2,
        title: Text(
          "ToDo",
          style: GoogleFonts.courgette(
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
