import 'package:flutter/material.dart';
import 'package:chime_app/shared/widgets/buttons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: null,
          leading: Container(), // Removed the leading back arrow button
          actions: [
            IconButton(
              icon: const Icon(Icons.close_outlined, size: 30),
              onPressed: () {
                Navigator.pop(context); // Updated to navigate back a page
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: 'Jane Doe',
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'janedoe@stanford.edu',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: 'Beginner',
                    decoration: const InputDecoration(
                      labelText: 'Language Level',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Beginner', 'Intermediate', 'Advanced', 'Expert']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Button(
                    text: 'Save changes',
                    onPressed: () {},
                    backgroundColor: "#FFFFFF",
                    textColor: "#000000",
                  ),
                  const SizedBox(height: 10),
                  Button(
                    text: 'Log out',
                    onPressed: () {},
                    backgroundColor: "#000000",
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
