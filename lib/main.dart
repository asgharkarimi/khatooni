import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khatooni/addcar_form.dart';
import 'package:khatooni/addcargo_form.dart';
import 'package:khatooni/addcustomer_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ثبت راننده',
      theme: ThemeData(
        fontFamily: 'Vazir', // تنظیم فونت به Vazir
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // تنظیم زبان به فارسی و جهت نوشت به RTL
      locale: const Locale('fa', 'IR'), // زبان فارسی
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // پشتیبانی از زبان فارسی
      ],
      home: Directionality( // تنظیم جهت نوشت به RTL
        textDirection: TextDirection.rtl,
        child: AddCustomerForm(),
      ),
    );
  }
}

// echo "# khatooni" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/asgharkarimi/khatooni.git
// git push -u origin main