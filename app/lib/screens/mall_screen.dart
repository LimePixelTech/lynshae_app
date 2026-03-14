import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

/// 商城页面 - 米家风格产品展示
class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 顶部标题
              _buildHeader(context),
              const SizedBox(height: 20),
              // 搜索栏
              _buildSearchBar(context),
              const SizedBox(height: 20),
              // 横幅广告
              _buildBanner(),
              const SizedBox(height: 20),
              // 分类入口
              _buildCategories(context),
              const SizedBox(height: 24),
              // 推荐产品
              _buildRecommendedSection(context),
              const SizedBox(height: 24),
              // 热销产品
              _buildHotSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildHeaderIcon(Icons.notifications_outlined, isDark),
        const SizedBox(width: 12),
        _buildHeaderIcon(Icons.shopping_cart_outlined, isDark),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withAlpha(20)
            : AppTheme.warmBeige.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
        size: 22,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_outlined,
            color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            '搜索商品',
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B7CFF), Color(0xFF00C6FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '新品上市',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'LynShae Pro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '智能设备 全新升级',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final categories = [
      {'icon': Icons.pets_rounded, 'name': '智能设备'},
      {'icon': Icons.smart_toy_rounded, 'name': '机器人'},
      {'icon': Icons.lightbulb_rounded, 'name': '智能灯'},
      {'icon': Icons.sensors_rounded, 'name': '传感器'},
      {'icon': Icons.camera_alt_rounded, 'name': '摄像头'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((cat) {
        return GestureDetector(
          onTap: () {
            AppUtils.vibrate();
          },
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withAlpha(15) 
                      : AppTheme.warmBeige.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['name'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final products = [
      {
        'name': 'LynShae Pro',
        'desc': '旗舰版智能设备',
        'price': '¥2,999',
        'icon': Icons.pets_rounded,
      },
      {
        'name': 'LynShae Lite',
        'desc': '入门级智能设备',
        'price': '¥1,299',
        'icon': Icons.pets_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '推荐产品',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
              ),
            ),
            Text(
              '查看更多',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: products.map((product) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  AppUtils.vibrate();
                  AppUtils.showSuccess(context, '查看 ${product['name']} 详情');
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark 
                              ? Colors.white.withAlpha(15) 
                              : AppTheme.warmBeige.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          product['icon'] as IconData,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['desc'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product['price'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHotSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final products = [
      {
        'name': '智能台灯',
        'price': '¥299',
        'icon': Icons.lightbulb_outline,
      },
      {
        'name': '人体传感器',
        'price': '¥99',
        'icon': Icons.sensors,
      },
      {
        'name': '智能插座',
        'price': '¥79',
        'icon': Icons.electrical_services,
      },
      {
        'name': '温湿度计',
        'price': '¥49',
        'icon': Icons.thermostat,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '热销产品',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
              ),
            ),
            Text(
              '查看更多',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              width: 0.5,
            ),
          ),
          child: Column(
            children: products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppUtils.vibrate();
                      AppUtils.showSuccess(context, '查看 ${product['name']} 详情');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? Colors.white.withAlpha(15) 
                                  : AppTheme.warmBeige.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              product['icon'] as IconData,
                              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '已售 1000+',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            product['price'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.successGreen,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < products.length - 1)
                    Divider(
                      height: 1,
                      indent: 80,
                      endIndent: 16,
                      color: isDark ? Colors.white.withAlpha(10) : AppTheme.warmBeige.withAlpha(15),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
