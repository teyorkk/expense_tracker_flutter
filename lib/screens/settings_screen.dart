import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/notification_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return ListTile(
                title: const Text('Theme Mode'),
                subtitle: Text(
                  settingsProvider.themeMode == ThemeMode.light
                      ? 'Light'
                      : 'System',
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: settingsProvider.themeMode,
                  onChanged: (ThemeMode? newMode) {
                    if (newMode != null) {
                      settingsProvider.setThemeMode(newMode);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return SwitchListTile(
                title: const Text('Budget Notifications'),
                subtitle:
                    const Text('Get notified when you exceed your budget'),
                value: notificationProvider.isEnabled,
                onChanged: (bool value) {
                  notificationProvider.setEnabled(value);
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Expense Tracker v1.0.0'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Expense Tracker',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 48),
                children: const [
                  Text(
                    'A simple expense tracking app to help you manage your finances.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
