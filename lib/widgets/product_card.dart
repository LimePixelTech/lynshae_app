import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.darkBorder,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
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
                _buildIconBox(),
                _buildPowerButton(),
              ],
            ),
            const Spacer(),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        product.type.icon,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  Widget _buildPowerButton() {
    return GestureDetector(
      onTap: onPowerToggle,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: product.isOn
              ? AppTheme.successGreen
              : Colors.white.withAlpha(30),
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          color: product.isOn
              ? Colors.white
              : Colors.white54,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          product.type.name,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
