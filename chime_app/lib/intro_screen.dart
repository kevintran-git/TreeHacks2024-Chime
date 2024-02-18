import 'package:chime_app/chat_screen.dart';
import 'package:chime_app/language_selection.dart';
import 'package:flutter/material.dart';
import 'package:chime_app/shared/widgets/buttons.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              // flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.values[1],
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LanguageSelectionScreen()),
                        );
                      },
                      child: SizedBox(
                        width: 150, // Adjust the size as needed
                        height: 150, // Adjust the size as needed
                        child: Image.asset(
                            'assets/logo.jpeg'), // Your logo graphic
                      ),
                    ),
                    const SizedBox(height: 30), // Adjust the size as needed
                    Text(
                      'Start talking to Chime.',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge, // Style the text as needed
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 20.0, right: 20.0),
                      child: Button(
                        text: 'Register',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LanguageSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 50, top: 20, left: 20.0, right: 20.0),
                      child: ButtonLight(
                        text: 'I already have an account',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatUI()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
