import '../../../../core/entities/peer.dart';
import '../../../../core/entities/activity_feed_item.dart';

/// Everything DashboardScreen needs to render, in one snapshot. The
/// screen never asks two different providers for "peers" and "activity"
/// separately -- it watches ONE state object. Simpler widget code, and
/// one obvious place to add a field later (e.g. connectionStatus).
class DashboardState {
  final List<DiscoveredPeer> nearbyPeers;
  final List<ActivityFeedItem> activityFeed;

  const DashboardState({
    this.nearbyPeers = const [],
    this.activityFeed = const [],
  });

  DashboardState copyWith({
    List<DiscoveredPeer>? nearbyPeers,
    List<ActivityFeedItem>? activityFeed,
  }) {
    return DashboardState(
      nearbyPeers: nearbyPeers ?? this.nearbyPeers,
      activityFeed: activityFeed ?? this.activityFeed,
    );
  }
}
