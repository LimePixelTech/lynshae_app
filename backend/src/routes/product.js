/**
 * 商品路由
 */

const express = require('express');
const router = express.Router();
const { body, query: queryValidator } = require('express-validator');
const productController = require('../controllers/product');
const { authenticate, requireRole } = require('../middleware/auth');
const { uploadSingle, uploadArray } = require('../middleware/upload');

// 公开路由
router.get('/', productController.getProducts);
router.get('/:id', productController.getProductById);
router.get('/category/:categoryId', productController.getProductsByCategory);

// 需要认证的路由
router.use(authenticate);

// 商品管理（需要管理员权限）
router.post('/', 
  requireRole('admin', 'super_admin'),
  uploadArray('images', 10),
  [
    body('name').trim().notEmpty().withMessage('商品名称不能为空'),
    body('price').isFloat({ min: 0 }).withMessage('价格必须大于等于 0'),
    body('category_id').optional().isInt().withMessage('分类 ID 必须是整数')
  ],
  productController.createProduct
);

router.put('/:id',
  requireRole('admin', 'super_admin'),
  uploadArray('images', 10),
  productController.updateProduct
);

router.delete('/:id',
  requireRole('admin', 'super_admin'),
  productController.deleteProduct
);

// 商品上架/下架
router.patch('/:id/sale',
  requireRole('admin', 'super_admin'),
  body('isOnSale').isBoolean().withMessage('isOnSale 必须是布尔值'),
  productController.toggleSale
);

// SKU 管理
router.post('/:id/skus',
  requireRole('admin', 'super_admin'),
  productController.createSku
);

router.put('/:id/skus/:skuId',
  requireRole('admin', 'super_admin'),
  productController.updateSku
);

router.delete('/:id/skus/:skuId',
  requireRole('admin', 'super_admin'),
  productController.deleteSku
);

// 分类管理
router.get('/categories', productController.getCategories);
router.post('/categories',
  requireRole('admin', 'super_admin'),
  productController.createCategory
);

module.exports = router;
