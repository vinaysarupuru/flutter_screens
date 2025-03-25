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
      home: Scaffold(body: Center(child: IdeaScreen())),
    );
  }
}

enum IdeaStatus { draft, inProgress, completed, abandoned }

enum IdeaPriority { low, medium, high }

class Idea {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final IdeaStatus status;
  final IdeaPriority priority;
  final List<String> tags;
  final bool isFavorite;
  final String userId;
  final String? imageUrl;
  final String? category;

  const Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.status = IdeaStatus.draft,
    this.priority = IdeaPriority.medium,
    this.tags = const [],
    this.isFavorite = false,
    required this.userId,
    this.imageUrl,
    this.category,
  });

  Idea copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    IdeaStatus? status,
    IdeaPriority? priority,
    List<String>? tags,
    bool? isFavorite,
    String? userId,
    String? imageUrl,
    String? category,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}

class IdeaCard extends StatelessWidget {
  final Idea idea;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              screenWidth < 400
                  ? _buildListTileView(
                    theme,
                    context,
                  ) // ListTile view for small screens
                  : _buildColumnView(
                    theme,
                    context,
                  ), // Column view for larger screens
        ),
      ),
    );
  }

  Widget _buildListTileView(ThemeData theme, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        idea.title,
        style: theme.textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          idea.description.isNotEmpty
              ? Text(
                idea.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
              : null,
      trailing: IconButton(
        onPressed: onToggleFavorite,
        icon: Icon(
          idea.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: idea.isFavorite ? Colors.red : null,
        ),
      ),
    );
  }

  Widget _buildColumnView(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                idea.title,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onToggleFavorite,
              icon: Icon(
                idea.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: idea.isFavorite ? Colors.red : null,
              ),
            ),
          ],
        ),
        if (idea.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            idea.description,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            _buildChip(
              context,
              idea.status.name,
              _getStatusColor(idea.status, theme),
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              idea.priority.name,
              _getPriorityColor(idea.priority, theme),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Created ${_formatDate(idea.createdAt)}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Color _getStatusColor(IdeaStatus status, ThemeData theme) {
    switch (status) {
      case IdeaStatus.draft:
        return Colors.grey;
      case IdeaStatus.inProgress:
        return theme.colorScheme.primary;
      case IdeaStatus.completed:
        return Colors.green;
      case IdeaStatus.abandoned:
        return Colors.red;
    }
  }

  Color _getPriorityColor(IdeaPriority priority, ThemeData theme) {
    switch (priority) {
      case IdeaPriority.low:
        return Colors.blue;
      case IdeaPriority.medium:
        return Colors.orange;
      case IdeaPriority.high:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hrs ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
// class IdeaCard extends StatelessWidget {
//   final Idea idea;
//   final VoidCallback onTap;
//   final VoidCallback onToggleFavorite;

//   const IdeaCard({
//     super.key,
//     required this.idea,
//     required this.onTap,
//     required this.onToggleFavorite,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
//             children: [
//               IntrinsicHeight(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         idea.title,
//                         style: theme.textTheme.titleLarge,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(
//                       width:
//                           40, // Constraint for the button to prevent overflow
//                       child: IconButton(
//                         onPressed: onToggleFavorite,
//                         icon: Icon(
//                           idea.isFavorite
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: idea.isFavorite ? Colors.red : null,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (idea.description.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   idea.description,
//                   style: theme.textTheme.bodyMedium,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//               const SizedBox(height: 16),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   _buildChip(
//                     context,
//                     idea.status.name,
//                     _getStatusColor(idea.status, theme),
//                   ),
//                   _buildChip(
//                     context,
//                     idea.priority.name,
//                     _getPriorityColor(idea.priority, theme),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Created ${_formatDate(idea.createdAt)}',
//                 style: theme.textTheme.bodySmall,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChip(BuildContext context, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color),
//       ),
//       child: Text(label, style: TextStyle(color: color, fontSize: 12)),
//     );
//   }

//   Color _getStatusColor(IdeaStatus status, ThemeData theme) {
//     switch (status) {
//       case IdeaStatus.draft:
//         return Colors.grey;
//       case IdeaStatus.inProgress:
//         return theme.colorScheme.primary;
//       case IdeaStatus.completed:
//         return Colors.green;
//       case IdeaStatus.abandoned:
//         return Colors.red;
//     }
//   }

//   Color _getPriorityColor(IdeaPriority priority, ThemeData theme) {
//     switch (priority) {
//       case IdeaPriority.low:
//         return Colors.blue;
//       case IdeaPriority.medium:
//         return Colors.orange;
//       case IdeaPriority.high:
//         return Colors.red;
//     }
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays < 1) {
//       if (difference.inHours < 1) {
//         return '${difference.inMinutes} min ago';
//       }
//       return '${difference.inHours} hrs ago';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
// }

class IdeaScreen extends StatelessWidget {
  final List<Idea> ideas = List.generate(
    10,
    (index) => Idea(
      id: 'idea_$index',
      title: 'Idea Title $index',
      description: 'This is a description of idea $index.',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
      status: IdeaStatus.values[index % 4],
      priority: IdeaPriority.values[index % 3],
      userId: 'user_$index',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: constraints.maxWidth > 600 ? 400 : 600,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: ideas.length,
              itemBuilder: (context, index) {
                return IdeaCard(
                  idea: ideas[index],
                  onTap: () {},
                  onToggleFavorite: () {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
