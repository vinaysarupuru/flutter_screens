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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, Color> _categoryColors = {
    'Work': Colors.blue,
    'Personal': Colors.green,
    'Education': Colors.purple,
    'Health': Colors.red,
    'Finance': Colors.amber,
  };
  final List<String> _selectedCategories = [];

  void _onCategoryChanged(List<String> categories) {
    setState(
      () =>
          _selectedCategories
            ..clear()
            ..addAll(categories),
    );
    print(_selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CategorySelector(
              categoryColors: _categoryColors,
              selectedCategories: _selectedCategories,
              onChanged: _onCategoryChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  final Map<String, Color> categoryColors;
  final List<String> selectedCategories;
  final Function(List<String>) onChanged;

  const CategorySelector({
    super.key,
    required this.categoryColors,
    required this.selectedCategories,
    required this.onChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedColor = '#4A6FFF';

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                ),
                const SizedBox(height: 16),
                ColorPicker(
                  selectedColor: _selectedColor,
                  onColorChanged:
                      (color) => setState(() => _selectedColor = color),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) return;
                  setState(() {
                    widget.categoryColors[_nameController.text
                        .trim()] = _getColorFromHex(_selectedColor);
                  });
                  _nameController.clear();
                  _selectedColor = '#4A6FFF';
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse('FF${hexColor.replaceAll('#', '')}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children:
              widget.categoryColors.keys.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: widget.selectedCategories.contains(category),
                  onSelected: (_) {
                    final updatedCategories = List<String>.from(
                      widget.selectedCategories,
                    );
                    updatedCategories.contains(category)
                        ? updatedCategories.remove(category)
                        : updatedCategories.add(category);
                    widget.onChanged(updatedCategories);
                  },
                  backgroundColor: widget.categoryColors[category]?.withOpacity(
                    0.1,
                  ),
                  selectedColor: widget.categoryColors[category]?.withOpacity(
                    0.3,
                  ),
                );
              }).toList(),
        ),
        TextButton.icon(
          onPressed: _showAddCategoryDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Category'),
        ),
      ],
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
    '#4A6FFF',
    '#4CAF50',
    '#F44336',
    '#9C27B0',
    '#FF9800',
    '#009688',
    '#795548',
    '#607D8B',
  ];

  Color _getColorFromHex(String hexColor) {
    return Color(int.parse('FF${hexColor.replaceAll('#', '')}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children:
          colorOptions.map((color) {
            return GestureDetector(
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
            );
          }).toList(),
    );
  }
}
