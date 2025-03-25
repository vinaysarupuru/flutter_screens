import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ColorPicker(
            selectedColor: "#4A6FFF",
            onColorChanged: (s) {
              print(s);
            },
          ),
        ),
      ),
    );
  }
}

class ColorPicker extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorChanged;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
  });

  static const List<String> colorOptions = [
    '#4A6FFF', // Blue
    '#4CAF50', // Green
    '#F44336', // Red
    '#9C27B0', // Purple
    '#FF9800', // Orange
    '#009688', // Teal
    '#795548', // Brown
    '#607D8B', // Grey Blue
  ];

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            for (final color in colorOptions)
              GestureDetector(
                onTap: () => onColorChanged(color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _getColorFromHex(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          color == selectedColor
                              ? Colors.black
                              : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child:
                      color == selectedColor
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
