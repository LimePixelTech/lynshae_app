import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../models/product_model.dart';

/// 产品卡片组件
/// 用于首页显示产品/设备信息
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onPowerToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onPowerToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(40)
                  : AppTheme.warmBrown.withAlpha(15),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconBox(isDark),
                _buildPowerButton(isDark),
              ],
            ),
            const SizedBox(height: 8),
            _buildProductInfo(isDark),
            const SizedBox(height: 6),
            _buildBatteryRow(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withAlpha(20)
            : AppTheme.warmBeige.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        product.type.icon,
        color: isDark ? Colors.white : AppTheme.warmBrown,
        size: 22,
      ),
    );
  }

  Widget _buildPowerButton(bool isDark) {
    return GestureDetector(
      onTap: onPowerToggle,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: product.isOn
              ? AppTheme.successGreen
              : (isDark ? Colors.white.withAlpha(30) : AppTheme.gray300),
          border: Border.all(
            color: product.isOn
                ? AppTheme.successGreen
                : (isDark ? Colors.white.withAlpha(50) : AppTheme.gray400),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          color: product.isOn
              ? Colors.white
              : (isDark ? Colors.white70 : AppTheme.gray600),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildProductInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          product.type.name,
          style: TextStyle(
            color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryRow(bool isDark) {
    final batteryLevel = product.batteryLevel;
    final batteryColor = AppUtils.getBatteryColor(batteryLevel);

    return Row(
      children: [
        Icon(
          product.isOn ? Icons.bolt_rounded : Icons.battery_alert_outlined,
          color: product.isOn ? batteryColor : (isDark ? Colors.white30 : AppTheme.lightTextMuted),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          '$batteryLevel%',
          style: TextStyle(
            color: product.isOn ? batteryColor : (isDark ? Colors.white30 : AppTheme.lightTextMuted),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (!product.isOnline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '离线',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
