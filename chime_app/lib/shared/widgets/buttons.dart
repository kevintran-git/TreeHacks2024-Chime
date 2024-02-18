import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

Color hexToColor(String hexString) {
  // Add leading 'FF' for the alpha value if the string doesn't contain it
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String backgroundColor;
  final String textColor;

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = '521FE9', // default color if not specified
    this.textColor = '#FFFFFF', // default text color if not specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: hexToColor(backgroundColor),
        foregroundColor: hexToColor(textColor),
        padding: const EdgeInsets.symmetric( vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        // style: GoogleFonts.workSans(
        //     fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

class ButtonLight extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String backgroundColor;
  final String textColor;

  const ButtonLight({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = "#FFFFFF", // default color if not specified
    this.textColor = "#FFFFFF", // default text color if not specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: hexToColor(backgroundColor),
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric( vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium,
        // style: GoogleFonts.workSans(
        //     fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
