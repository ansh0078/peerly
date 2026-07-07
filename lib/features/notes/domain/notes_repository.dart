import '../../../core/entities/activity_feed_item.dart';

/// Public contract for the Notes feature. Dashboard depends on THIS,
/// never on NotesRepositoryImpl or anything inside features/notes/data.
/// That's what keeps Dashboard decoupled from how Notes actually stores
/// or fetches its data -- Notes could switch its storage entirely and
/// Dashboard would never need to change.
abstract class NotesRepository {
  Future<List<ActivityFeedItem>> getRecentShares();
}
