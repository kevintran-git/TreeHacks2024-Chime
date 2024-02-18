import 'package:chime_app/language_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:chime_app/shared/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:chime_app/language_selection_model.dart';
import 'package:chime_app/shared/widgets/dropdown.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _nativeLanguage;
  String? _learningLanguage;

  // Example languages list
  final List<String> languages = [
    'Chinese',
    'English',
    'French',
    'German',
    'Hindi',
    'Italian',
    'Norwegian',
    'Thai',
    'Spanish',
    'Vietnamese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose your native language:",
                style: Theme.of(context).textTheme.titleLarge),
            CustomDropdownButton(
              value: _nativeLanguage,
              items: languages,
              hint: 'Select Native Language',
              onChanged: (newValue) {
                setState(() {
                  _nativeLanguage = newValue;
                });
                Provider.of<LanguageSelectionModel>(context, listen: false)
                    .setNativeLanguage(newValue);
              },
            ),
            Text("Choose the language you want to learn:",
                style: Theme.of(context).textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomDropdownButton(
                value: _learningLanguage,
                items: languages,
                hint: 'Select Learning Language',
                onChanged: (newValue) {
                  setState(() {
                    _learningLanguage = newValue;
                  });
                  Provider.of<LanguageSelectionModel>(context, listen: false)
                      .setLearningLanguage(newValue);
                },
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: Button(
                    text: 'Next',
                    onPressed: () {
                      if (_learningLanguage != null &&
                          _nativeLanguage != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageLevelScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
