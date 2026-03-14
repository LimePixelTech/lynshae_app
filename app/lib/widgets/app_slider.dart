import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 通用滑块组件
/// 统一的滑块样式，支持自定义颜色
class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final int? divisions;
  final String? label;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.activeColor,
    this.divisions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppTheme.primaryBlue;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: color,
        thumbColor: color,
        inactiveTrackColor: color.withAlpha(51),
        overlayColor: color.withAlpha(31),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}

/// 带刻度的滑块组件
/// 用于显示有明确档位的滑块
class SegmentedSlider extends StatelessWidget {
  final int value;
  final int segments;
  final ValueChanged<int> onChanged;
  final Color? activeColor;
  final List<String>? labels;

  const SegmentedSlider({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.activeColor,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppTheme.primaryBlue;
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withAlpha(51),
            overlayColor: color.withAlpha(31),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: segments.toDouble(),
            divisions: segments,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        if (labels != null && labels!.length == segments + 1) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels!.map((label) {
                return Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(128),
                    fontSize: 11,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
