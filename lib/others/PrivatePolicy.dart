import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
        backgroundColor: ksecColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Privacy Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PrivacySettingTile(
            title: 'Show Online Status',
            subtitle: 'Allow others to see when you are online',
            onChanged: (value) {
              // Handle online status privacy setting change
            },
          ),
          PrivacySettingTile(
            title: 'Location Sharing',
            subtitle: 'Allow sharing your location with others',
            onChanged: (value) {
              // Handle location sharing privacy setting change
            },
          ),
          // Add more privacy settings as needed
        ],
      ),
    );
  }
}

class PrivacySettingTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final ValueChanged<bool>? onChanged;

  const PrivacySettingTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onChanged,
  }) : super(key: key);

  @override
  _PrivacySettingTileState createState() => _PrivacySettingTileState();
}

class _PrivacySettingTileState extends State<PrivacySettingTile> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(widget.subtitle),
      trailing: Switch(
        value: _value,
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
      ),
    );
  }
}
