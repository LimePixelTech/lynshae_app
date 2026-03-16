-- ============================================================
-- LynShae Backend 测试数据脚本
-- 用于前后端通信测试
-- 创建时间：2026-03-14
-- ============================================================

USE lynshae_db;

-- ============================================================
-- 1. 清理现有测试数据 (可选)
-- ============================================================
-- DELETE FROM user_coupons;
-- DELETE FROM coupons;
-- DELETE FROM order_items;
-- DELETE FROM orders;
-- DELETE FROM device_logs;
-- DELETE FROM user_devices;
-- DELETE FROM devices;
-- DELETE FROM product_skus;
-- DELETE FROM products;
-- DELETE FROM product_categories;
-- DELETE FROM articles;
-- DELETE FROM operation_logs;
-- DELETE FROM refresh_tokens;
-- DELETE FROM users WHERE role_id != 1;
-- DELETE FROM roles WHERE id > 3;

-- ============================================================
-- 2. 测试用户数据
-- ============================================================
-- 使用 bcrypt 生成的密码哈希 (密码：123456)
-- $2b$10$rHx9zK5V.jP3qL8mN2oP4uV6wX8yZ0aB1cD2eF3gH4iJ5kL6mN7oP

INSERT INTO users (uuid, username, email, password_hash, nickname, avatar, role_id, status, email_verified, created_at) VALUES
('usr-001-test-uuid', 'testuser', 'test@lynshae.com', 
'$2b$10$rHx9zK5V.jP3qL8mN2oP4uV6wX8yZ0aB1cD2eF3gH4iJ5kL6mN7oP', 
'测试用户', '/avatars/default.png', 3, 1, TRUE, NOW()),
('usr-002-test-uuid', 'demo', 'demo@lynshae.com', 
'$2b$10$rHx9zK5V.jP3qL8mN2oP4uV6wX8yZ0aB1cD2eF3gH4iJ5kL6mN7oP', 
'演示用户', '/avatars/demo.png', 3, 1, TRUE, NOW()),
('usr-003-test-uuid', 'vipuser', 'vip@lynshae.com', 
'$2b$10$rHx9zK5V.jP3qL8mN2oP4uV6wX8yZ0aB1cD2eF3gH4iJ5kL6mN7oP', 
'VIP 用户', '/avatars/vip.png', 3, 1, TRUE, NOW());

-- ============================================================
-- 3. 测试商品分类
-- ============================================================
INSERT INTO product_categories (name, code, icon, description, level, sort_order, is_active) VALUES
('机器狗', 'robot_dog', '🤖', '智能机器狗系列产品', 1, 1, TRUE),
('配件', 'accessories', '🔧', '机器狗配件和周边', 1, 2, TRUE),
('传感器', 'sensors', '📡', '各类传感器模块', 1, 3, TRUE),
('摄像头', 'cameras', '📷', '智能摄像头设备', 1, 4, TRUE),
('运动相机', 'action_camera', '🎥', '运动相机系列', 2, 5, TRUE);

-- ============================================================
-- 4. 测试商品数据
-- ============================================================
INSERT INTO products (spu, name, category_id, brand, model, short_description, description, price, original_price, stock, images, specs, is_new, is_hot, is_recommend, is_on_sale, sort_order) VALUES
-- 机器狗系列
('SPU-RD-001', '灵羲机器狗 Pro', 1, 'LynShae', 'LS-Pro-X1', 
'高性能四足智能机器狗，专业级运动控制', 
'灵羲机器狗 Pro 采用先进的运动控制算法，支持多种运动模式，具备优秀的地形适应能力。配备高清摄像头和多种传感器，可用于教育、科研、安防等多种场景。',
9999.00, 12999.00, 100, 
'["/products/robot-dog-pro-1.jpg", "/products/robot-dog-pro-2.jpg", "/products/robot-dog-pro-3.jpg"]',
'{"尺寸": "450x280x320mm", "重量": "3.5kg", "续航": "2 小时", "最大速度": "3m/s", "自由度": "12DOF"}',
TRUE, TRUE, TRUE, TRUE, 1),

('SPU-RD-002', '灵羲机器狗 Lite', 1, 'LynShae', 'LS-Lite-S1', 
'入门级智能机器狗，适合教育和娱乐', 
'灵羲机器狗 Lite 是专为教育和娱乐设计的入门级产品。具备基础的运动能力和交互功能，价格亲民，适合学生和爱好者。',
4999.00, 5999.00, 200, 
'["/products/robot-dog-lite-1.jpg", "/products/robot-dog-lite-2.jpg"]',
'{"尺寸": "350x220x250mm", "重量": "2.0kg", "续航": "1.5 小时", "最大速度": "2m/s", "自由度": "8DOF"}',
TRUE, FALSE, TRUE, TRUE, 2),

('SPU-RD-003', '灵羲机器狗 Mini', 1, 'LynShae', 'LS-Mini-C1', 
'迷你版机器狗，便携易携带', 
'灵羲机器狗 Mini 是最小巧的机器狗产品，可以轻松放入口袋。虽然体积小，但功能齐全，适合随身携带。',
2999.00, 3499.00, 300, 
'["/products/robot-dog-mini-1.jpg"]',
'{"尺寸": "200x120x150mm", "重量": "0.8kg", "续航": "1 小时", "最大速度": "1.5m/s", "自由度": "6DOF"}',
FALSE, FALSE, FALSE, TRUE, 3),

-- 配件系列
('SPU-AC-001', '机器狗专用电池', 2, 'LynShae', 'LS-BAT-5000', 
'5000mAh 大容量锂电池', 
'专为灵羲机器狗设计的高容量锂电池，支持快速充电，续航时间更长。',
299.00, 399.00, 500, 
'["/products/battery-1.jpg"]',
'{"容量": "5000mAh", "电压": "14.8V", "充电时间": "2 小时"}',
FALSE, FALSE, FALSE, TRUE, 4),

('SPU-AC-002', '机器狗保护壳', 2, 'LynShae', 'LS-CASE-PRO', 
'防摔防水保护壳', 
'高强度材料制成的保护壳，有效保护机器狗免受碰撞和水的侵害。',
199.00, 249.00, 400, 
'["/products/case-1.jpg"]',
'{"材质": "PC+ABS", "防水等级": "IP65", "重量": "200g"}',
FALSE, FALSE, FALSE, TRUE, 5),

('SPU-AC-003', '机器狗背包', 2, 'LynShae', 'LS-BAG-001', 
'专用便携背包', 
'为机器狗量身定制的便携背包，方便携带和收纳。',
149.00, 199.00, 300, 
'["/products/bag-1.jpg"]',
'{"尺寸": "500x350x200mm", "材质": "尼龙", "颜色": "黑色"}',
FALSE, FALSE, FALSE, TRUE, 6),

-- 传感器系列
('SPU-SN-001', '激光雷达传感器', 3, 'LynShae', 'LS-LiDAR-360', 
'360 度激光雷达', 
'高精度 360 度激光雷达，适用于 SLAM 建图和避障。',
1999.00, 2499.00, 100, 
'["/products/lidar-1.jpg"]',
'{"扫描范围": "360°", "测距精度": "±2cm", "最大距离": "25m"}',
TRUE, FALSE, TRUE, TRUE, 7),

('SPU-SN-002', '超声波传感器', 3, 'LynShae', 'LS-US-001', 
'超声波测距模块', 
'超声波测距传感器，用于近距离障碍物检测。',
99.00, 149.00, 600, 
'["/products/ultrasonic-1.jpg"]',
'{"测距范围": "2cm-4m", "精度": "±1cm", "工作电压": "5V"}',
FALSE, FALSE, FALSE, TRUE, 8),

-- 摄像头系列
('SPU-CM-001', '4K 运动相机', 4, 'LynShae', 'LS-CAM-4K', 
'4K 超高清运动相机', 
'支持 4K 60fps 视频录制，配备防抖功能，适合机器狗第一视角拍摄。',
899.00, 1199.00, 200, 
'["/products/camera-4k-1.jpg", "/products/camera-4k-2.jpg"]',
'{"分辨率": "4K 60fps", "防抖": "电子防抖", "存储": "支持 TF 卡"}',
TRUE, TRUE, TRUE, TRUE, 9),

('SPU-CM-002', '红外夜视摄像头', 4, 'LynShae', 'LS-CAM-IR', 
'红外夜视监控摄像头', 
'支持红外夜视功能，可在完全黑暗环境下拍摄。',
399.00, 499.00, 250, 
'["/products/camera-ir-1.jpg"]',
'{"夜视距离": "10m", "分辨率": "1080P", "视角": "120°"}',
FALSE, FALSE, FALSE, TRUE, 10);

-- ============================================================
-- 5. 测试商品 SKU 数据
-- ============================================================
INSERT INTO product_skus (product_id, sku_code, specs, price, stock, image) VALUES
-- 机器狗 Pro SKU
(1, 'SKU-RD-PRO-BLK', '{"color": "黑色", "battery": "标准版"}', 9999.00, 50, '/products/robot-dog-pro-black.jpg'),
(1, 'SKU-RD-PRO-WHT', '{"color": "白色", "battery": "标准版"}', 9999.00, 30, '/products/robot-dog-pro-white.jpg'),
(1, 'SKU-RD-PRO-BLK-PLUS', '{"color": "黑色", "battery": "长续航版"}', 10999.00, 20, '/products/robot-dog-pro-black-plus.jpg'),

-- 机器狗 Lite SKU
(2, 'SKU-RD-LITE-BLU', '{"color": "蓝色", "battery": "标准版"}', 4999.00, 100, '/products/robot-dog-lite-blue.jpg'),
(2, 'SKU-RD-LITE-PNK', '{"color": "粉色", "battery": "标准版"}', 4999.00, 100, '/products/robot-dog-lite-pink.jpg'),

-- 机器狗 Mini SKU
(3, 'SKU-RD-MINI-GRN', '{"color": "绿色"}', 2999.00, 150, '/products/robot-dog-mini-green.jpg'),
(3, 'SKU-RD-MINI-ORG', '{"color": "橙色"}', 2999.00, 150, '/products/robot-dog-mini-orange.jpg'),

-- 电池 SKU
(4, 'SKU-BAT-STD', '{"type": "标准版"}', 299.00, 300, '/products/battery-std.jpg'),
(4, 'SKU-BAT-PRO', '{"type": "长续航版"}', 399.00, 200, '/products/battery-pro.jpg'),

-- 保护壳 SKU
(5, 'SKU-CASE-BLK', '{"color": "黑色"}', 199.00, 200, '/products/case-black.jpg'),
(5, 'SKU-CASE-RED', '{"color": "红色"}', 199.00, 200, '/products/case-red.jpg'),

-- 激光雷达 SKU
(7, 'SKU-LIDAR-STD', '{"version": "标准版"}', 1999.00, 50, '/products/lidar-std.jpg'),
(7, 'SKU-LIDAR-PRO', '{"version": "专业版"}', 2499.00, 50, '/products/lidar-pro.jpg'),

-- 4K 相机 SKU
(9, 'SKU-CAM-4K-STD', '{"storage": "无卡"}', 899.00, 100, '/products/camera-4k-std.jpg'),
(9, 'SKU-CAM-4K-64G', '{"storage": "64G 卡"}', 999.00, 100, '/products/camera-4k-64g.jpg');

-- ============================================================
-- 6. 测试设备数据
-- ============================================================
INSERT INTO devices (sn, device_type, model, name, firmware_version, hardware_version, mac_address, battery_level, status, owner_id, activated_at, warranty_expires) VALUES
('LS-DOG-2026-001', 'robot_dog', 'LS-Pro-X1', '小黑', 'v1.2.0', 'v1.0', 'AA:BB:CC:DD:EE:01', 85, 1, 4, NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR)),
('LS-DOG-2026-002', 'robot_dog', 'LS-Lite-S1', '小白', 'v1.1.5', 'v1.0', 'AA:BB:CC:DD:EE:02', 92, 1, 5, NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR)),
('LS-CAM-2026-001', 'camera', 'LS-CAM-4K', '摄像头 01', 'v2.0.1', 'v1.0', 'AA:BB:CC:DD:EE:03', 100, 1, 4, NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR)),
('LS-DOG-2026-003', 'robot_dog', 'LS-Mini-C1', '迷你狗', 'v1.0.8', 'v1.0', 'AA:BB:CC:DD:EE:04', 45, 0, NULL, NULL, DATE_ADD(NOW(), INTERVAL 1 YEAR)),
('LS-DOG-2026-004', 'robot_dog', 'LS-Pro-X1', '测试机', 'v1.2.0', 'v1.0', 'AA:BB:CC:DD:EE:05', 10, 2, NULL, NULL, DATE_ADD(NOW(), INTERVAL 1 YEAR));

-- ============================================================
-- 7. 测试用户设备绑定
-- ============================================================
INSERT INTO user_devices (user_id, device_id, bind_code, is_owner, bound_at, status) VALUES
(4, 1, 'BIND-001-XYZ', TRUE, NOW(), 1),
(4, 3, 'BIND-003-ABC', TRUE, NOW(), 1),
(5, 2, 'BIND-002-DEF', TRUE, NOW(), 1);

-- ============================================================
-- 8. 测试优惠券
-- ============================================================
INSERT INTO coupons (code, name, type, value, min_amount, total_count, used_count, per_user_limit, valid_from, valid_to, status) VALUES
('NEWUSER2026', '新用户优惠券', 1, 100.00, 500.00, 1000, 0, 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 1),
('SPRING2026', '春季促销', 2, 0.15, 1000.00, 500, 0, 1, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 1),
('VIP500', 'VIP 专享券', 1, 500.00, 2000.00, 100, 0, 1, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY), 1);

-- ============================================================
-- 9. 测试文章/新闻
-- ============================================================
INSERT INTO articles (title, category, cover, summary, content, author_id, view_count, is_published, published_at) VALUES
('灵羲机器狗 Pro 正式发布', 'news', '/articles/news-001.jpg', 
'灵羲科技今日正式发布新一代机器狗 Pro，性能全面提升...', 
'<h1>灵羲机器狗 Pro 正式发布</h1><p>灵羲科技今日正式发布新一代机器狗 Pro，性能全面提升...</p>', 
1, 1250, TRUE, NOW()),
('机器狗使用入门指南', 'guide', '/articles/guide-001.jpg', 
'新手必读：如何快速上手你的灵羲机器狗...', 
'<h1>机器狗使用入门指南</h1><p>新手必读：如何快速上手你的灵羲机器狗...</p>', 
1, 3500, TRUE, NOW()),
('常见问题解答', 'faq', '/articles/faq-001.jpg', 
'关于灵羲机器狗的常见问题及解答...', 
'<h1>常见问题解答</h1><p>关于灵羲机器狗的常见问题及解答...</p>', 
1, 2800, TRUE, NOW());

-- ============================================================
-- 10. 测试订单 (可选)
-- ============================================================
-- INSERT INTO orders (order_no, user_id, status, total_amount, discount_amount, pay_amount, pay_type, pay_time, receiver_name, receiver_phone, receiver_address) VALUES
-- ('ORD20260314120000001', 4, 3, 9999.00, 100.00, 9899.00, 1, NOW(), '张三', '13800138000', '北京市朝阳区 xx 街道 xx 号'),
-- ('ORD20260314120000002', 5, 1, 4999.00, 0.00, 4999.00, 2, NULL, '李四', '13900139000', '上海市浦东新区 xx 路 xx 号');

-- INSERT INTO order_items (order_id, product_id, sku_id, product_name, price, quantity, total_price) VALUES
-- (1, 1, 1, '灵羲机器狗 Pro', 9999.00, 1, 9999.00),
-- (2, 2, 4, '灵羲机器狗 Lite', 4999.00, 1, 4999.00);

-- ============================================================
-- 完成提示
-- ============================================================
SELECT '测试数据插入完成！' as message;
SELECT '用户数：' as info, COUNT(*) as count FROM users;
SELECT '商品数：' as info, COUNT(*) as count FROM products;
SELECT '设备数：' as info, COUNT(*) as count FROM devices;
SELECT '分类数：' as info, COUNT(*) as count FROM product_categories;
SELECT 'SKU 数：' as info, COUNT(*) as count FROM product_skus;
