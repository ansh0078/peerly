/// Shared across features (discovery, dashboard, chat all use this).
/// Lives in core/ specifically so no feature defines its own copy --
/// that's the "entities drift out of sync" problem flagged during the
/// architecture review. If you already have a local Peer/TransportTier
/// definition inside your discovery screen file, delete it and import
/// this one instead.
library;

/// Which transport tier a peer is currently reachable through.
/// Ring distance in the discovery radar, and badge color everywhere
/// else, is driven directly by this value -- not decoration.
enum TransportTier { nearby, localLan, remote }

extension TransportTierX on TransportTier {
  String get label => switch (this) {
        TransportTier.nearby => 'Bluetooth · nearby',
        TransportTier.localLan => 'Same Wi-Fi',
        TransportTier.remote => 'Internet relay',
      };
}

class DiscoveredPeer {
  final String id;
  final String name;
  final String? department;
  final TransportTier tier;
  final bool isConnecting;

  const DiscoveredPeer({
    required this.id,
    required this.name,
    this.department,
    required this.tier,
    this.isConnecting = false,
  });
}
