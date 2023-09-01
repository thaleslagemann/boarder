import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:kanban_flt/config.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          currentTheme.switchTheme();
        },
        child: Icon(Icons.mobile_screen_share_sharp),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: Text('System'),
              tiles: [
                SettingsTile(
                  title: Text('Language'),
                  description: Text('English'),
                  leading: Icon(Icons.language),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: Text('Use System Theme'),
                  leading: Icon(Icons.brightness_high_sharp),
                  onPressed: (value) {
                    currentTheme.switchTheme();
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text('Security'),
              tiles: [
                SettingsTile(
                  title: Text('Security'),
                  description: Text('Fingerprint'),
                  leading: Icon(Icons.lock),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile.switchTile(
                  initialValue: true,
                  title: Text('Use fingerprint'),
                  leading: Icon(Icons.fingerprint),
                  onPressed: (value) {},
                  onToggle: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
