import 'package:flutter/material.dart';
import './theme_model_tile.dart';
import '../pages/home_page.dart';
import '../pages/node_settings_page.dart';

class DrawerMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DrawerMenu({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Abount'),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(),
          const ThemeModeTile(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('ノード設定'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NodeSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
