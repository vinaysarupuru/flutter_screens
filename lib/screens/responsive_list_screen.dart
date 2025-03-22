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
      home: Scaffold(body: Center(child: IdeaList())),
    );
  }
}

class IdeaList extends StatelessWidget {
  const IdeaList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. In a real app, you would fetch data from a repository
    final ideas = List.generate(
      20,
      (index) => {
        'id': 'idea-$index',
        'title': 'Idea ${index + 1}',
        'description': 'This is a description for idea ${index + 1}',
        'category':
            index % 3 == 0 ? 'Work' : (index % 3 == 1 ? 'Personal' : 'Project'),
        'priority':
            index % 3 == 0 ? 'High' : (index % 3 == 1 ? 'Medium' : 'Low'),
        'status':
            index % 4 == 0
                ? 'Draft'
                : (index % 4 == 1
                    ? 'In Progress'
                    : (index % 4 == 2 ? 'Completed' : 'Abandoned')),
        'isFavorite': index % 5 == 0,
      },
    );

    return Responsive.responsiveBuilder(
      context: context,
      // Mobile and Tablet: Single list view
      mobile: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ideas.length,
        itemBuilder: (context, index) {
          final idea = ideas[index];
          return IdeaCard(
            idea: idea,
            //             onTap: () => .push('/idea/${idea['id']}'),
          );
        },
      ),
      // Desktop: Grid view for better space utilization
      desktop: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: ideas.length,
        itemBuilder: (context, index) {
          final idea = ideas[index];
          return IdeaCard(
            idea: idea,
            //             onTap: () => context.push('/idea/${idea['id']}'),
          );
        },
      ),
    );
  }
}

class IdeaCard extends StatelessWidget {
  final Map<String, dynamic> idea;

  const IdeaCard({Key? key, required this.idea}) : super(key: key);

  Color _getPriorityColor() {
    switch (idea['priority']) {
      case 'High':
        return Colors.red[100]!;
      case 'Medium':
        return Colors.orange[100]!;
      case 'Low':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Icon _getStatusIcon() {
    switch (idea['status']) {
      case 'Draft':
        return Icon(Icons.edit_note, color: Colors.grey[600]);
      case 'In Progress':
        return Icon(Icons.pending_actions, color: Colors.blue[600]);
      case 'Completed':
        return Icon(Icons.check_circle, color: Colors.green[600]);
      case 'Abandoned':
        return Icon(Icons.cancel, color: Colors.red[600]);
      default:
        return Icon(Icons.circle, color: Colors.grey[600]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      idea['title'],
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (idea['isFavorite'])
                    const Icon(Icons.star, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                idea['description'],
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      idea['priority'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      idea['category'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Spacer(),
                  _getStatusIcon(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
