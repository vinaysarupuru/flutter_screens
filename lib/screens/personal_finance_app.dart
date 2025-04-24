import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Description:
// This personal finance app interface offers a modern and minimalist solution for managing finances. 
// The design is focused on usability and clarity, allowing users to quickly understand their financial status.
//
// The app provides a comprehensive overview of the user's finances, starting with the total balance 
// displayed prominently on the main screen. Below the balance are quick-access buttons for depositing, 
// withdrawing, and transferring funds, making financial transactions simple and efficient.
//
// The "Transactions" section helps users track recent activities—transfers, subscriptions, and purchases—allowing 
// them to monitor their spending and view their transaction history in real-time.
//
// On the right side, there are separate cards showing the current balance on the debit card, savings, 
// cryptocurrency investments, and financial goals. The green and white color scheme creates a pleasant 
// visual contrast and emphasizes key data points.
//
// The app also includes a goal-setting feature, such as saving for a house, with a progress indicator. 
// This motivates users and helps them plan for the future by showing how much more is needed to reach their goals.
//
// Overall, this app design is tailored for convenient financial management, helping users easily track 
// balances, manage assets, and achieve their financial objectives.

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      theme: ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF4CD964),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4CD964),
          secondary: Color(0xFF4CD964),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(
            currentIndex: _currentIndex,
            onNavigate: _navigateToPage,
          ),
          AccountsScreen(
            onNavigateToHome: () => _navigateToPage(0),
          ),
          const PlaceholderScreen(title: "Transactions"),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text(
          "$title Screen",
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key, 
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Column(
                        children: [
                          _buildHeader(),
                          _buildBalance(),
                          _buildActionButtons(),
                          _buildDivider(),
                          _buildTransactionsHeader(),
                          _buildTransactionsList(),
                          _buildBottomNavigation(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hey, Dean',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalance() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '\$155 804.1',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionButton('Deposit', Icons.arrow_downward_rounded),
          _actionButton('Withdraw', Icons.arrow_upward_rounded),
          _actionButton('Transfer', Icons.swap_vert),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Color(0xFF4CD964),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF4CD964),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTransactionsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'October',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.grey[800],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _transactionCard(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg', 
              'Adam West', 
              'Received', 
              '+\$200', 
              '3:25PM',
            ),
            const SizedBox(height: 8),
            _transactionCard(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              'Spotify',
              'Subscription',
              '-\$4.99',
              'Dec, 19th',
            ),
            const SizedBox(height: 8),
            _transactionCard(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              'Jenny Wilson',
              'Transfer',
              '+\$50',
              'Dec, 17th',
            ),
            const SizedBox(height: 8),
            _transactionCard(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              'Levis',
              'Shopping',
              '-\$520',
              'Dec, 15th',
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(String image, String name, String type, String amount, String date) {
    final isPositive = amount.contains('+');
    
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isPositive ? const Color(0xFF4CD964) : Colors.black,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _navItem(Icons.home, 0),
                const SizedBox(width: 24),
                _navItem(Icons.business_center_outlined, 1),
                const SizedBox(width: 24),
                _navItem(Icons.settings_outlined, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool isSelected = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: isSelected ? Matrix4.identity().scaled(1.2) : Matrix4.identity(),
      child: GestureDetector(
        onTap: () => onNavigate(index),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: 24,
        ),
      ),
    );
  }
}

class AccountsScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;

  const AccountsScreen({
    super.key, 
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onNavigateToHome,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDebitCard(),
                  const SizedBox(height: 16),
                  _buildSavingsCard(),
                  const SizedBox(height: 16),
                  _buildCryptoCard(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildHouseGoalCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAddGoalCard()),
                    ],
                  ),
                  const SizedBox(height: 24), // Bottom padding for scrolling
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebitCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFF0A5D2C),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Debit card',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                _DebitCardPattern(),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              '\$12 154.5',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Dean Williamson',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current balance',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$98 923.5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _SavingsIcon(icon: Icons.home),
                    SizedBox(width: 8),
                    _SavingsIcon(icon: Icons.people),
                    SizedBox(width: 8),
                    _SavingsIcon(icon: Icons.directions_car),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFF4CD964),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crypto',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Current balance',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$22 630.20',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _CryptoIcon(icon: Icons.currency_bitcoin),
                    SizedBox(width: 8),
                    _CryptoIcon(icon: Icons.workspaces_outlined),
                    SizedBox(width: 8),
                    _CryptoIcon(icon: Icons.currency_exchange),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseGoalCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buy a house',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '• In 8 years',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              '• family savings',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$75 158',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '15%',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 75,
              decoration: BoxDecoration(
                color: const Color(0xFF4CD964),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddGoalCard() {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3).withOpacity(1.0),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: SizedBox(
        height: 180, // Match height with goal card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add a goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebitCardPattern extends StatelessWidget {
  const _DebitCardPattern();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF1A7E4A),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 5,
            child: Container(
              width: 25,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A7E4A),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 30,
            child: Container(
              width: 25,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF1A7E4A),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsIcon extends StatelessWidget {
  final IconData icon;
  
  const _SavingsIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF4CD964),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF4CD964),
        size: 20,
      ),
    );
  }
}

class _CryptoIcon extends StatelessWidget {
  final IconData icon;
  
  const _CryptoIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}
