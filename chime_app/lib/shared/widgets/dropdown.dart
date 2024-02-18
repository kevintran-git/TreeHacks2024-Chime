import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
}

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;
  final String backgroundColor; // Add backgroundColor
  final String textColor; // Add textColor

  const CustomDropdownButton({
    Key? key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint = '',
    this.backgroundColor = "#FFFFFF", // Default
    this.textColor = '#61646B', // Default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        fillColor: hexToColor(backgroundColor), // Apply backgroundColor
        filled: true,
      ),
      value: value,
      hint: Text(hint,
          style: TextStyle(
              color: hexToColor(textColor),
              fontSize: 18.0)), // Apply textColor to hint
      onChanged: (value) => onChanged(value),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: hexToColor(textColor))),
        );
      }).toList(),
      dropdownColor: hexToColor(backgroundColor),
      style: TextStyle(color: hexToColor(textColor), fontSize: 18.0),
    );
  }
}
