import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: SideMenu(selectedIndex: 1))),
    );
  }
}

class SideMenu extends StatelessWidget {
  final int selectedIndex;

  const SideMenu({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideafy'), centerTitle: false),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserProfileTile(),
          const Divider(),
          _buildMenuItem(
            context,
            index: 0,
            title: 'Ideas',
            icon: Icons.lightbulb_outline,
            onTap: () {
              //               if (selectedIndex != 0) context.go('/');
            },
          ),
          const Divider(height: 1),
          const SectionHeader(title: 'Categories'),
          _buildMenuItem(
            context,
            index: -1,
            title: 'Work',
            icon: Icons.work_outline,
            onTap: () {},
            count: 5,
          ),
          _buildMenuItem(
            context,
            index: -1,
            title: 'Personal',
            icon: Icons.person_outline,
            onTap: () {},
            count: 3,
          ),
          _buildMenuItem(
            context,
            index: -1,
            title: 'Project',
            icon: Icons.folder_open_outlined,
            onTap: () {},
            count: 8,
          ),
          const Divider(height: 1),
          const SectionHeader(title: 'Tags'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Important'),
                  selected: false,
                  onSelected: (selected) {},
                  avatar: const Icon(Icons.label, size: 16),
                ),
                FilterChip(
                  label: const Text('Urgent'),
                  selected: true,
                  onSelected: (selected) {},
                  avatar: const Icon(Icons.label, size: 16),
                ),
                FilterChip(
                  label: const Text('Research'),
                  selected: false,
                  onSelected: (selected) {},
                  avatar: const Icon(Icons.label, size: 16),
                ),
                FilterChip(
                  label: const Text('Creative'),
                  selected: false,
                  onSelected: (selected) {},
                  avatar: const Icon(Icons.label, size: 16),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            context,
            index: 1,
            title: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () {
              //               if (selectedIndex != 1) context.go('/settings');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    int? count,
  }) {
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    return Material(
      color:
          isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: count != null ? Chip(label: Text('$count')) : null,
        selected: isSelected,
        onTap: onTap,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, you'd get this from user repository
    const String name = 'John Doe';
    const String email = 'john.doe@example.com';

    // Toggle theme callback
    //     final themeMode = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Text('JD'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          //           IconButton(
          //             icon: Icon(
          //               themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          //             ),
          //             onPressed: () {
          //               final newThemeMode =
          //                   themeMode == ThemeMode.dark
          //                       ? ThemeMode.light
          //                       : ThemeMode.dark;
          //               ref.read(themeModeProvider.notifier).state = newThemeMode;
          //             },
          //           ),
        ],
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({Key? key}) : super(key: key);

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _notes = [
    'This is a sample note with some important details about the idea.',
    'Remember to check if this concept already exists in the market.',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          hintText: 'Add a note...',
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      tooltip: 'Voice input',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voice input not implemented yet'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_noteController.text.isNotEmpty) {
                          setState(() {
                            _notes.insert(0, _noteController.text);
                            _noteController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: _notes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return NoteItem(
                note: _notes[index],
                onDelete: () {
                  setState(() {
                    _notes.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class NoteItem extends StatelessWidget {
  final String note;
  final VoidCallback onDelete;

  const NoteItem({Key? key, required this.note, required this.onDelete})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 16,
            child: Text('JD'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Just now',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(note),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
