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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = ref.watch(meshActiveProvider).valueOrNull ?? false;

    final bgColor = isActive
        ? Colors.green.withValues(alpha: 0.15)
        : (isDark ? theme.colorScheme.surfaceContainer : const Color(0xFFF3F4F6));

    final contentColor = isActive
        ? (isDark ? Colors.greenAccent : const Color(0xFF166534))
        : (isDark ? Colors.grey[400] : Colors.grey[700]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
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
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
