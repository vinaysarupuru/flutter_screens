import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Charging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Profile tab selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProfilePage(),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfilePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vinay Sarupuru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Account section
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCardTile(Icons.person, 'Profile details', Colors.indigo),
              const SizedBox(height: 16),

              // Activity section
              const Text(
                'Activity',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCardTile(Icons.access_time, 'My chargers', Colors.indigo),
              const SizedBox(height: 8),
              _buildCardTile(Icons.map, 'Trip Planner', Colors.indigo),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.directions_car,
                'My vehicles',
                Colors.indigo,
              ),
              const SizedBox(height: 8),
              _buildCardTile(Icons.bolt, 'Charging history', Colors.indigo),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.bookmark_border,
                'My bookings',
                Colors.indigo,
              ),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.favorite_border,
                'Favourites',
                Colors.indigo,
              ),
              const SizedBox(height: 16),

              // Actions section
              const Text(
                'Actions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCardTile(Icons.share, 'Share the App', Colors.indigo),
              const SizedBox(height: 16),

              // Resources section
              const Text(
                'Resources',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCardTile(Icons.info, 'Support', Colors.indigo),
              const SizedBox(height: 8),
              _buildCardTile(Icons.school, 'Tutorial', Colors.indigo),
              const SizedBox(height: 16),

              // Policies section
              const Text(
                'Policies',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.privacy_tip,
                'Privacy policy',
                Colors.indigo,
              ),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.assignment_return,
                'Return policy',
                Colors.indigo,
              ),
              const SizedBox(height: 8),
              _buildCardTile(
                Icons.description,
                'Terms & Conditions',
                Colors.indigo,
              ),
              const SizedBox(height: 16),

              // Logout
              _buildCardTile(Icons.logout, 'Logout', Colors.red),
              const SizedBox(height: 16),

              // Delete account
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Delete my account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

              // Version
              Center(
                child: Text(
                  'Version: 1.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTile(IconData icon, String title, Color iconColor) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scan QR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
