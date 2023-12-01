import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_machine_test/providers/theme_provider/theme_provider.dart';
import 'package:tentwenty_machine_test/screens/authentication_screens/launcher_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => LaunchProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => AuthProvider(),
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context)
            .currentTheme, // Use the custom theme from the ThemeModel
        home: const LaunchScreen());
  }
}
