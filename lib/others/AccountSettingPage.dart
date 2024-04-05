import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../Get/themeprovider.dart';
class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primary, // Use custom primary color
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Enable Dark Mode'),
                        Switch(
                          value: themeProvider.darkModeEnabled,
                          onChanged: (value) {
                            themeProvider.setDarkMode(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Other settings...
        ],
      ),
    );
  }
}
