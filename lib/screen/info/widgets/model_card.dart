import 'dart:developer';

import 'package:flutter/material.dart';

class ModelCard extends StatefulWidget {
  final String title;
  final String description;
  final Color primaryColor;
  final bool isSelected;
  final bool isHovering;
  final VoidCallback onTap;
  final Function(bool) onHover;
  final bool isMobile;
  final bool isTablet;
  final bool isWide;

  const ModelCard({
    Key? key,
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.isSelected,
    required this.isHovering,
    required this.onTap,
    required this.onHover,
    this.isMobile = false,
    this.isTablet = false,
    this.isWide = false,
  }) : super(key: key);

  @override
  State<ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.isMobile
        ? MediaQuery.of(context).size.width - 32
        : widget.isTablet
            ? (widget.isWide ? MediaQuery.of(context).size.width - 64 : 300)
            // : MediaQuery.of(context).size.width / 3 - 100;
            : 460.clamp(300, 460).toDouble();
    log("Card Width: $cardWidth");
    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: cardWidth.toDouble(),
          height: widget.isMobile ? 250 : 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin:
                  widget.isHovering ? Alignment.centerRight : Alignment.topLeft,
              end: widget.isHovering
                  ? Alignment.centerLeft
                  : Alignment.bottomRight,
              colors: [
                widget.primaryColor.withOpacity(widget.isSelected ? 0.7 : 0.4),
                // Colors.white.withOpacity(0.1),
                Colors.black.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              width: 2,
              style: BorderStyle.solid,
              color: widget.primaryColor.withOpacity(0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor
                    .withOpacity(widget.isSelected ? 0.3 : 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 18 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: widget.primaryColor.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 14 : 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                if (widget.isSelected)
                  Icon(
                    Icons.check_circle,
                    color: widget.primaryColor,
                    size: widget.isMobile ? 28 : 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
