import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/permission_toggle_tile.dart';

/// Real permission_handler calls -- tapping a toggle triggers the
/// actual OS permission dialog, and the switch reflects the real
/// granted/denied result, not just a UI-only boolean.
class DevicePermissionsScreen extends StatefulWidget {
  const DevicePermissionsScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<DevicePermissionsScreen> createState() => _DevicePermissionsScreenState();
}

class _DevicePermissionsScreenState extends State<DevicePermissionsScreen> {
  bool _bluetooth = false;
  bool _location = false;
  bool _nearbyDevices = false;
  bool _storage = false;

  Future<void> _request(Permission permission, void Function(bool granted) apply) async {
    final status = await permission.request();
    apply(status.isGranted);
    if (mounted) setState(() {});
  }

  Future<void> _enableAll() async {
    await _request(Permission.bluetoothScan, (v) => _bluetooth = v);
    await _request(Permission.locationWhenInUse, (v) => _location = v);
    await _request(Permission.bluetoothConnect, (v) => _nearbyDevices = v);
    await _request(Permission.storage, (v) => _storage = v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.podcasts, size: 48),
              const SizedBox(height: 16),
              Text(
                'Ready to Discover?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'To build a reliable offline mesh network and find nearby peers securely, '
                'Peerly needs access to a few core device features.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 24),
              PermissionToggleTile(
                icon: Icons.bluetooth,
                title: 'Bluetooth',
                description: 'Essential for discovering and connecting to nearby Peerly users securely without internet.',
                value: _bluetooth,
                onChanged: (_) => _request(Permission.bluetoothScan, (v) => _bluetooth = v),
              ),
              PermissionToggleTile(
                icon: Icons.location_on_outlined,
                title: 'Location Services',
                description: 'Required by the operating system to map nearby mesh nodes. Your location data never leaves your device.',
                value: _location,
                onChanged: (_) => _request(Permission.locationWhenInUse, (v) => _location = v),
              ),
              PermissionToggleTile(
                icon: Icons.devices_other,
                title: 'Nearby Devices',
                description: 'Allows Peerly to maintain stable connections with devices currently in your local mesh cluster.',
                value: _nearbyDevices,
                onChanged: (_) => _request(Permission.bluetoothConnect, (v) => _nearbyDevices = v),
              ),
              PermissionToggleTile(
                icon: Icons.folder_outlined,
                title: 'Local Storage',
                description: 'Needed to save offline files and encrypted chat history directly on your device.',
                value: _storage,
                onChanged: (_) => _request(Permission.storage, (v) => _storage = v),
              ),
              const SizedBox(height: 8),
              AppButton(label: 'Enable All', onPressed: _enableAll),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: widget.onContinue,
                  child: const Text('SET UP MANUALLY', style: TextStyle(letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your privacy matters. Peerly only uses these connections to communicate directly with devices near you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
