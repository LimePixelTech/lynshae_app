import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import 'api_client.dart';

/// 商品服务 - 处理商品相关 API 调用
class ProductService {
  static final ApiClient _apiClient = ApiClient();

  /// 获取商品列表（前台展示用）
  static Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 20,
    int? categoryId,
    String? keyword,
    bool? isRecommend,
    bool? isHot,
    bool? isNew,
    String? sort,
    String? order,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (page > 0) queryParams['page'] = page.toString();
      if (limit > 0) queryParams['limit'] = limit.toString();
      if (categoryId != null) queryParams['category_id'] = categoryId.toString();
      if (keyword != null) queryParams['keyword'] = keyword;
      if (isRecommend != null) queryParams['is_recommend'] = isRecommend.toString();
      if (isHot != null) queryParams['is_hot'] = isHot.toString();
      if (isNew != null) queryParams['is_new'] = isNew.toString();
      if (sort != null) queryParams['sort'] = sort;
      if (order != null) queryParams['order'] = order;

      final response = await _apiClient.get(
        '/products',
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final productsJson = data['products'] as List<dynamic>;
        final products = productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
        
        return {
          'success': true,
          'products': products,
          'pagination': data['pagination'],
        };
      } else {
        return {
          'success': false,
          'error': response.message ?? '获取商品失败',
          'products': <ProductModel>[],
          'pagination': {'total': 0, 'page': page, 'limit': limit},
        };
      }
    } catch (e) {
      debugPrint('获取商品列表错误：$e');
      return {
        'success': false,
        'error': '网络错误：${e.toString()}',
        'products': <ProductModel>[],
        'pagination': {'total': 0, 'page': page, 'limit': limit},
      };
    }
  }

  /// 获取商品详情
  static Future<Map<String, dynamic>> getProductDetail(int id) async {
    try {
      final response = await _apiClient.get('/products/$id');

      if (response.success && response.data != null) {
        final product = ProductModel.fromJson(response.data!);
        return {
          'success': true,
          'product': product,
        };
      } else {
        return {
          'success': false,
          'error': response.message ?? '获取商品详情失败',
        };
      }
    } catch (e) {
      debugPrint('获取商品详情错误：$e');
      return {
        'success': false,
        'error': '网络错误：${e.toString()}',
      };
    }
  }

  /// 获取推荐商品
  static Future<List<ProductModel>> getRecommendedProducts({int limit = 10}) async {
    final result = await getProducts(
      isRecommend: true,
      limit: limit,
      sort: 'sort_order',
      order: 'ASC',
    );

    if (result['success'] == true) {
      return result['products'] as List<ProductModel>;
    }
    return [];
  }

  /// 获取热销商品
  static Future<List<ProductModel>> getHotProducts({int limit = 10}) async {
    final result = await getProducts(
      isHot: true,
      limit: limit,
      sort: 'sales_count',
      order: 'DESC',
    );

    if (result['success'] == true) {
      return result['products'] as List<ProductModel>;
    }
    return [];
  }

  /// 获取新品
  static Future<List<ProductModel>> getNewProducts({int limit = 10}) async {
    final result = await getProducts(
      isNew: true,
      limit: limit,
      sort: 'created_at',
      order: 'DESC',
    );

    if (result['success'] == true) {
      return result['products'] as List<ProductModel>;
    }
    return [];
  }

  /// 搜索商品
  static Future<List<ProductModel>> searchProducts(String keyword, {int limit = 20}) async {
    final result = await getProducts(
      keyword: keyword,
      limit: limit,
    );

    if (result['success'] == true) {
      return result['products'] as List<ProductModel>;
    }
    return [];
  }
}
