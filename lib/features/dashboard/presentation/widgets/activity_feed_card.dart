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
    final isNote = item.type == ActivityType.noteShared;
    final accentColor = isNote ? const Color(0xFF4F46E5) : const Color(0xFF0F6E56);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(item.subtitle, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
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
