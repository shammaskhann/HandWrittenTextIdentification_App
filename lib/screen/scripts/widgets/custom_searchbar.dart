import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Color inactiveIconColor;
  final Color hintTextColor;
  final Color textFieldBackgroundColor;
  final Gradient animationGradient;
  final double height;
  final double width;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AnimatedSearchBar({
    super.key,
    this.inactiveIconColor = const Color(0xFFE2F4A6),
    this.hintTextColor = const Color(0xFF8C8C8C),
    this.textFieldBackgroundColor = const Color(0xFF26262A),
    this.animationGradient = const LinearGradient(
      colors: [Color(0xFFE2F4A6), Color(0xFFD9D9D9)],
    ),
    this.height = 50,
    this.width = 300,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  late Animation<double> _clearButtonOpacity;
  late Animation<double> _iconBackgroundWidth;
  late Animation<double> _iconBackgroundRadius;
  late Animation<double> _iconBackgroundOpacity;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _clearButtonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Icon background animations
    _iconBackgroundWidth = Tween<double>(begin: 0, end: widget.height).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconBackgroundRadius =
        Tween<double>(begin: widget.height, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconBackgroundOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(_handleFocusChange);
    widget.controller?.addListener(_handleTextChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() => _isFocused = true);
      _animationController.forward();
    } else {
      setState(() => _isFocused = false);
      if (widget.controller?.text.isEmpty ?? true) {
        _animationController.reverse();
      }
    }
  }

  void _handleTextChange() {
    if (widget.controller?.text.isNotEmpty ?? false) {
      _animationController.forward();
    } else if (!_focusNode.hasFocus) {
      _animationController.reverse();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // TextField Container
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                // Icon background animation
                Positioned(
                  left: 0,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _iconBackgroundOpacity.value,
                        child: Container(
                          width: _iconBackgroundWidth.value,
                          height: widget.height,
                          decoration: BoxDecoration(
                            gradient: widget.animationGradient,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(_iconBackgroundRadius.value),
                              bottomLeft:
                                  Radius.circular(_iconBackgroundRadius.value),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: widget.height / 2 - 13, // Center icon in background
                    right: widget.height / 2, // Space for clear button
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12),
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(color: widget.hintTextColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: _isFocused
                            ? widget.textFieldBackgroundColor
                            : widget.inactiveIconColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom line animation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _lineAnimation,
              builder: (context, child) {
                return Container(
                  height: 2,
                  width: widget.width * _lineAnimation.value,
                  margin: EdgeInsets.only(
                    left: (widget.width - widget.width * _lineAnimation.value) /
                            2 +
                        10,
                    right:
                        (widget.width - widget.width * _lineAnimation.value) /
                            2,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.animationGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),

          // External clear button
          if (widget.controller?.text.isNotEmpty ?? false)
            Positioned(
              right: 0,
              child: FadeTransition(
                opacity: _clearButtonOpacity,
                child: Container(
                  width: widget.height,
                  height: widget.height,
                  alignment: Alignment.center,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () {
                      widget.controller?.clear();
                      widget.onChanged?.call('');
                      if (!_focusNode.hasFocus) {
                        _animationController.reverse();
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
