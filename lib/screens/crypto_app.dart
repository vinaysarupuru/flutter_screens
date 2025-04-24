import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoTrackerApp());
}

class CryptoTrackerApp extends StatelessWidget {
  const CryptoTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const CryptoTrackerHome(),
    );
  }
}

class CryptoTrackerHome extends StatefulWidget {
  const CryptoTrackerHome({super.key});

  @override
  State<CryptoTrackerHome> createState() => _CryptoTrackerHomeState();
}

class _CryptoTrackerHomeState extends State<CryptoTrackerHome> {
  int _selectedIndex = 0;

  final List<CryptoCurrency> _cryptoList = [
    CryptoCurrency(
      name: 'ARPA Chain',
      symbol: 'ARPA',
      price: null,
      changePercentage: 1.72,
      isPositiveChange: true,
      iconColor: Colors.deepPurple,
      iconData: Icons.hexagon_outlined,
      chartData: [0.2, 0.3, 0.25, 0.4, 0.3, 0.5, 0.4, 0.6, 0.5, 0.7],
    ),
    CryptoCurrency(
      name: 'BITCOIN',
      symbol: 'BTC',
      price: 102536,
      changePercentage: 1.04,
      isPositiveChange: false,
      iconColor: Colors.orange,
      iconData: Icons.currency_bitcoin,
    ),
    CryptoCurrency(
      name: 'ETHEREUM',
      symbol: 'ETH',
      price: 3144,
      changePercentage: 2.81,
      isPositiveChange: true,
      iconColor: Colors.blueAccent,
      iconData: Icons.hexagon_outlined,
    ),
    CryptoCurrency(
      name: 'TETHER',
      symbol: 'USDT',
      price: 1.00,
      changePercentage: 0.02,
      isPositiveChange: false,
      iconColor: Colors.teal,
      iconData: Icons.attach_money_outlined,
    ),
    CryptoCurrency(
      name: 'BNB',
      symbol: 'BNB',
      price: null,
      changePercentage: null,
      isPositiveChange: true,
      iconColor: Colors.amber.shade700,
      iconData: Icons.trip_origin,
    ),
    CryptoCurrency(
      name: 'SOLANA',
      symbol: 'SOL',
      price: 186.09,
      changePercentage: null,
      isPositiveChange: true,
      iconColor: Colors.deepPurple,
      iconData: Icons.hexagon_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildTopNavBar(),
              const SizedBox(height: 16),
              _buildFeaturedCrypto(),
              const SizedBox(height: 16),
              _buildFilterButtons(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _cryptoList.length - 1,
                  itemBuilder: (context, index) {
                    // Skip the first cryptocurrency as it's shown at the top
                    return _buildCryptoListItem(_cryptoList[index + 1], index == 4);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: Colors.grey),
          ),
          const SizedBox(width: 24),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCrypto() {
    final featured = _cryptoList[0];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: featured.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(featured.iconData, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featured.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    featured.symbol,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      featured.isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: featured.isPositiveChange ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${featured.changePercentage}% (24h)',
                      style: TextStyle(
                        fontSize: 12,
                        color: featured.isPositiveChange ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                height: 40,
                child: CustomPaint(
                  painter: ChartPainter(
                    data: featured.chartData ?? [],
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterButton('All tokens', 0),
          const SizedBox(width: 8),
          _filterButton('Top losers', 1),
          const SizedBox(width: 8),
          _filterButton('Volume', 2),
          const SizedBox(width: 8),
          _filterButton('Market Cap', 3),
        ],
      ),
    );
  }

  Widget _filterButton(String text, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoListItem(CryptoCurrency crypto, bool showSwapButton) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: crypto.iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(crypto.iconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  crypto.symbol,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          if (showSwapButton)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Swap',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${crypto.price?.toStringAsFixed(crypto.price! < 10 ? 2 : 0) ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                if (crypto.changePercentage != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        crypto.isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: crypto.isPositiveChange ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${crypto.changePercentage}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: crypto.isPositiveChange ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class CryptoCurrency {
  final String name;
  final String symbol;
  final double? price;
  final double? changePercentage;
  final bool isPositiveChange;
  final Color iconColor;
  final IconData iconData;
  final List<double>? chartData;

  CryptoCurrency({
    required this.name,
    required this.symbol,
    this.price,
    this.changePercentage,
    required this.isPositiveChange,
    required this.iconColor,
    required this.iconData,
    this.chartData,
  });
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  ChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double maxValue = data.reduce((curr, next) => curr > next ? curr : next);
    final double minValue = data.reduce((curr, next) => curr < next ? curr : next);
    final double range = maxValue - minValue;

    final double stepX = size.width / (data.length - 1);
    
    final Path path = Path();
    path.moveTo(0, size.height - (data[0] - minValue) / range * size.height);

    for (int i = 1; i < data.length; i++) {
      final double x = stepX * i;
      final double y = size.height - (data[i] - minValue) / range * size.height;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
