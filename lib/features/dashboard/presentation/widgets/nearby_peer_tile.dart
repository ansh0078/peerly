import 'package:flutter/material.dart';
import '../../../../core/entities/peer.dart';

/// Renders a shared DiscoveredPeer entity -- the discovery/radar screen
/// renders the exact same entity type, just with a different layout.
class NearbyPeerTile extends StatelessWidget {
  const NearbyPeerTile({super.key, required this.peer});

  final DiscoveredPeer peer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              peer.name.isNotEmpty ? peer.name[0] : '?',
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(peer.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (peer.department != null)
                  Text(
                    peer.department!,
                    style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                  ),
              ],
            ),
          ),
          Icon(Icons.sync_alt, size: 18, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
