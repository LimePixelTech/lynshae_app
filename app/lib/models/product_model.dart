/// 商品模型
class ProductModel {
  final int id;
  final String spu;
  final String name;
  final String? shortDescription;
  final String? content;
  final double price;
  final double? originalPrice;
  final int stock;
  final String? unit;
  final List<String> images;
  final String? videoUrl;
  final int categoryId;
  final String? categoryName;
  final String? brand;
  final String? model;
  final bool isNew;
  final bool isHot;
  final bool isRecommend;
  final bool isOnSale;
  final int sortOrder;
  final int viewCount;
  final int salesCount;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.spu,
    required this.name,
    this.shortDescription,
    this.content,
    required this.price,
    this.originalPrice,
    required this.stock,
    this.unit,
    this.images = const [],
    this.videoUrl,
    required this.categoryId,
    this.categoryName,
    this.brand,
    this.model,
    this.isNew = false,
    this.isHot = false,
    this.isRecommend = false,
    this.isOnSale = true,
    this.sortOrder = 0,
    this.viewCount = 0,
    this.salesCount = 0,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 处理图片字段（可能是字符串或列表）
    List<String> images = [];
    if (json['images'] != null) {
      if (json['images'] is String) {
        // 如果是逗号分隔的字符串
        images = (json['images'] as String).split(',').where((s) => s.isNotEmpty).toList();
      } else if (json['images'] is List) {
        images = (json['images'] as List).map((e) => e.toString()).toList();
      }
    }

    return ProductModel(
      id: json['id'] ?? 0,
      spu: json['spu'] ?? '',
      name: json['name'] ?? '',
      shortDescription: json['short_description'],
      content: json['content'],
      price: _parseDouble(json['price']) ?? 0.0,
      originalPrice: _parseDouble(json['original_price']),
      stock: json['stock'] ?? 0,
      unit: json['unit'] ?? '件',
      images: images,
      videoUrl: json['video_url'],
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'],
      brand: json['brand'],
      model: json['model'],
      isNew: json['is_new'] == true || json['is_new'] == 1,
      isHot: json['is_hot'] == true || json['is_hot'] == 1,
      isRecommend: json['is_recommend'] == true || json['is_recommend'] == 1,
      isOnSale: json['is_on_sale'] == true || json['is_on_sale'] == 1,
      sortOrder: json['sort_order'] ?? 0,
      viewCount: json['view_count'] ?? 0,
      salesCount: json['sales_count'] ?? 0,
      rating: _parseDouble(json['rating']) ?? 0.0,
      createdAt: json['created_at'] != null 
          ? (json['created_at'] is DateTime ? json['created_at'] : DateTime.parse(json['created_at']))
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? (json['updated_at'] is DateTime ? json['updated_at'] : DateTime.parse(json['updated_at']))
          : DateTime.now(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spu': spu,
      'name': name,
      'short_description': shortDescription,
      'content': content,
      'price': price,
      'original_price': originalPrice,
      'stock': stock,
      'unit': unit,
      'images': images,
      'video_url': videoUrl,
      'category_id': categoryId,
      'category_name': categoryName,
      'brand': brand,
      'model': model,
      'is_new': isNew,
      'is_hot': isHot,
      'is_recommend': isRecommend,
      'is_on_sale': isOnSale,
      'sort_order': sortOrder,
      'view_count': viewCount,
      'sales_count': salesCount,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 获取格式化价格
  String get formattedPrice {
    final priceStr = price.toStringAsFixed(0);
    return '¥$priceStr';
  }

  /// 获取格式化原价
  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    final originalPriceStr = originalPrice!.toStringAsFixed(0);
    return '¥$originalPriceStr';
  }

  /// 获取折扣
  String? get discount {
    if (originalPrice == null || originalPrice! <= 0) return null;
    final discountValue = (price / originalPrice! * 10).round();
    return '$discountValue 折';
  }

  /// 获取主图
  String? get mainImage {
    return images.isNotEmpty ? images.first : null;
  }
}
