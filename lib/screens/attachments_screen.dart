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
      home: Scaffold(body: Center(child: AttachmentPicker())),
    );
  }
}

class AttachmentPicker extends StatefulWidget {
  const AttachmentPicker({Key? key}) : super(key: key);

  @override
  State<AttachmentPicker> createState() => _AttachmentPickerState();
}

class _AttachmentPickerState extends State<AttachmentPicker> {
  final List<Map<String, dynamic>> _attachments = [
    {
      'name': 'market_research.pdf',
      'type': 'pdf',
      'size': '2.3 MB',
      'date': 'Today',
    },
    {
      'name': 'concept_design.jpg',
      'type': 'image',
      'size': '1.7 MB',
      'date': 'Yesterday',
    },
    {
      'name': 'https://example.com/reference',
      'type': 'link',
      'date': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.link),
                  tooltip: 'Add link',
                  onPressed: () {
                    _showAddLinkDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  tooltip: 'Attach file',
                  onPressed: () {
                    _showAttachmentOptions();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._attachments.map(
          (attachment) => AttachmentItem(
            attachment: attachment,
            onDelete: () {
              setState(() {
                _attachments.remove(attachment);
              });
            },
          ),
        ),
        if (_attachments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text('No attachments yet'),
            ),
          ),
      ],
    );
  }

  void _showAddLinkDialog() {
    final TextEditingController linkController = TextEditingController();
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Link'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (linkController.text.isNotEmpty) {
                    setState(() {
                      _attachments.add({
                        'name': linkController.text,
                        'title':
                            titleController.text.isNotEmpty
                                ? titleController.text
                                : null,
                        'type': 'link',
                        'date': 'Just now',
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement gallery picker
                    _mockAddAttachment('image');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement camera capture
                    _mockAddAttachment('image');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Document'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement document picker
                    _mockAddAttachment('pdf');
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Mock function to simulate adding attachments
  void _mockAddAttachment(String type) {
    setState(() {
      _attachments.add({
        'name':
            type == 'image'
                ? 'photo_${_attachments.length + 1}.jpg'
                : 'document_${_attachments.length + 1}.pdf',
        'type': type,
        'size': '3.2 MB',
        'date': 'Just now',
      });
    });
  }
}

class AttachmentItem extends StatelessWidget {
  final Map<String, dynamic> attachment;
  final VoidCallback onDelete;

  const AttachmentItem({
    Key? key,
    required this.attachment,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          attachment['title'] ?? attachment['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle:
            attachment['type'] != 'link'
                ? Text('${attachment['size']} · ${attachment['date']}')
                : Text(attachment['date']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                // Open attachment
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    switch (attachment['type']) {
      case 'pdf':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.picture_as_pdf, color: Colors.red),
        );
      case 'image':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.image, color: Colors.blue),
        );
      case 'link':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.link, color: Colors.green),
        );
      default:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.insert_drive_file, color: Colors.grey),
        );
    }
  }
}
