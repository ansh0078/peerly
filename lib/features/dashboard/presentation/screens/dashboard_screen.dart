import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/entities/peer.dart';
import '../../../../core/session/current_user_provider.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/connection_status_badge.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/nearby_peer_tile.dart';
import '../widgets/activity_feed_card.dart';

/// The screen itself is deliberately thin. It never talks to Isar, Dio,
/// or any transport service -- it only ever watches
/// dashboardControllerProvider and renders whatever comes back. If you
/// read nothing else in this example, read this file: it's the payoff
/// of everything underneath it.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    // Read from the shared session, not a constructor argument -- this
    // is the fix for the "Dashboard shouldn't reach into auth directly"
    // gap flagged during the architecture review. Dashboard borrows
    // this, exactly like it borrows connection status.
    final userName = ref.watch(currentUserProvider)?.name ?? 'there';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Peerly',
          style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ConnectionStatusBadge(),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Something went wrong: $err')),
        data: (dashboard) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Good morning, $userName',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "You're connected to the Campus Mesh.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: QuickActionButton(icon: Icons.meeting_room, label: 'Join Room'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(icon: Icons.qr_code, label: 'Scan QR'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(icon: Icons.chat_bubble_outline, label: 'New Chat'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _NearbyNowCard(peers: dashboard.nearbyPeers),
              const SizedBox(height: 20),
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (final item in dashboard.activityFeed) ActivityFeedCard(item: item),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Files'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _NearbyNowCard extends StatelessWidget {
  const _NearbyNowCard({required this.peers});

  final List<DiscoveredPeer> peers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nearby Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (peers.isEmpty)
            const Text('No one nearby yet.', style: TextStyle(color: Colors.black54))
          else
            for (final peer in peers) NearbyPeerTile(peer: peer),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(onPressed: () {}, child: const Text('View All Peers')),
          ),
        ],
      ),
    );
  }
}
