import '../../../core/entities/activity_feed_item.dart';

/// Same pattern as NotesRepository -- Dashboard (or anything else) only
/// ever sees this interface, never the Rooms feature's internals.
abstract class RoomsRepository {
  Future<List<ActivityFeedItem>> getRecentAnnouncements();
}
