import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

/// 商城页面 - 使用真实 API 数据
class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  List<ProductModel> _recommendedProducts = [];
  List<ProductModel> _hotProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 并行加载推荐商品和热销商品
      final results = await Future.wait([
        ProductService.getRecommendedProducts(limit: 10),
        ProductService.getHotProducts(limit: 10),
      ]);

      setState(() {
        _recommendedProducts = results[0];
        _hotProducts = results[1];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadProducts,
                color: AppTheme.primaryBlue,
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
    
    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        _showSearch(context);
      },
      child: Container(
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
      ),
    );
  }

  void _showSearch(BuildContext context) {
    AppUtils.showInfo(context, '搜索功能开发中');
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
            AppUtils.showInfo(context, '${cat['name']} 分类开发中');
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
    
    // 使用 API 返回的推荐商品
    final products = _recommendedProducts.isEmpty 
        ? _getPlaceholderProducts() 
        : _recommendedProducts.take(2).toList();

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
            GestureDetector(
              onTap: () {
                AppUtils.vibrate();
                AppUtils.showInfo(context, '查看全部推荐商品');
              },
              child: Text(
                '查看更多',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                ),
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
                  AppUtils.showSuccess(context, '查看 ${product.name} 详情');
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
                      // 商品图片
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark 
                              ? Colors.white.withAlpha(15) 
                              : AppTheme.warmBeige.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: product.mainImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  product.mainImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.pets_rounded,
                                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                    size: 26,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.pets_rounded,
                                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                size: 26,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.shortDescription ?? '智能设备',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.formattedPrice,
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
        if (_recommendedProducts.isEmpty && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '暂无推荐商品',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
              ),
            ),
          ),
      ],
    );
  }

  List<ProductModel> _getPlaceholderProducts() {
    // 当 API 没有数据时返回占位数据
    return [
      ProductModel(
        id: 1,
        spu: 'LYN-PRO-001',
        name: 'LynShae Pro',
        shortDescription: '旗舰版智能设备',
        price: 2999,
        stock: 100,
        categoryId: 1,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 2,
        spu: 'LYN-LITE-001',
        name: 'LynShae Lite',
        shortDescription: '入门级智能设备',
        price: 1299,
        stock: 200,
        categoryId: 1,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Widget _buildHotSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 使用 API 返回的热销商品
    final products = _hotProducts.isEmpty 
        ? _getHotPlaceholderProducts() 
        : _hotProducts.take(4).toList();

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
            GestureDetector(
              onTap: () {
                AppUtils.vibrate();
                AppUtils.showInfo(context, '查看全部热销商品');
              },
              child: Text(
                '查看更多',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                ),
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
                      AppUtils.showSuccess(context, '查看 ${product.name} 详情');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          // 商品图片
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? Colors.white.withAlpha(15) 
                                  : AppTheme.warmBeige.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: product.mainImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      product.mainImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.shopping_bag_outlined,
                                        color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.shopping_bag_outlined,
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
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '已售 ${product.salesCount}+',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            product.formattedPrice,
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
        if (_hotProducts.isEmpty && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '暂无热销商品',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
              ),
            ),
          ),
      ],
    );
  }

  List<ProductModel> _getHotPlaceholderProducts() {
    return [
      ProductModel(
        id: 3,
        spu: 'LYN-LIGHT-001',
        name: '智能台灯',
        shortDescription: '智能照明',
        price: 299,
        salesCount: 1000,
        stock: 500,
        categoryId: 2,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 4,
        spu: 'LYN-SENSOR-001',
        name: '人体传感器',
        shortDescription: '智能感应',
        price: 99,
        salesCount: 2000,
        stock: 1000,
        categoryId: 3,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 5,
        spu: 'LYN-PLUG-001',
        name: '智能插座',
        shortDescription: '远程控制',
        price: 79,
        salesCount: 3000,
        stock: 800,
        categoryId: 3,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 6,
        spu: 'LYN-TEMP-001',
        name: '温湿度计',
        shortDescription: '环境监测',
        price: 49,
        salesCount: 1500,
        stock: 600,
        categoryId: 3,
        images: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
