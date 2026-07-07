import 'package:flutter/material.dart';
import '../../../../core/entities/peer.dart';

/// Renders a shared DiscoveredPeer entity -- the discovery/radar screen
/// renders the exact same entity type, just with a different layout.
class NearbyPeerTile extends StatelessWidget {
  const NearbyPeerTile({super.key, required this.peer});

  final DiscoveredPeer peer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Text(peer.name.isNotEmpty ? peer.name[0] : '?'),
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
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
          const Icon(Icons.sync_alt, size: 18, color: Color(0xFF4F46E5)),
        ],
      ),
    );
  }
}
