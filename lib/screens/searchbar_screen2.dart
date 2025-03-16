import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: CustomSearchBar2()),
    );
  }
}

class CustomSearchBar2 extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final bool isMini;

  const CustomSearchBar2({
    super.key,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.isMini = true,
  });

  @override
  State<CustomSearchBar2> createState() => _CustomSearchBar2State();
}

class _CustomSearchBar2State extends State<CustomSearchBar2>
    with SingleTickerProviderStateMixin {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // If not in mini mode, start expanded
    _isExpanded = !widget.isMini;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    // Add focus listener
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _animationController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      // Execute search function here
      print('Searching for: $query');
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(query);
      }
    });
  }

  void _onSubmitted(String value) {
    print('Submitted search: $value');
    // Execute search immediately on submit
    if (widget.onSearchSubmitted != null) {
      widget.onSearchSubmitted!(value);
    }
  }

  void _onFocusChange() {
    // Only collapse if:
    // 1. We lose focus
    // 2. In mini mode
    // 3. Currently expanded
    // 4. There is no text in the search field
    if (!_focusNode.hasFocus &&
        widget.isMini &&
        _isExpanded &&
        _searchController.text.isEmpty) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
      });
    }
  }

  void _toggleSearch() {
    // Only toggle if in mini mode
    if (widget.isMini) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
          _searchController.clear();
        }
      });
    }
  }

  void _clearSearch() {
    // Only clear text without collapsing
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width:
                  _isExpanded
                      ? MediaQuery.of(context).size.width > 600
                          ? 600
                          : MediaQuery.of(context).size.width - 32
                      : 44,
              constraints: const BoxConstraints(minWidth: 44),
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child:
                  widget.isMini
                      ? (_isExpanded
                          ? _buildExpandedSearchBar()
                          : _buildCollapsedSearchIcon())
                      : _buildExpandedSearchBar(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsedSearchIcon() {
    return InkWell(
      onTap: _toggleSearch,
      child: Center(
        child: Icon(Icons.search, color: Colors.grey[500], size: 18),
      ),
    );
  }

  Widget _buildExpandedSearchBar() {
    return Row(
      children: [
        const SizedBox(width: 14),
        Icon(Icons.search, color: Colors.grey[500], size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            onSubmitted: _onSubmitted,
            decoration: InputDecoration(
              hintText: 'Search for something',
              hintStyle: TextStyle(
                color: Colors.grey[350],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            autofocus: true, // Focus automatically when expanded
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey[500], size: 18),
          onPressed: _clearSearch, // Changed to only clear text
        ),
        Container(
          width: 40,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.zero),
          ),
          child: Center(
            child: Icon(Icons.menu, color: Colors.grey[800], size: 18),
          ),
        ),
      ],
    );
  }
}
