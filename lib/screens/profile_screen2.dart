import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Profile tab selected by default
  bool _showProfilePage = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSettings() {
    setState(() {
      _showProfilePage = false;
    });
    _scrollController.animateTo(
      MediaQuery.of(context).size.height *
          0.9, // Approximate position of settings section
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _scrollToProfile() {
    setState(() {
      _showProfilePage = true;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAllPages(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
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
              const SizedBox(height: 8),
              const Text(
                'Vinay Sarupuru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.indigo),
                title: const Text('Profile details'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Activity',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              _buildActivityTile(Icons.access_time, 'My chargers'),
              _buildActivityTile(Icons.map, 'Trip Planner'),
              _buildActivityTile(Icons.directions_car, 'My vehicles'),
              _buildActivityTile(Icons.bolt, 'Charging history'),
              _buildActivityTile(Icons.bookmark_border, 'My bookings'),
              _buildActivityTile(Icons.favorite_border, 'Favourites'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Actions',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.indigo),
                title: const Text('Share the App'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              const Divider(),
              const Text(
                'Resources',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.indigo),
                title: const Text('Support'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.indigo),
                title: const Text('Tutorial'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              const Divider(),
              const Text(
                'Policies',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.indigo),
                title: const Text('Privacy policy'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.assignment_return,
                  color: Colors.indigo,
                ),
                title: const Text('Return policy'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.indigo),
                title: const Text('Terms & Conditions'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Delete my account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Version: 1.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActivityTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      contentPadding: EdgeInsets.zero,
      onTap: () {},
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

  Widget _buildAllPages() {
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildProfileSection(), _buildSettingsSection()],
        ),
      ),
    );
  }
}
