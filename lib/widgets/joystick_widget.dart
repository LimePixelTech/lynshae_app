import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 虚拟摇杆控件 - 玻璃质感
class JoystickWidget extends StatefulWidget {
  final Function(double angle, double distance) onChange;
  final double size;
  final bool isDisabled;

  const JoystickWidget({
    super.key,
    required this.onChange,
    this.size = 180,
    this.isDisabled = false,
  });

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _stickX = 0;
  double _stickY = 0;
  bool _isDragging = false;

  void _onPanStart(DragStartDetails details) {
    if (widget.isDisabled) return;
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isDisabled) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final center = Offset(renderBox.size.width / 2, renderBox.size.height / 2);
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final maxRadius = widget.size / 2 - 35;

    final distance = math.min(math.sqrt(dx * dx + dy * dy), maxRadius);
    final angle = math.atan2(dy, dx);

    setState(() {
      _stickX = math.cos(angle) * distance;
      _stickY = math.sin(angle) * distance;
    });

    widget.onChange(angle, distance / maxRadius);
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isDisabled) return;
    setState(() {
      _isDragging = false;
      _stickX = 0;
      _stickY = 0;
    });
    widget.onChange(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final opacity = widget.isDisabled ? 0.4 : 1.0;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(_stickX, _stickY, 0),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(
                              _isDragging ? 0.5 : 0.3),
                          blurRadius: _isDragging ? 20 : 12,
                          spreadRadius: _isDragging ? 2 : 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.gamepad_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
