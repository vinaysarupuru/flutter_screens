import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SearchBarScreen3()),
    );
  }
}

class SearchBarScreen3 extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final bool isMini;
  const SearchBarScreen3({
    super.key,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.isMini = true,
  });

  @override
  State<SearchBarScreen3> createState() => _SearchBarScreen3State();
}

class _SearchBarScreen3State extends State<SearchBarScreen3>
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

    // Delayed initialization of focus listeners
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _focusNode.addListener(_onFocusChange);
    // });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _animationController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchBar();
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
    if (!_focusNode.hasFocus && _isExpanded && _searchController.text.isEmpty) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
      });
    }
  }

  void _toggleSearch() {
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

  void _clearSearch() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
    } else {
      _onFocusChange();
    }
    // submit
    _onSearchChanged("");
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width:
                  widget.isMini
                      ? (_isExpanded
                          ? MediaQuery.of(context).size.width > 600
                              ? 600
                              : MediaQuery.of(context).size.width - 32
                          : 44)
                      : 600,
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
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search profile items',
              hintStyle: TextStyle(
                color: Colors.grey[350],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            autofocus: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey[500], size: 18),
          onPressed: _clearSearch,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 18,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
