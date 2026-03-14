-- =====================================================
-- LynShae 商品管理系统 - 数据库初始化脚本
-- =====================================================
-- 执行顺序：按文件名排序依次执行
-- 字符集：utf8mb4 (支持 emoji 和特殊字符)
-- =====================================================

-- 创建数据库（如果通过环境变量已创建则跳过）
-- CREATE DATABASE IF NOT EXISTS `lynshae_db` 
-- DEFAULT CHARACTER SET utf8mb4 
-- COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE `lynshae_db`;

-- =====================================================
-- 1. 管理员表
-- =====================================================
CREATE TABLE IF NOT EXISTS `admins` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码 (bcrypt)',
    `email` VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像',
    `role` TINYINT UNSIGNED DEFAULT 1 COMMENT '角色：1=超级管理员，2=普通管理员',
    `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
    `last_login_at` TIMESTAMP NULL DEFAULT NULL COMMENT '最后登录时间',
    `last_login_ip` VARCHAR(45) DEFAULT NULL COMMENT '最后登录 IP',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_username` (`username`),
    INDEX `idx_email` (`email`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

-- =====================================================
-- 2. 商品分类表
-- =====================================================
CREATE TABLE IF NOT EXISTS `categories` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL COMMENT '分类名称',
    `parent_id` INT UNSIGNED DEFAULT NULL COMMENT '父分类 ID',
    `icon` VARCHAR(255) DEFAULT NULL COMMENT '分类图标',
    `level` TINYINT UNSIGNED DEFAULT 1 COMMENT '分类层级',
    `sort_order` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_parent_id` (`parent_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';

-- =====================================================
-- 3. 品牌表
-- =====================================================
CREATE TABLE IF NOT EXISTS `brands` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL COMMENT '品牌名称',
    `logo` VARCHAR(255) DEFAULT NULL COMMENT '品牌 Logo',
    `description` TEXT COMMENT '品牌描述',
    `website` VARCHAR(255) DEFAULT NULL COMMENT '官方网站',
    `sort_order` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

-- =====================================================
-- 4. 商品表
-- =====================================================
CREATE TABLE IF NOT EXISTS `products` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(200) NOT NULL COMMENT '商品名称',
    `category_id` INT UNSIGNED NOT NULL COMMENT '分类 ID',
    `brand_id` INT UNSIGNED DEFAULT NULL COMMENT '品牌 ID',
    `sku` VARCHAR(50) UNIQUE NOT NULL COMMENT '商品编码',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '销售价格',
    `original_price` DECIMAL(10,2) DEFAULT NULL COMMENT '原价/划线价',
    `cost_price` DECIMAL(10,2) DEFAULT NULL COMMENT '成本价',
    `stock` INT UNSIGNED DEFAULT 0 COMMENT '库存数量',
    `sales` INT UNSIGNED DEFAULT 0 COMMENT '销量',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '商品简介',
    `details` TEXT COMMENT '详细介绍 (HTML)',
    `main_image` VARCHAR(500) DEFAULT NULL COMMENT '主图 URL',
    `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=上架，0=下架',
    `is_recommend` TINYINT UNSIGNED DEFAULT 0 COMMENT '是否推荐',
    `is_hot` TINYINT UNSIGNED DEFAULT 0 COMMENT '是否热销',
    `is_new` TINYINT UNSIGNED DEFAULT 0 COMMENT '是否新品',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL COMMENT '软删除时间',
    INDEX `idx_category_id` (`category_id`),
    INDEX `idx_brand_id` (`brand_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_sku` (`sku`),
    INDEX `idx_price` (`price`),
    INDEX `idx_created` (`created_at`),
    INDEX `idx_recommend` (`is_recommend`),
    INDEX `idx_hot` (`is_hot`),
    INDEX `idx_new` (`is_new`),
    FULLTEXT INDEX `ft_name_description` (`name`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- =====================================================
-- 5. 商品图片表
-- =====================================================
CREATE TABLE IF NOT EXISTS `product_images` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT UNSIGNED NOT NULL COMMENT '商品 ID',
    `url` VARCHAR(500) NOT NULL COMMENT '图片 URL',
    `sort_order` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `is_primary` TINYINT UNSIGNED DEFAULT 0 COMMENT '是否主图',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_primary` (`is_primary`),
    CONSTRAINT `fk_product_images_product` 
        FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品图片表';

-- =====================================================
-- 6. 商品规格表
-- =====================================================
CREATE TABLE IF NOT EXISTS `product_specs` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT UNSIGNED NOT NULL COMMENT '商品 ID',
    `spec_name` VARCHAR(50) NOT NULL COMMENT '规格名称',
    `spec_value` VARCHAR(200) NOT NULL COMMENT '规格值',
    `sort_order` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_product_id` (`product_id`),
    CONSTRAINT `fk_product_specs_product` 
        FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格表';

-- =====================================================
-- 7. 商品 SKU 表
-- =====================================================
CREATE TABLE IF NOT EXISTS `product_skus` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT UNSIGNED NOT NULL COMMENT '商品 ID',
    `sku_code` VARCHAR(50) NOT NULL COMMENT 'SKU 编码',
    `specs` JSON COMMENT '规格组合 (JSON)',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格',
    `stock` INT UNSIGNED DEFAULT 0 COMMENT '库存',
    `image` VARCHAR(500) DEFAULT NULL COMMENT 'SKU 图片',
    `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '状态',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_sku_code` (`sku_code`),
    CONSTRAINT `fk_product_skus_product` 
        FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SKU 表';

-- =====================================================
-- 8. 操作日志表
-- =====================================================
CREATE TABLE IF NOT EXISTS `operation_logs` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `admin_id` INT UNSIGNED DEFAULT NULL COMMENT '管理员 ID',
    `action` VARCHAR(100) NOT NULL COMMENT '操作类型',
    `module` VARCHAR(50) DEFAULT NULL COMMENT '模块',
    `request_method` VARCHAR(10) DEFAULT NULL COMMENT '请求方法',
    `request_url` VARCHAR(500) DEFAULT NULL COMMENT '请求 URL',
    `request_params` TEXT COMMENT '请求参数',
    `response_code` INT UNSIGNED DEFAULT NULL COMMENT '响应码',
    `ip_address` VARCHAR(45) DEFAULT NULL COMMENT 'IP 地址',
    `user_agent` VARCHAR(500) DEFAULT NULL COMMENT 'User-Agent',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_admin_id` (`admin_id`),
    INDEX `idx_action` (`action`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- =====================================================
-- 9. 系统配置表
-- =====================================================
CREATE TABLE IF NOT EXISTS `system_configs` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `config_key` VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    `config_value` TEXT COMMENT '配置值',
    `config_type` VARCHAR(20) DEFAULT 'string' COMMENT '配置类型',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '配置说明',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- =====================================================
-- 初始化数据
-- =====================================================

-- 插入默认管理员 (密码：admin123, bcrypt 加密)
INSERT INTO `admins` (`username`, `password`, `email`, `role`, `status`) VALUES
('admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.G.2fYzNvN3qLqO', 'admin@lynshae.com', 1, 1);

-- 插入默认分类
INSERT INTO `categories` (`name`, `parent_id`, `level`, `sort_order`, `status`) VALUES
('机器狗', NULL, 1, 1, 1),
('配件', NULL, 1, 2, 1),
('智能设备', NULL, 1, 3, 1),
('其他', NULL, 1, 4, 1);

-- 插入默认品牌
INSERT INTO `brands` (`name`, `description`, `sort_order`, `status`) VALUES
('LynShae', '灵羲智能品牌', 1, 1),
('Generic', '通用品牌', 2, 1);

-- 插入系统配置
INSERT INTO `system_configs` (`config_key`, `config_value`, `config_type`, `description`) VALUES
('site_name', 'LynShae 商品管理系统', 'string', '系统名称'),
('site_logo', '/assets/logo.png', 'string', '系统 Logo'),
('copyright', '© 2026 LynShae. All rights reserved.', 'string', '版权信息'),
('max_upload_size', '10485760', 'number', '最大上传文件大小 (字节)'),
('items_per_page', '20', 'number', '默认每页显示数量');

-- =====================================================
-- 视图：商品完整信息视图
-- =====================================================
CREATE OR REPLACE VIEW `v_products_full` AS
SELECT 
    p.*,
    c.name AS category_name,
    c.icon AS category_icon,
    b.name AS brand_name,
    b.logo AS brand_logo,
    (SELECT COUNT(*) FROM product_images pi WHERE pi.product_id = p.id) AS image_count,
    (SELECT GROUP_CONCAT(pi.url ORDER BY pi.sort_order SEPARATOR ',') 
     FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1 LIMIT 1) AS primary_image
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN brands b ON p.brand_id = b.id
WHERE p.deleted_at IS NULL;

-- =====================================================
-- 存储过程：更新商品库存
-- =====================================================
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `sp_update_product_stock`(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_operation VARCHAR(10)
)
BEGIN
    DECLARE v_current_stock INT;
    
    SELECT stock INTO v_current_stock FROM products WHERE id = p_product_id;
    
    IF p_operation = 'increase' THEN
        UPDATE products SET stock = stock + p_quantity WHERE id = p_product_id;
    ELSEIF p_operation = 'decrease' THEN
        IF v_current_stock >= p_quantity THEN
            UPDATE products SET stock = stock - p_quantity WHERE id = p_product_id;
        ELSE
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = '库存不足';
        END IF;
    END IF;
END //
DELIMITER ;

-- =====================================================
-- 触发器：商品删除时记录日志
-- =====================================================
DELIMITER //
CREATE TRIGGER IF NOT EXISTS `tr_product_soft_delete`
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        INSERT INTO operation_logs (action, module, request_method, request_url)
        VALUES ('soft_delete', 'products', 'DELETE', CONCAT('/products/', OLD.id));
    END IF;
END //
DELIMITER ;

-- =====================================================
-- 完成提示
-- =====================================================
SELECT '✅ LynShae 数据库初始化完成!' AS message;
