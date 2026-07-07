import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/transport/transport_repository.dart';

/// Reads connection state directly from core/transport -- Dashboard
/// doesn't own this data, it just displays it. Any other screen (Chat,
/// Rooms, Notes) can drop this same widget in and get the same badge
/// for free, because it isn't scoped to the dashboard feature at all.
final meshActiveProvider = StreamProvider<bool>((ref) {
  return getIt<TransportRepository>().watchMeshActive();
});

class ConnectionStatusBadge extends ConsumerWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(meshActiveProvider).valueOrNull ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: isActive ? Colors.green : Colors.grey),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Mesh Active' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF166534) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
