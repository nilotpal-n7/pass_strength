import 'package:flutter/material.dart';
import 'package:pass_strength/components/toast_wrapper.dart';
import 'package:pass_strength/pages/home_page.dart';
import 'package:pass_strength/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastWrapper(
      child: MaterialApp(
        title: 'Passify',
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
