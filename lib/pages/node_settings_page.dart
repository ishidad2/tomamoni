import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/config.dart';
import '../share_preferences_instance.dart';
import '../providers/node_config_provider.dart';

class NodeSettingsPage extends ConsumerStatefulWidget {
  @override
  _NodeSettingsPageState createState() => _NodeSettingsPageState();
}

class _NodeSettingsPageState extends ConsumerState<NodeSettingsPage> {
  String _selectedNetwork = 'mainnet';
  NodeConfig? _selectedNode;

  @override
  void initState() {
    super.initState();
    _selectedNetwork = 'mainnet';
    _selectedNode = AppConfig.nodeConfigs['mainnet']?.first;
    _loadSavedSettings();
  }

  void _loadSavedSettings() async {
    final prefs = await SharedPreferencesInstance.instance;
    setState(() {
      _selectedNetwork = prefs.getString('selectedNetwork') ?? 'mainnet';
      final savedNodeHost = prefs.getString('selectedNodeHost');
      final savedNodeWebsocket = prefs.getString('selectedNodeWebsocket');

      if (savedNodeHost != null && savedNodeWebsocket != null) {
        _selectedNode = AppConfig.nodeConfigs[_selectedNetwork]?.firstWhere(
          (node) =>
              node.host == savedNodeHost &&
              node.websocket == savedNodeWebsocket,
          orElse: () => AppConfig.nodeConfigs[_selectedNetwork]!.first,
        );
      } else {
        _selectedNode = AppConfig.nodeConfigs[_selectedNetwork]?.first;
      }
    });
  }

  void _saveSettings() async {
    final prefs = await SharedPreferencesInstance.instance;
    await prefs.setString('selectedNetwork', _selectedNetwork);
    await prefs.setString('selectedNodeHost', _selectedNode?.host ?? '');
    await prefs.setString(
        'selectedNodeWebsocket', _selectedNode?.websocket ?? '');

    if (_selectedNode != null) {
      ref.read(nodeConfigProvider.notifier).updateNodeConfig(_selectedNode!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('設定を保存しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ノード設定')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ネットワーク選択',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedNetwork,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedNetwork = newValue;
                    _selectedNode =
                        AppConfig.nodeConfigs[_selectedNetwork]?.first;
                  });
                }
              },
              items: ['mainnet', 'testnet']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('ノード選択',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (_selectedNode != null)
              DropdownButton<NodeConfig>(
                value: _selectedNode,
                onChanged: (NodeConfig? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedNode = newValue;
                    });
                  }
                },
                items: AppConfig.nodeConfigs[_selectedNetwork]
                        ?.map<DropdownMenuItem<NodeConfig>>((NodeConfig node) {
                      return DropdownMenuItem<NodeConfig>(
                        value: node,
                        child: Text(node.host),
                      );
                    }).toList() ??
                    [],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
