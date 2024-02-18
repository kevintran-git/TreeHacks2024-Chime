import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
}

class PromptTile extends StatefulWidget {
  final String titleText;
  final String subtitleText;
  final VoidCallback onTap;
  final bool isSelected;

  const PromptTile({
    Key? key,
    required this.titleText,
    required this.subtitleText,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  PromptTileState createState() => PromptTileState();
}

class PromptTileState extends State<PromptTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.titleText,
            style: TextStyle(
              color: widget.isSelected
                  ? hexToColor('#521FE9')
                  : hexToColor('#61646B'),
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxWidth: 350),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.isSelected
                      ? hexToColor('#521FE9')
                      : hexToColor('#61646B')),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.subtitleText,
              style: TextStyle(
                color: widget.isSelected
                    ? hexToColor('#521FE9')
                    : hexToColor('#61646B'),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ]),
      ),
    );
  }
}
