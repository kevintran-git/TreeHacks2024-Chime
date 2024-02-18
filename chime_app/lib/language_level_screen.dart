import 'package:chime_app/prompt_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:chime_app/shared/widgets/buttons.dart';
import 'package:chime_app/shared/widgets/selectable.dart';
import 'package:provider/provider.dart';
import 'package:chime_app/language_level_model.dart';

class LanguageLevelScreen extends StatefulWidget {
  const LanguageLevelScreen({super.key});

  @override
  LanguageLevelScreenState createState() => LanguageLevelScreenState();
}

class LanguageLevelScreenState extends State<LanguageLevelScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    // Created a list of language levels to simplify option button
    final levels = ['Beginner', 'Elementary', 'Intermediate', 'Advanced'];

    return Scaffold(
      appBar: AppBar(
          title: null,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.pop(context); // Updated to navigate back a page
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      "What is your language level?",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 35),
                  ...levels
                      .map((level) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SelectableItem(
                              title: level,
                              isSelected: _selectedLevel == level,
                              onTap: () {
                                final model = Provider.of<LanguageLevelModel>(
                                    context,
                                    listen: false);
                                model.setLanguageLevel(level);
                                setState(() => _selectedLevel = level);
                              },
                            ),
                          ))
                      .toList(),
                ],
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
                      if (_selectedLevel != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PromptSelectionScreen(),
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
