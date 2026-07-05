import '../domain/rooms_repository.dart';
import '../../../core/entities/activity_feed_item.dart';

class RoomsRepositoryImpl implements RoomsRepository {
  @override
  Future<List<ActivityFeedItem>> getRecentAnnouncements() async {
    return [
      ActivityFeedItem(
        id: 'room-1',
        type: ActivityType.roomAnnouncement,
        title: 'New announcement in CS101 Study Group',
        subtitle:
            'The midterm review session has been moved to Room 402 at 3 PM tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        actionLabel: 'View Group',
      ),
    ];
  }
}
