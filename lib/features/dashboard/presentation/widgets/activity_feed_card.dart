import 'package:flutter/material.dart';
import '../../../../core/entities/activity_feed_item.dart';

/// One card in the "Recent Activity" list. Doesn't know or care whether
/// the item came from Notes or Rooms -- that decision was already made
/// by DashboardRepositoryImpl before this widget ever saw the data.
class ActivityFeedCard extends StatelessWidget {
  const ActivityFeedCard({super.key, required this.item});

  final ActivityFeedItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNote = item.type == ActivityType.noteShared;
    final accentColor = isNote ? theme.colorScheme.primary : theme.colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(item.subtitle, style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 13)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () {},
              child: Text(item.actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
