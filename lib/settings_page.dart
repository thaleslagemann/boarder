import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:kanban_flt/config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final List<String> _themeOptions = [
    'System',
    'Light',
    'Dark',
  ];

  String? selectedTheme = globalAppTheme.currentThemeString();

  var _encryptionSwitch = true;

  Icon encryptionIconSwitch() {
    switch (_encryptionSwitch) {
      case true:
        return Icon(Icons.lock_outline);
      case false:
        return Icon(Icons.lock_open);
    }
    return Icon(Icons.lock_open);
  }

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
                          globalAppTheme.switchTheme(
                              _themeOptions.indexOf(selectedTheme!));
                          print(globalAppTheme.currentTheme());
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 120,
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
                SettingsTile.switchTile(
                  initialValue: _encryptionSwitch,
                  title: Text('Encrypt data'),
                  leading: encryptionIconSwitch(),
                  onPressed: (value) {
                    setState((() {
                      _encryptionSwitch = !_encryptionSwitch;
                    }));
                  },
                  onToggle: (value) {
                    setState((() {
                      _encryptionSwitch = !_encryptionSwitch;
                    }));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
