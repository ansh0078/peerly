
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
  final TransportRepository _transport;
  final NotesRepository _notes;
  final RoomsRepository _rooms;

  DashboardRepositoryImpl({
    required TransportRepository transport,
    required NotesRepository notes,
    required RoomsRepository rooms,
  })  : _transport = transport,
        _notes = notes,
        _rooms = rooms;

  @override
  Stream<List<DiscoveredPeer>> watchNearbyPeers() => _transport.watchNearbyPeers();

  @override
  Future<List<ActivityFeedItem>> getActivityFeed() async {
    final results = await Future.wait([
      _notes.getRecentShares(),
      _rooms.getRecentAnnouncements(),
    ]);
    final combined = [...results[0], ...results[1]];
    combined.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return combined;
  }
}
