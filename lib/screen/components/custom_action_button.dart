import 'package:flutter/material.dart';

class CustomActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Default colors
    const Color defaultBackgroundColor = Color(0xFF26262A);
    final Color defaultTextColor = Colors.white.withOpacity(0.4);

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? defaultBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: (widget.backgroundColor ?? defaultBackgroundColor)
                    .withOpacity(_isHovering ? 0.4 : 0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.textColor ?? defaultTextColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.textColor ?? defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
