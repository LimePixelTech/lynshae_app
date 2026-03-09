import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import 'product_control_screen.dart';

/// 产品类型枚举
enum ProductType {
  robotDog('机器狗', Icons.pets_rounded, Color(0xFF00D4FF)),
  robotCat('机器猫', Icons.smart_toy_rounded, Color(0xFFFF6B6B)),
  smartClock('智能闹钟', Icons.access_alarm_rounded, Color(0xFFFFD93D)),
  smartLamp('智能台灯', Icons.lightbulb_rounded, Color(0xFF6BCB77)),
  airPurifier('空气净化器', Icons.air_rounded, Color(0xFF4D96FF));

  final String name;
  final IconData icon;
  final Color color;

  const ProductType(this.name, this.icon, this.color);
}

/// 产品模型
class Product {
  final String id;
  final String name;
  final ProductType type;
  final DeviceModel? device;
  final bool isOnline;
  final int batteryLevel;
  final bool isOn;

  Product({
    required this.id,
    required this.name,
    required this.type,
    this.device,
    this.isOnline = false,
    this.batteryLevel = 0,
    this.isOn = false,
  });

  Product copyWith({
    String? id,
    String? name,
    ProductType? type,
    DeviceModel? device,
    bool? isOnline,
    int? batteryLevel,
    bool? isOn,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      device: device ?? this.device,
      isOnline: isOnline ?? this.isOnline,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isOn: isOn ?? this.isOn,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 多产品列表
  List<Product> products = [
    Product(
      id: 'dog_001',
      name: 'LynShae',
      type: ProductType.robotDog,
      isOnline: true,
      batteryLevel: 78,
      isOn: true,
    ),
    Product(
      id: 'cat_001',
      name: 'MeowBot',
      type: ProductType.robotCat,
      isOnline: true,
      batteryLevel: 65,
      isOn: true,
    ),
    Product(
      id: 'clock_001',
      name: '晨曦',
      type: ProductType.smartClock,
      isOnline: true,
      batteryLevel: 100,
      isOn: true,
    ),
    Product(
      id: 'lamp_001',
      name: '护眼灯',
      type: ProductType.smartLamp,
      isOnline: false,
      batteryLevel: 0,
      isOn: false,
    ),
  ];

  bool isRefreshing = false;
  int selectedProductIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          products = products.map((p) {
            if (p.isOnline && p.batteryLevel > 0) {
              return p.copyWith(
                batteryLevel: (p.batteryLevel - 1).clamp(0, 100),
              );
            }
            return p;
          }).toList();
        });
        _startAutoRefresh();
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        isRefreshing = false;
      });
      AppUtils.showSuccess(context, '设备状态已更新');
    }
  }

  void _toggleProductPower(int index) {
    setState(() {
      final product = products[index];
      products[index] = product.copyWith(
        isOn: !product.isOn,
        isOnline: !product.isOn,
      );
    });
    AppUtils.vibrate();
    AppUtils.showSuccess(
      context,
      '${products[index].name} ${products[index].isOn ? '已开启' : '已关闭'}',
    );
  }

  void _onProductTap(int index) {
    setState(() {
      selectedProductIndex = index;
    });
    final product = products[index];

    // 导航到产品控制页面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductControlScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.primaryBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductGrid(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '灵羲',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 在线设备统计
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.successGreen.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${products.where((p) => p.isOnline).length}/${products.length} 设备在线',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '局域网连接',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '我的设备',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final product = products[index];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = selectedProductIndex == index;

    return GestureDetector(
      onTap: () => _onProductTap(index),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderColor: isSelected
            ? product.type.color.withOpacity(0.5)
            : Colors.white.withOpacity(isDark ? 0.1 : 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: product.type.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    product.type.icon,
                    color: product.type.color,
                    size: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleProductPower(index),
                  child: Container(
                    width: 36,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: product.isOn
                          ? AppTheme.successGreen
                          : theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: product.isOn
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              product.name,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              product.type.name,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  product.batteryLevel > 20
                      ? Icons.battery_full_rounded
                      : Icons.battery_alert_rounded,
                  color: product.batteryLevel > 20
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  product.type == ProductType.smartClock ||
                          product.type == ProductType.smartLamp
                      ? (product.isOn ? '运行中' : '已关闭')
                      : '${product.batteryLevel}%',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: product.isOnline
                        ? AppTheme.successGreen
                        : AppTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快捷操作',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionButton(
              icon: Icons.power_settings_new_rounded,
              label: '全部开启',
              color: AppTheme.successGreen,
              onTap: () {
                setState(() {
                  products = products.map((p) =>
                    p.copyWith(isOn: true, isOnline: true)
                  ).toList();
                });
                AppUtils.showSuccess(context, '全部设备已开启');
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.power_off_rounded,
              label: '全部关闭',
              color: AppTheme.errorRed,
              onTap: () {
                setState(() {
                  products = products.map((p) =>
                    p.copyWith(isOn: false)
                  ).toList();
                });
                AppUtils.showSuccess(context, '全部设备已关闭');
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.add_rounded,
              label: '添加设备',
              color: AppTheme.primaryBlue,
              onTap: () {
                AppUtils.showInfo(context, '添加设备功能开发中');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 18),
          borderColor: color.withOpacity(0.25),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSceneSection() {
    final theme = Theme.of(context);

    final scenes = [
      {'name': '起床模式', 'icon': Icons.wb_sunny_rounded, 'color': Color(0xFFFFD93D)},
      {'name': '睡眠模式', 'icon': Icons.bedtime_rounded, 'color': Color(0xFF6C5CE7)},
      {'name': '离家模式', 'icon': Icons.home_rounded, 'color': Color(0xFF00D4FF)},
      {'name': '回家模式', 'icon': Icons.door_front_door_rounded, 'color': Color(0xFF4ADE80)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '智能场景',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: scenes.length,
          itemBuilder: (context, index) {
            final scene = scenes[index];
            final color = scene['color'] as Color;
            return GestureDetector(
              onTap: () {
                AppUtils.showSuccess(context, '${scene['name']}已激活');
              },
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                borderColor: color.withOpacity(0.3),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        scene['icon'] as IconData,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      scene['name'] as String,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
