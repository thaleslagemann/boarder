// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:boarder/app_settings/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:boarder/app_settings/config.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final List<String> _reorderOptions = [
    'Insert',
    'Swap',
  ];

  Preferences prefs = Preferences();

  String? selectedTheme = globalAppTheme.currentThemeString();
  String? selectedReorder = reorderType.currentReorderString();
  int selectedRadio = taskShape.getCurrentShapeInt();
  int selectedColorRadio = globalAppTheme.getCurrentMainColor();

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

  _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  _showCredits(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: Text('Credits'),
              actions: [
                TextButton(
                    onPressed: (() {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    }),
                    child: Text('ok', style: TextStyle(color: globalAppTheme.mainColorOption())))
              ],
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Project by:'),
                  Text('Thales Lagemann', style: TextStyle(color: globalAppTheme.mainColorOption())),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          _launchURL('https://github.com/thaleslagemann/');
                        },
                        child: Text(
                          'GitHub',
                          style: TextStyle(color: Colors.indigo[400]),
                        ),
                      ),
                      SizedBox(width: 5),
                      OutlinedButton(
                        onPressed: () async {
                          _launchURL('https://google.com/');
                        },
                        child: Text(
                          'Google',
                          style: TextStyle(color: Colors.indigo[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var configState = context.watch<ConfigState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.settings_sharp,
              //         size: 24,
              //       ),
              //       Text(
              //         ' Settings',
              //         style: TextStyle(fontSize: 24),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: SettingsList(
                  sections: [
                    SettingsSection(
                        title: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                        tiles: []),
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
                                  color: globalAppTheme.mainColorOption(),
                                ),
                              ),
                              items: _themeOptions
                                  .map((String item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: globalAppTheme.mainColorOption(),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedTheme,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedTheme = value;
                                  print('Attempting to switch theme to $selectedTheme');
                                  globalAppTheme.switchTheme(_themeOptions.indexOf(selectedTheme!));
                                  prefs.setThemePreferences(_themeOptions.indexOf(selectedTheme!));
                                  print(globalAppTheme.currentTheme());
                                });
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Theme changed')),
                                );
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
                        SettingsTile(
                          title: Text('Main Color'),
                          leading: Icon(Icons.format_paint_outlined),
                          trailing: ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Radio(
                                        value: 0,
                                        groupValue: selectedColorRadio,
                                        activeColor: globalAppTheme.mainColorOption(),
                                        onChanged: (val) {
                                          setState(() {
                                            configState.switchMainColor(val!);
                                            selectedColorRadio = globalAppTheme.getCurrentMainColor();
                                            prefs.setMainColorPreferences(val);
                                          });
                                          print("Color Radio $val");
                                        },
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).colorScheme.primary),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: selectedColorRadio,
                                        activeColor: globalAppTheme.mainColorOption(),
                                        onChanged: (val) {
                                          setState(() {
                                            configState.switchMainColor(val!);
                                            selectedColorRadio = globalAppTheme.getCurrentMainColor();
                                            prefs.setMainColorPreferences(val);
                                          });
                                          print("Color Radio $val");
                                        },
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).colorScheme.secondary),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Radio(
                                        value: 2,
                                        groupValue: selectedColorRadio,
                                        activeColor: globalAppTheme.mainColorOption(),
                                        onChanged: (val) {
                                          setState(() {
                                            configState.switchMainColor(val!);
                                            selectedColorRadio = globalAppTheme.getCurrentMainColor();
                                            prefs.setMainColorPreferences(val);
                                          });
                                          print("Color Radio $val");
                                        },
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).colorScheme.tertiary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(title: Text('Boards'), tiles: [
                      SettingsTile(
                        title: Text('Task shape'),
                        leading: Icon(Icons.format_shapes_sharp),
                        trailing: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: selectedRadio,
                                      activeColor: globalAppTheme.mainColorOption(),
                                      onChanged: (val) {
                                        setState(() {
                                          taskShape.switchTaskShape(val!);
                                          selectedRadio = taskShape.getCurrentShapeInt();
                                          prefs.setTaskShapePreferences(val);
                                        });
                                        print("Radio $val");
                                      },
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                          border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: selectedRadio,
                                      activeColor: globalAppTheme.mainColorOption(),
                                      onChanged: (val) {
                                        setState(() {
                                          taskShape.switchTaskShape(val!);
                                          selectedRadio = taskShape.getCurrentShapeInt();
                                          prefs.setTaskShapePreferences(val);
                                        });
                                        print("Radio $val");
                                      },
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: selectedRadio,
                                      activeColor: globalAppTheme.mainColorOption(),
                                      onChanged: (val) {
                                        setState(() {
                                          taskShape.switchTaskShape(val!);
                                          selectedRadio = taskShape.getCurrentShapeInt();
                                          prefs.setTaskShapePreferences(val);
                                        });
                                        print("Radio $val");
                                      },
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(0)),
                                          border: Border.all(width: 1.5, color: globalAppTheme.mainColorOption()!)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SettingsTile(
                        title: Text('Reorder type'),
                        leading: Icon(Icons.swap_vert_rounded),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              selectedReorder!,
                              style: TextStyle(
                                fontSize: 14,
                                color: globalAppTheme.mainColorOption(),
                              ),
                            ),
                            items: _reorderOptions
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: globalAppTheme.mainColorOption(),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedReorder,
                            onChanged: (String? value) {
                              setState(() {
                                selectedReorder = value;
                                print('Attempting to switch reorder type to $selectedReorder');
                                reorderType.switchReorder();
                                print(selectedReorder);
                              });
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reorder type changed')),
                              );
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
                    ]),
                    SettingsSection(
                      title: Text('Security'),
                      tiles: [
                        SettingsTile.switchTile(
                          activeSwitchColor: globalAppTheme.mainColorOption(),
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
                    SettingsSection(
                      title: Text('Other'),
                      tiles: [
                        SettingsTile(
                            leading: Icon(Icons.people_sharp),
                            title: Text('Credits'),
                            trailing: Icon(Icons.arrow_right),
                            onPressed: ((context) {
                              _showCredits(context);
                            })),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
