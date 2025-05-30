import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewScriptButton extends StatefulWidget {
  final RxBool openModelSelection;
  final Color buttonBackgroundClr;
  final Color buttonTextClr;
  final VoidCallback onMyTap;
  final VoidCallback onCnnTap;
  final VoidCallback onTransformerTap;
  final String buttonText;

  final Color lightGreenClr;
  final Color lightPinkClr;
  final Color lightYellowClr;

  const NewScriptButton({
    super.key,
    required this.openModelSelection,
    required this.buttonBackgroundClr,
    required this.buttonTextClr,
    required this.onMyTap,
    required this.onCnnTap,
    required this.onTransformerTap,
    required this.lightGreenClr,
    required this.lightPinkClr,
    required this.lightYellowClr,
    this.buttonText = 'New Script',
  });

  @override
  State<NewScriptButton> createState() => _NewScriptButtonState();
}

class _NewScriptButtonState extends State<NewScriptButton>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _slides;
  final List<bool> _isHovered = [false, false, false];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
    );
    _opacities = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _slides = _controllers
        .map((c) => Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    widget.openModelSelection.listen((open) {
      if (open) {
        _runStaggeredIn();
      } else {
        _runStaggeredOut();
      }
    });
  }

  void _runStaggeredIn() async {
    for (int i = 2; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 80));
      _controllers[i].forward();
    }
  }

  void _runStaggeredOut() async {
    for (int i = 0; i < 3; i++) {
      _controllers[i].reverse();
      await Future.delayed(const Duration(milliseconds: 60));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                child: widget.openModelSelection.value
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.buttonBackgroundClr,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildAnimatedOption(
                                index: 0,
                                color: widget.lightGreenClr,
                                text: "Character Recognition by ML",
                                onTap: widget.onMyTap,
                              ),
                              _buildAnimatedOption(
                                index: 1,
                                color: widget.lightPinkClr,
                                text: "Character Recognition by CNN",
                                onTap: widget.onCnnTap,
                              ),
                              _buildAnimatedOption(
                                index: 2,
                                color: widget.lightYellowClr,
                                text: "Word Recognition by OCR Model",
                                onTap: widget.onTransformerTap,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: GestureDetector(
              onTap: () {
                widget.openModelSelection.value =
                    !widget.openModelSelection.value;
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: widget.buttonBackgroundClr,
                  borderRadius: BorderRadius.only(
                    topLeft: widget.openModelSelection.value
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    topRight: widget.openModelSelection.value
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.buttonBackgroundClr.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: widget.buttonTextClr),
                    const SizedBox(width: 8),
                    Text(
                      widget.buttonText,
                      style: TextStyle(color: widget.buttonTextClr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOption({
    required int index,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _controllers[index],
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedOpacity(
            opacity: _opacities[index].value,
            duration: const Duration(milliseconds: 200),
            child: AnimatedSlide(
              offset: _slides[index].value,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered[index] = true),
                onExit: (_) => setState(() => _isHovered[index] = false),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(_isHovered[index] ? 0.7 : 0.4),
                          Colors.black.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        width: 1.5,
                        style: BorderStyle.solid,
                        color: color.withOpacity(_isHovered[index] ? 1 : 0.8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.15),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
