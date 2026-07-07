import '../../../core/entities/peer.dart';
import '../../../core/entities/activity_feed_item.dart';

/// This is the ONE thing DashboardController is allowed to talk to.
/// It never sees TransportRepository, NotesRepository, or
/// RoomsRepository directly -- combining those is
/// DashboardRepositoryImpl's job, not the ViewModel's.
abstract class DashboardRepository {
  Stream<List<DiscoveredPeer>> watchNearbyPeers();
  Future<List<ActivityFeedItem>> getActivityFeed();
}
