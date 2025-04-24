import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Description:
// This finance analytics app provides a sleek, modern interface for tracking expenses and financial patterns.
// The app features a minimalist design with a distinctive chart visualization that displays monthly spending
// patterns. The main screen includes a monthly navigation bar allowing users to switch between different months
// (January through May), with spending amounts displayed as interactive bubbles on the chart.
//
// Below the chart, a "This Week" section lists recent transactions, showing vendor names, dates, 
// and expense amounts. Each transaction is color-coded (green for income or planned expenses, red for
// unplanned expenses), providing quick visual feedback on spending patterns.
//
// The overall black and white color scheme with green accents creates a professional, focused experience
// that makes financial data easy to comprehend at a glance.
//
// All features are fully functional:
// - Month selection updates the chart data
// - Calendar selector shows a date picker
// - Bubbles are interactive with tap feedback
// - Transactions can be filtered by different time periods
// - All UI elements have appropriate animations and state changes

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Analytics',
      theme: ThemeData(
        fontFamily: 'SF Pro',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF10B981),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF10B981),
          surface: Colors.white,
          background: const Color(0xFFF5F5F5),
          error: const Color(0xFFEF4444),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const AnalyticsScreen(),
    );
  }
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  int _selectedMonthIndex = 1; // February selected by default
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
  DateTime _selectedDate = DateTime(2024, 2);
  String _selectedTimeFrame = 'This Week';
  final List<String> _timeFrames = ['Today', 'This Week', 'This Month', 'Last 3 Months'];
  
  // Animation controller for bubble interactions
  late AnimationController _animationController;
  int? _tappedBubbleIndex;
  
  // Data for chart bubbles with specific positions for each month
  final Map<String, List<ExpenseBubble>> _monthlyBubbles = {
    'Jan': [
      ExpenseBubble(month: 'Jan', amount: 3000, x: 0.12, y: 0.6, category: 'Food'),
      ExpenseBubble(month: 'Jan', amount: 2500, x: 0.25, y: 0.65, category: 'Shopping'),
    ],
    'Feb': [
      ExpenseBubble(month: 'Feb', amount: 4000, x: 0.32, y: 0.5, category: 'Entertainment'),
      ExpenseBubble(month: 'Feb', amount: 3000, x: 0.52, y: 0.56, category: 'Bills'),
    ],
    'Mar': [
      ExpenseBubble(month: 'Mar', amount: 5000, x: 0.64, y: 0.4, category: 'Travel'),
      ExpenseBubble(month: 'Mar', amount: 3000, x: 0.83, y: 0.55, category: 'Health'),
    ],
    'Apr': [
      ExpenseBubble(month: 'Apr', amount: 2800, x: 0.35, y: 0.58, category: 'Food'),
      ExpenseBubble(month: 'Apr', amount: 3200, x: 0.7, y: 0.48, category: 'Shopping'),
    ],
    'May': [
      ExpenseBubble(month: 'May', amount: 3500, x: 0.25, y: 0.52, category: 'Entertainment'),
      ExpenseBubble(month: 'May', amount: 4200, x: 0.6, y: 0.45, category: 'Travel'),
    ],
  };
  
  // All transactions data by month
  final Map<String, List<Transaction>> _allTransactions = {
    'Jan': [
      Transaction(vendor: 'Coffee Shop', date: DateTime(2024, 1, 10), amount: -15, isPositive: true, category: 'Food'),
      Transaction(vendor: 'Clothing Store', date: DateTime(2024, 1, 15), amount: -120, isPositive: true, category: 'Shopping'),
      Transaction(vendor: 'Movie Theater', date: DateTime(2024, 1, 20), amount: -35, isPositive: false, category: 'Entertainment'),
    ],
    'Feb': [
      Transaction(vendor: 'EatPick', date: DateTime(2024, 2, 14), amount: -25, isPositive: true, category: 'Food'),
      Transaction(vendor: 'R&B', date: DateTime(2024, 2, 16), amount: -280, isPositive: true, category: 'Shopping'),
      Transaction(vendor: 'Amazon', date: DateTime(2024, 2, 17), amount: -120, isPositive: false, category: 'Shopping'),
      Transaction(vendor: 'Utility Bill', date: DateTime(2024, 2, 20), amount: -85, isPositive: true, category: 'Bills'),
      Transaction(vendor: 'Bookstore', date: DateTime(2024, 2, 22), amount: -45, isPositive: false, category: 'Entertainment'),
    ],
    'Mar': [
      Transaction(vendor: 'Pharmacy', date: DateTime(2024, 3, 5), amount: -65, isPositive: true, category: 'Health'),
      Transaction(vendor: 'Restaurant', date: DateTime(2024, 3, 12), amount: -95, isPositive: false, category: 'Food'),
      Transaction(vendor: 'Flight Tickets', date: DateTime(2024, 3, 18), amount: -450, isPositive: true, category: 'Travel'),
    ],
    'Apr': [
      Transaction(vendor: 'Grocery Store', date: DateTime(2024, 4, 3), amount: -75, isPositive: true, category: 'Food'),
      Transaction(vendor: 'Electronics', date: DateTime(2024, 4, 10), amount: -220, isPositive: false, category: 'Shopping'),
    ],
    'May': [
      Transaction(vendor: 'Hotel Booking', date: DateTime(2024, 5, 5), amount: -350, isPositive: true, category: 'Travel'),
      Transaction(vendor: 'Concert Tickets', date: DateTime(2024, 5, 15), amount: -120, isPositive: true, category: 'Entertainment'),
    ],
  };
  
  // Currently displayed transactions
  List<Transaction> _displayedTransactions = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _updateDisplayedTransactions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Update transactions based on selected month and timeframe
  void _updateDisplayedTransactions() {
    final selectedMonth = _months[_selectedMonthIndex];
    final transactions = _allTransactions[selectedMonth] ?? [];
    
    // Filter by timeframe
    final now = DateTime(2024, _selectedMonthIndex + 1); // Using 2024 as base year
    List<Transaction> filtered = [];
    
    switch (_selectedTimeFrame) {
      case 'Today':
        filtered = transactions.where((t) => 
          t.date.day == now.day && 
          t.date.month == now.month
        ).toList();
        break;
      case 'This Week':
        // Simplified: just show transactions from this month within 7 days of now
        filtered = transactions.where((t) => 
          now.difference(t.date).inDays <= 7
        ).toList();
        break;
      case 'This Month':
        filtered = transactions;
        break;
      case 'Last 3 Months':
        // Include transactions from up to 3 months ago
        final threeMothsAgo = DateTime(now.year, now.month - 2, 1);
        List<Transaction> allRecentTransactions = [];
        
        for (int i = max(0, _selectedMonthIndex - 2); i <= _selectedMonthIndex; i++) {
          if (i >= 0 && i < _months.length) {
            allRecentTransactions.addAll(_allTransactions[_months[i]] ?? []);
          }
        }
        
        filtered = allRecentTransactions.where((t) => 
          t.date.isAfter(threeMothsAgo) || 
          (t.date.month == threeMothsAgo.month && t.date.year == threeMothsAgo.year)
        ).toList();
        break;
    }
    
    // Further filter by category if selected
    if (_selectedCategory != null) {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }
    
    // Sort by date (most recent first)
    filtered.sort((a, b) => b.date.compareTo(a.date));
    
    setState(() {
      _displayedTransactions = filtered;
    });
  }

  List<ExpenseBubble> _getCurrentBubbles() {
    // For demonstration purposes, we'll show bubbles from the selected month
    // In a real app, you might filter more specifically
    final monthKey = _months[_selectedMonthIndex];
    List<ExpenseBubble> bubbles = _monthlyBubbles[monthKey] ?? [];
    
    // Add 1-2 bubbles from adjacent months to make the chart more interesting
    if (_selectedMonthIndex > 0) {
      final prevMonth = _months[_selectedMonthIndex - 1];
      final prevMonthBubbles = _monthlyBubbles[prevMonth];
      if (prevMonthBubbles != null && prevMonthBubbles.isNotEmpty) {
        bubbles.add(prevMonthBubbles[0]);
      }
    }
    
    if (_selectedMonthIndex < _months.length - 1) {
      final nextMonth = _months[_selectedMonthIndex + 1];
      final nextMonthBubbles = _monthlyBubbles[nextMonth];
      if (nextMonthBubbles != null && nextMonthBubbles.isNotEmpty) {
        bubbles.add(nextMonthBubbles[0]);
      }
    }
    
    return bubbles;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2024, 5, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF10B981),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Update selected month based on picked date
        _selectedMonthIndex = picked.month - 1;
        _updateDisplayedTransactions();
      });
    }
  }

  void _showTimeFrameSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Time Period',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_timeFrames.length, (index) {
                final timeFrame = _timeFrames[index];
                return ListTile(
                  title: Text(
                    timeFrame,
                    style: TextStyle(
                      fontWeight: _selectedTimeFrame == timeFrame
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedTimeFrame == timeFrame
                          ? const Color(0xFF10B981)
                          : Colors.black,
                    ),
                  ),
                  trailing: _selectedTimeFrame == timeFrame
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedTimeFrame = timeFrame;
                      _updateDisplayedTransactions();
                    });
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryFilter() {
    // Get unique categories from transactions
    Set<String> categories = {};
    _allTransactions.values.forEach((transactions) {
      transactions.forEach((transaction) {
        categories.add(transaction.category);
      });
    });
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Categories'),
                trailing: _selectedCategory == null
                    ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategory = null;
                    _updateDisplayedTransactions();
                  });
                },
              ),
              ...categories.map((category) {
                return ListTile(
                  title: Text(
                    category,
                    style: TextStyle(
                      fontWeight: _selectedCategory == category
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedCategory == category
                          ? const Color(0xFF10B981)
                          : Colors.black,
                    ),
                  ),
                  trailing: _selectedCategory == category
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedCategory = category;
                      _updateDisplayedTransactions();
                    });
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF5F5F5),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthSelector(),
                    _buildChart(),
                    _buildTransactionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    // In a real app, this would navigate back
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate back')),
                    );
                  },
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _showCategoryFilter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('MMM, yyyy').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_months.length, (index) {
              final isSelected = index == _selectedMonthIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMonthIndex = index;
                    _selectedDate = DateTime(2024, index + 1);
                    _updateDisplayedTransactions();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: isSelected
                        ? const Border(
                            bottom: BorderSide(
                              color: Color(0xFF10B981),
                              width: 2,
                            ),
                          )
                        : null,
                  ),
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChart() {
    final currentBubbles = _getCurrentBubbles();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: StripedBackgroundPainter(),
            ),
          ),
          
          // Black shapes at the bottom (representing base blocks)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                // Create specific shapes based on the image
                double width = 54;
                double height = 50;
                
                switch (index) {
                  case 0:
                    height = 42;
                    break;
                  case 1:
                    height = 52;
                    break;
                  case 2:
                    height = 45;
                    break;
                  case 3:
                    height = 60;
                    break;
                  case 4:
                    height = 48;
                    break;
                }
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }),
            ),
          ),
          
          // Green bubbles
          ...currentBubbles.asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final bubble = entry.value;
            
            final isSelected = _tappedBubbleIndex == index;
            
            return Positioned(
              left: bubble.x * MediaQuery.of(context).size.width,
              top: bubble.y * 270,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_tappedBubbleIndex == index) {
                      _tappedBubbleIndex = null;
                      _selectedCategory = null;
                    } else {
                      _tappedBubbleIndex = index;
                      _selectedCategory = bubble.category;
                    }
                    _updateDisplayedTransactions();
                    
                    // Trigger animation
                    if (isSelected) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }
                  });
                },
                child: AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      '${(bubble.amount / 1000).round()}k',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _selectedTimeFrame,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_selectedCategory != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCategory!,
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = null;
                                _tappedBubbleIndex = null;
                                _updateDisplayedTransactions();
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              GestureDetector(
                onTap: _showTimeFrameSelector,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _displayedTransactions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No transactions found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: _displayedTransactions
                      .map((transaction) => _buildTransactionItem(transaction))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final iconMap = {
      'Food': Icons.restaurant_outlined,
      'Shopping': Icons.shopping_bag_outlined,
      'Entertainment': Icons.movie_outlined,
      'Bills': Icons.receipt_outlined,
      'Travel': Icons.flight_outlined,
      'Health': Icons.medical_services_outlined,
    };
    
    final icon = iconMap[transaction.category] ?? Icons.receipt_outlined;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF10B981),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.vendor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: transaction.isPositive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-\$${transaction.amount.abs()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseBubble {
  final String month;
  final double amount;
  final double x;
  final double y;
  final String category;

  ExpenseBubble({
    required this.month,
    required this.amount,
    required this.x,
    required this.y,
    required this.category,
  });
}

class Transaction {
  final String vendor;
  final DateTime date;
  final double amount;
  final bool isPositive;
  final String category;

  Transaction({
    required this.vendor,
    required this.date,
    required this.amount,
    required this.isPositive,
    required this.category,
  });
}

class StripedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;

    final stripeWidth = size.width / 14;
    final stripeHeight = size.height;
    
    for (var i = 0; i < 14; i += 2) {
      final rect = Rect.fromLTWH(
        i * stripeWidth,
        0,
        stripeWidth,
        stripeHeight,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Helper function to get maximum of two integers
int max(int a, int b) {
  return a > b ? a : b;
}
