import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
}

class SelectableItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  // Generating errors "private type in public API"
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem> {
  @override
  Widget build(BuildContext context) {
    // GestureDetector wraps the item's container to handle tap events
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 350),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.isSelected
                  ? hexToColor('#521FE9')
                  : hexToColor('#61646B')),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Added to move the icon to the other side
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: widget.isSelected
                    ? hexToColor('#521FE9')
                    : hexToColor('#61646B'),
                fontSize: 18.0,
              ),
            ),
            if (widget
                .isSelected) // Only show check icon if the item is selected
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0), // Changed to right padding
                child: Icon(Icons.check, color: hexToColor('#521FE9')),
              ),
          ],
        ),
      ),
    );
  }
}
