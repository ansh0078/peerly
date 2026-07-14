
import 'package:peerly/features/notes/domain/notes_repository.dart';
import 'package:peerly/features/rooms/data/rooms_repository.dart';

import '../domain/dashboard_repository.dart';
import '../../../core/entities/peer.dart';
import '../../../core/entities/activity_feed_item.dart';
import '../../../core/transport/transport_repository.dart';


/// This is where the aggregation from the earlier diagram actually
/// happens. It depends on three OTHER features' domain interfaces
/// (never their data/ internals), plus core/transport for peers.
/// Nothing above this file needs to know that "recent activity" is
/// really two different features' data, merged and sorted here.
class DashboardRepositoryImpl implements DashboardRepository {
  final TransportRepository transport;
  final NotesRepository notes;
  final RoomsRepository rooms;

  DashboardRepositoryImpl({
    required this.transport,
    required this.notes,
    required this.rooms,
  });

  @override
  Stream<List<DiscoveredPeer>> watchNearbyPeers() => transport.watchNearbyPeers();

  @override
  Future<List<ActivityFeedItem>> getActivityFeed() async {
    final results = await Future.wait([
      notes.getRecentShares(),
      rooms.getRecentAnnouncements(),
    ]);
    final combined = [...results[0], ...results[1]];
    combined.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return combined;
  }
}
