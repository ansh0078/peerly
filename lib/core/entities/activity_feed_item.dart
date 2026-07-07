/// Represents one row in the Dashboard's "Recent Activity" feed.
/// This entity is intentionally generic -- it doesn't know or care
/// whether it came from Notes or Rooms. That's the point: Dashboard
/// only ever handles ONE shape of data, no matter how many features
/// feed it.
library;

enum ActivityType { noteShared, roomAnnouncement }

class ActivityFeedItem {
  final String id;
  final ActivityType type;
  final String title; // e.g. "Alex shared Calculus_Notes.pdf"
  final String subtitle; // e.g. the quoted message or detail line
  final DateTime timestamp;
  final String actionLabel; // e.g. "Download" or "View Group"

  const ActivityFeedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.actionLabel,
  });
}
