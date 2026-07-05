import '../domain/notes_repository.dart';
import '../../../core/entities/activity_feed_item.dart';

/// Stand-in implementation. A real version would query Isar for notes
/// shared in the last N hours and map each one to an ActivityFeedItem.
class NotesRepositoryImpl implements NotesRepository {
  @override
  Future<List<ActivityFeedItem>> getRecentShares() async {
    return [
      ActivityFeedItem(
        id: 'note-1',
        type: ActivityType.noteShared,
        title: 'Alex shared Calculus_Notes.pdf',
        subtitle:
            "Hey guys, here are the scanned notes from today's lecture. Hope it helps.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        actionLabel: 'Download',
      ),
    ];
  }
}
