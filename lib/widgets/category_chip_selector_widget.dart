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
      home: Scaffold(body: Center(child: CategoryScreen())),
    );
  }
}

// Assuming CategoryChip is defined as per your provided code
class CategoryChip extends StatelessWidget {
  final String category;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;

  const CategoryChip({
    Key? key,
    required this.category,
    required this.color,
    this.onTap,
    this.isSelected = false,
    this.showDeleteIcon = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color.withOpacity(0.3),
      checkmarkColor: color,
      deleteIcon: showDeleteIcon ? const Icon(Icons.cancel, size: 18) : null,
      onDeleted: showDeleteIcon ? onDelete : null,
    );
  }
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Sample list of categories
  final List<String> categories = [
    'Technology',
    'Health',
    'Finance',
    'Education',
    'Sports',
    'Technology',
    'Health',
    'Finance',
    'Education',
    'Sports',
    'Technology',
    'Health',
    'Finance',
    'Education',
    'Sports',
  ];
  // Set to keep track of selected categories
  final Set<String> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Categories')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          children:
              categories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return CategoryChip(
                  category: category,
                  color: Colors.blue,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCategories.remove(category);
                      } else {
                        selectedCategories.add(category);
                      }
                    });
                  },
                  showDeleteIcon: isSelected,
                  onDelete:
                      isSelected
                          ? () {
                            setState(() {
                              selectedCategories.remove(category);
                            });
                          }
                          : null,
                );
              }).toList(),
        ),
      ),
    );
  }
}
