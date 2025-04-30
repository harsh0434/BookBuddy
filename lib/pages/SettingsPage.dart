import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
<<<<<<< HEAD
=======
import '../Provider/ThemeProvider.dart';
import 'package:provider/provider.dart';
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = AuthService();
<<<<<<< HEAD
  bool _isDarkMode = false;
=======
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
<<<<<<< HEAD
=======
    final themeProvider = Provider.of<ThemeProvider>(context);
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
<<<<<<< HEAD
        backgroundColor: const Color(0xFF1E88E5),
=======
        backgroundColor: Theme.of(context).primaryColor,
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          if (user != null) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
<<<<<<< HEAD
                          backgroundColor: const Color(0xFF1E88E5),
=======
                          backgroundColor: Theme.of(context).primaryColor,
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? Text(
                                  user.email?[0].toUpperCase() ?? 'U',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? 'User',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email ?? '',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        await _authService.signOut();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              ),
            ),
          ],

<<<<<<< HEAD
          const SizedBox(height: 24),

=======
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
          // Appearance Section
          _buildSectionHeader('Appearance'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
<<<<<<< HEAD
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: GoogleFonts.poppins(),
                  ),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'Language',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(_selectedLanguage),
                  leading: const Icon(Icons.language),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Implement language selection
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

=======
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
          // Notifications Section
          _buildSectionHeader('Notifications'),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
<<<<<<< HEAD
            child: SwitchListTile(
              title: Text(
                'Push Notifications',
                style: GoogleFonts.poppins(),
              ),
              subtitle: Text(
                'Receive notifications about new books and updates',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.notifications),
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About'),
=======
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications,
                    title: 'Enable Notifications',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Language Section
          _buildSectionHeader('Language'),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
<<<<<<< HEAD
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(),
                  ),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Implement privacy policy
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'Terms of Service',
                    style: GoogleFonts.poppins(),
                  ),
                  leading: const Icon(Icons.description),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Implement terms of service
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'App Version',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    '1.0.0',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                    ),
                  ),
                  leading: const Icon(Icons.info),
                ),
              ],
=======
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.language,
                    title: 'Language',
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: ['English', 'Spanish', 'French', 'German']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
<<<<<<< HEAD
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E88E5),
=======
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
        ),
      ),
      trailing: trailing,
    );
  }
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
}
