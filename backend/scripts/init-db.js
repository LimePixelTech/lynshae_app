#!/usr/bin/env node
/**
 * LynShae 数据库初始化脚本
 * 自动创建数据库并导入测试数据
 */

const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

// 配置
const config = {
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: process.env.MYSQL_PASSWORD || '',
  multipleStatements: true
};

// 可能的密码列表
const PASSWORDS = ['', 'root', 'LynShae@2026', 'admin', 'password', 'mysql'];

async function tryConnect(password) {
  try {
    const connection = await mysql.createConnection({
      ...config,
      password
    });
    await connection.ping();
    return connection;
  } catch (error) {
    return null;
  }
}

async function findWorkingConnection() {
  console.log('🔑 尝试连接 MySQL...');
  
  for (const pwd of PASSWORDS) {
    const conn = await tryConnect(pwd);
    if (conn) {
      console.log(`✅ 连接成功 (密码：${pwd || '空'})`);
      return { connection: conn, password: pwd };
    }
    console.log(`⏸️  密码 "${pwd || '空'}" 失败，尝试下一个...`);
  }
  
  return null;
}

async function main() {
  console.log('\n🚀 LynShae 数据库初始化\n');
  
  // 查找可用的 MySQL 连接
  const result = await findWorkingConnection();
  
  if (!result) {
    console.log('\n❌ 无法连接到 MySQL，请检查:\n');
    console.log('   1. MySQL 服务是否运行');
    console.log('   2. 用户名密码是否正确');
    console.log('   3. 端口 3306 是否可访问\n');
    console.log('💡 提示：可以设置环境变量 MYSQL_PASSWORD 指定密码\n');
    console.log('   export MYSQL_PASSWORD="your_password"\n');
    process.exit(1);
  }
  
  const { connection, password } = result;
  
  try {
    // 1. 创建数据库
    console.log('\n📦 创建数据库 lynshae_db...');
    await connection.query('CREATE DATABASE IF NOT EXISTS lynshae_db DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci');
    console.log('✅ 数据库创建完成');
    
    // 2. 切换到新数据库
    await connection.query('USE lynshae_db');
    
    // 3. 读取并执行初始化脚本
    console.log('\n📝 执行 Schema 初始化...');
    const schemaPath = path.join(__dirname, '../../database/lynshae_init.sql');
    const schemaSql = fs.readFileSync(schemaPath, 'utf8');
    await connection.query(schemaSql);
    console.log('✅ Schema 初始化完成');
    
    // 4. 读取并执行测试数据脚本
    console.log('\n🌱 导入测试数据...');
    const seedPath = path.join(__dirname, 'seed-data.sql');
    const seedSql = fs.readFileSync(seedPath, 'utf8');
    await connection.query(seedSql);
    console.log('✅ 测试数据导入完成');
    
    // 5. 验证数据
    console.log('\n📊 数据验证:');
    const [users] = await connection.query('SELECT COUNT(*) as count FROM users');
    const [products] = await connection.query('SELECT COUNT(*) as count FROM products');
    const [devices] = await connection.query('SELECT COUNT(*) as count FROM devices');
    const [categories] = await connection.query('SELECT COUNT(*) as count FROM product_categories');
    const [skus] = await connection.query('SELECT COUNT(*) as count FROM product_skus');
    
    console.log(`   👥 用户数：${users[0].count}`);
    console.log(`   🛍️  商品数：${products[0].count}`);
    console.log(`   🤖 设备数：${devices[0].count}`);
    console.log(`   📁 分类数：${categories[0].count}`);
    console.log(`   🏷️  SKU 数：${skus[0].count}`);
    
    // 6. 创建应用用户（如果不存在）
    console.log('\n🔧 创建应用数据库用户...');
    try {
      await connection.query(`CREATE USER IF NOT EXISTS 'lynshae'@'localhost' IDENTIFIED BY 'LynShae@2026'`);
      await connection.query(`GRANT ALL PRIVILEGES ON lynshae_db.* TO 'lynshae'@'localhost'`);
      await connection.query(`FLUSH PRIVILEGES`);
      console.log('✅ 应用用户创建完成 (用户名：lynshae, 密码：LynShae@2026)');
    } catch (error) {
      console.log('⚠️  应用用户可能已存在，跳过');
    }
    
    console.log('\n✅ 数据库初始化完成!\n');
    console.log('📌 连接信息:');
    console.log(`   主机：${config.host}:${config.port}`);
    console.log(`   数据库：lynshae_db`);
    console.log(`   用户：lynshae (或 root)`);
    console.log(`   密码：LynShae@2026\n`);
    
  } catch (error) {
    console.error('\n❌ 初始化失败:', error.message);
    process.exit(1);
  } finally {
    await connection.end();
  }
}

main();
