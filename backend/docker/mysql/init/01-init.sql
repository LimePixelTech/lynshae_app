-- ============================================================
-- LynShae 灵羲智能 - 数据库完整初始化脚本
-- MySQL 8.0
-- ============================================================

-- 使用数据库
USE lynshae_db;

-- ============================================================
-- 1. 角色表
-- ============================================================
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL COMMENT '角色名称',
    code VARCHAR(50) UNIQUE NOT NULL COMMENT '角色代码',
    description VARCHAR(255) COMMENT '描述',
    level INT DEFAULT 0 COMMENT '等级',
    permissions JSON COMMENT '权限列表',
    status TINYINT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_roles_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- ============================================================
-- 2. 用户表
-- ============================================================
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    nickname VARCHAR(50),
    gender TINYINT DEFAULT 0 COMMENT '0:未知 1:男 2:女',
    birthday DATE,
    status TINYINT DEFAULT 1 COMMENT '0:禁用 1:正常 2:待激活',
    role_id BIGINT,
    last_login_at DATETIME,
    last_login_ip VARCHAR(45),
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    INDEX idx_users_username (username),
    INDEX idx_users_email (email),
    INDEX idx_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================================
-- 2.1 管理员表
-- ============================================================
DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    role VARCHAR(20) DEFAULT 'admin',
    status TINYINT DEFAULT 1 COMMENT '0:禁用 1:正常',
    last_login_at DATETIME,
    last_login_ip VARCHAR(45),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_admins_username (username),
    INDEX idx_admins_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

-- ============================================================
-- 3. 商品分类表
-- ============================================================
DROP TABLE IF EXISTS product_categories;
CREATE TABLE product_categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    parent_id BIGINT DEFAULT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE,
    icon VARCHAR(255),
    image VARCHAR(500),
    description TEXT,
    sort_order INT DEFAULT 0,
    level INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES product_categories(id) ON DELETE SET NULL,
    INDEX idx_categories_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';

-- ============================================================
-- 4. 品牌表
-- ============================================================
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    logo VARCHAR(500),
    website VARCHAR(255),
    description TEXT,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_brands_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

-- ============================================================
-- 5. 商品表
-- ============================================================
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    spu VARCHAR(50) UNIQUE NOT NULL COMMENT 'SPU 编号',
    name VARCHAR(200) NOT NULL,
    category_id BIGINT,
    brand_id BIGINT,
    short_description VARCHAR(500),
    description TEXT,
    content LONGTEXT COMMENT '商品详情 HTML',
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    warn_stock INT DEFAULT 10,
    unit VARCHAR(20) DEFAULT '件',
    images JSON COMMENT '商品图片数组',
    video_url VARCHAR(500),
    specs JSON COMMENT '规格参数',
    is_new BOOLEAN DEFAULT FALSE,
    is_hot BOOLEAN DEFAULT FALSE,
    is_recommend BOOLEAN DEFAULT FALSE,
    is_on_sale BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    view_count INT DEFAULT 0,
    sales_count INT DEFAULT 0,
    rating DECIMAL(2,1) DEFAULT 5.0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL,
    INDEX idx_products_category (category_id),
    INDEX idx_products_sale (is_on_sale)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- ============================================================
-- 6. 商品 SKU 表
-- ============================================================
DROP TABLE IF EXISTS product_skus;
CREATE TABLE product_skus (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    sku_code VARCHAR(50) UNIQUE NOT NULL,
    specs JSON NOT NULL COMMENT '规格组合',
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    image VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_skus_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SKU 表';

-- ============================================================
-- 7. 设备表
-- ============================================================
DROP TABLE IF EXISTS devices;
CREATE TABLE devices (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    sn VARCHAR(50) UNIQUE NOT NULL COMMENT '序列号',
    device_type VARCHAR(50) NOT NULL COMMENT '设备类型',
    model VARCHAR(100) NOT NULL COMMENT '型号',
    name VARCHAR(100) COMMENT '设备名称',
    firmware_version VARCHAR(20),
    hardware_version VARCHAR(20),
    mac_address VARCHAR(17) UNIQUE,
    battery_level INT COMMENT '电量百分比',
    status TINYINT DEFAULT 0 COMMENT '0:离线 1:在线 2:故障',
    online_at DATETIME,
    owner_id BIGINT,
    activated_at DATETIME,
    config JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_devices_sn (sn),
    INDEX idx_devices_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备表';

-- ============================================================
-- 8. 用户设备绑定表
-- ============================================================
DROP TABLE IF EXISTS user_devices;
CREATE TABLE user_devices (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    device_id BIGINT NOT NULL,
    bind_code VARCHAR(20) UNIQUE,
    is_owner BOOLEAN DEFAULT TRUE,
    permissions JSON,
    bound_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TINYINT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_device (user_id, device_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户设备绑定表';

-- ============================================================
-- 9. 订单表
-- ============================================================
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) UNIQUE NOT NULL,
    user_id BIGINT NOT NULL,
    status TINYINT DEFAULT 0 COMMENT '0:待付款 1:待发货 2:待收货 3:已完成 4:已取消',
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    pay_amount DECIMAL(10,2) NOT NULL,
    pay_type TINYINT,
    pay_time DATETIME,
    receiver_name VARCHAR(50),
    receiver_phone VARCHAR(20),
    receiver_address VARCHAR(500),
    shipping_company VARCHAR(100),
    shipping_no VARCHAR(100),
    remark VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- ============================================================
-- 10. 订单商品表
-- ============================================================
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    sku_id BIGINT,
    product_name VARCHAR(200) NOT NULL,
    product_image VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order_items_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单商品表';

-- ============================================================
-- 11. 刷新令牌表
-- ============================================================
DROP TABLE IF EXISTS refresh_tokens;
CREATE TABLE refresh_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    device_info VARCHAR(255),
    expires_at DATETIME NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_tokens_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='刷新令牌表';

-- ============================================================
-- 12. 操作日志表
-- ============================================================
DROP TABLE IF EXISTS operation_logs;
CREATE TABLE operation_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    module VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    target_id BIGINT,
    old_value JSON,
    new_value JSON,
    ip_address VARCHAR(45),
    status TINYINT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_logs_user (user_id),
    INDEX idx_logs_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ============================================================
-- 初始化数据
-- ============================================================

-- 默认角色
INSERT INTO roles (name, code, level, permissions) VALUES
('超级管理员', 'super_admin', 100, '["*"]'),
('管理员', 'admin', 90, '["product:*", "order:*", "user:view", "device:*"]'),
('普通用户', 'user', 10, '["product:view", "order:create", "device:bind"]');

-- 默认管理员账号 (密码：admin123, bcrypt 加密)
INSERT INTO users (uuid, username, email, password_hash, role_id, status, email_verified) VALUES
('00000000-0000-0000-0000-000000000001', 'admin', 'admin@lynshae.com',
'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.G.2fYzNvN3qLqO', 1, 1, TRUE),
('00000000-0000-0000-0000-000000000002', 'test', 'test@lynshae.com',
'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.G.2fYzNvN3qLqO', 3, 1, TRUE);

-- 默认管理员账号 (密码：123456, bcrypt 加密)
INSERT INTO admins (uuid, username, email, password, role, status) VALUES
('11111111-1111-1111-1111-111111111111', 'admin', 'admin@lynshae.com',
'$2a$10$rHkz8E9q5ZJxN3X4vU7Wb.2yLpMnKqRs8YwT6HfVjC9XmZaBcDeFgG', 'super_admin', 1),
('22222222-2222-2222-2222-222222222222', 'test', 'test@lynshae.com',
'$2a$10$rHkz8E9q5ZJxN3X4vU7Wb.2yLpMnKqRs8YwT6HfVjC9XmZaBcDeFgG', 'admin', 1);

-- 默认商品分类
INSERT INTO product_categories (name, code, level, sort_order) VALUES
('机器狗', 'robot_dog', 1, 1),
('配件', 'accessories', 1, 2),
('传感器', 'sensors', 1, 3),
('摄像头', 'cameras', 1, 4);

-- 默认品牌
INSERT INTO brands (name, sort_order) VALUES
('LynShae', 1),
('Generic', 2);

-- ============================================================
-- 完成提示
-- ============================================================
SELECT '✅ LynShae 数据库初始化完成！' AS message;
