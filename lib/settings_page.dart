import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:kanban_flt/config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _themeOptions = [
    'System',
    'Light',
    'Dark',
  ];
  String? selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  title: Text('Theme'),
                  leading: Icon(Icons.brightness_high_sharp),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        selectedTheme!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: _themeOptions
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedTheme,
                      onChanged: (String? value) {
                        setState(() {
                          selectedTheme = value;
                          print('Attempting to switch theme to $selectedTheme');
                          if (value == 'System') {
                            globalAppTheme.switchTheme(0);
                          }
                          if (value == 'Light') {
                            globalAppTheme.switchTheme(1);
                          }
                          if (value == 'Dark') {
                            globalAppTheme.switchTheme(2);
                          }
                          print(globalAppTheme.currentTheme());
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 140,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                  onPressed: (value) {},
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
