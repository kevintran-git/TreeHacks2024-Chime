import 'package:chime_app/intro_screen.dart';
import 'package:flutter/material.dart';
// import './shared/widgets/buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:chime_app/language_level_model.dart';
import 'package:chime_app/language_selection_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageLevelModel()),
        ChangeNotifierProvider(create: (context) => LanguageSelectionModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: const Color(0xFF3A00E5),
            secondary: const Color(0xFFFAFAFA),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onError: Colors.black,
            brightness: Brightness
                .light, // Add this line/ A darker version of the secondary color
            surface: Colors.grey[200]!, // Background color for widgets
            background: Colors.white, // Background color for the MaterialApp
            error: Colors.red, // Color to use for input validation errors
            onSurface: Colors
                .black, // A color that's clearly legible when drawn on 'surface'
            onBackground: Colors
                .black, // A color that's clearly legible when drawn on 'background'
          ), // A color that's clearly legible when drawn on 'error'
          useMaterial3: true,
          textTheme: TextTheme(
            titleLarge: GoogleFonts.workSans(
              fontSize: 30,
              fontStyle: FontStyle.normal,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            bodyMedium: GoogleFonts.workSans(
              fontSize: 18,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            bodySmall: GoogleFonts.workSans(
              fontSize: 16,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            displaySmall: GoogleFonts.workSans(
              fontSize: 16,
            ),
            displayMedium: GoogleFonts.workSans(
              fontSize: 18,
              color: const Color(0xFF3A00E5),
            ),
            displayLarge: GoogleFonts.workSans(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        home: const IntroScreen()
        //const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}
