import 'package:flutter/material.dart';
enum Priority { low, medium, high, critical }


class PriorityDropdown extends StatelessWidget {
  final Priority? value;
  final ValueChanged<Priority?> onChanged;
  final String? label;
  final bool showLabel;

  const PriorityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showLabel) ...[
          Text(
            label ?? "Filter by priority:",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButton<Priority?>(
              value: value,
              underline: const SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(8),
              isExpanded: true,
              hint: Text(
                'Select Priority',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              items: [
                DropdownMenuItem<Priority?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ...Priority.values.map(_buildPriorityItem).toList(),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<Priority> _buildPriorityItem(Priority priority) {
    Color priorityColor;
    IconData priorityIcon;

    switch (priority) {
      case Priority.critical:
        priorityColor = Colors.red.shade700;
        priorityIcon = Icons.warning_rounded;
        break;
      case Priority.high:
        priorityColor = Colors.orange.shade700;
        priorityIcon = Icons.arrow_upward;
        break;
      case Priority.medium:
        priorityColor = Colors.blue.shade700;
        priorityIcon = Icons.remove;
        break;
      case Priority.low:
        priorityColor = Colors.green.shade700;
        priorityIcon = Icons.arrow_downward;
        break;
    }

    return DropdownMenuItem<Priority>(
      value: priority,
      child: Row(
        children: [
          Icon(priorityIcon, size: 18, color: priorityColor),
          const SizedBox(width: 8),
          Text(
            priority.name[0].toUpperCase() + priority.name.substring(1),
            style: TextStyle(color: priorityColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
