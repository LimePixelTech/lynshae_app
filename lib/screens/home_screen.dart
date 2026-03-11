import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/product_card.dart';
import 'product_control_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductControlScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.successGreen,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '首页',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              _buildHeaderIcon(Icons.notifications_outlined),
              const SizedBox(width: 12),
              _buildHeaderIcon(Icons.add_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white70,
        size: 22,
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () => _onProductTap(index),
          onPowerToggle: () => _toggleProductPower(index),
        );
      },
    );
  }
}
