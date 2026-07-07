import '../entities/peer.dart';

/// The single interface every ViewModel talks to for "who's nearby" and
/// "are we connected." The real implementation (not shown here) wraps
/// flutter_nearby_connections + mDNS + your backend relay, exactly as
/// laid out in the architecture doc. This mock exists so the Dashboard
/// example below runs standalone, with no real hardware required.
abstract class TransportRepository {
  Stream<List<DiscoveredPeer>> watchNearbyPeers();
  Stream<bool> watchMeshActive();
}

class MockTransportRepository implements TransportRepository {
  @override
  Stream<List<DiscoveredPeer>> watchNearbyPeers() async* {
    // Emits once immediately, mimicking "peers already found on screen load."
    yield const [
      DiscoveredPeer(
        id: 'p1',
        name: 'Alex Chen',
        department: 'Computer Science',
        tier: TransportTier.nearby,
      ),
      DiscoveredPeer(
        id: 'p2',
        name: 'Marcus Thorne',
        department: 'Design Dept',
        tier: TransportTier.localLan,
      ),
    ];
  }

  @override
  Stream<bool> watchMeshActive() async* {
    yield true;
  }
}
