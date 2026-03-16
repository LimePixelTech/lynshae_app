#!/usr/bin/env node

/**
 * LynShae Backend 部署脚本
 * 提供多种部署模式和实用功能
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// 颜色代码
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  red: '\x1b[31m'
};

const log = {
  info: (msg) => console.log(`${colors.blue}[INFO]${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}[SUCCESS]${colors.reset} ${msg}`),
  warning: (msg) => console.log(`${colors.yellow}[WARNING]${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}[ERROR]${colors.reset} ${msg}`)
};

// 执行命令
const exec = (command, options = {}) => {
  try {
    return execSync(command, { stdio: 'inherit', ...options });
  } catch (error) {
    if (!options.ignoreError) {
      log.error(`命令执行失败：${command}`);
      process.exit(1);
    }
    return null;
  }
};

// 检查命令是否存在
const commandExists = (cmd) => {
  try {
    execSync(`command -v ${cmd}`, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
};

// 生成随机字符串
const randomString = (length = 32) => {
  return crypto.randomBytes(length).toString('hex');
};

// 检查依赖
const checkDependencies = () => {
  log.info('检查系统依赖...');
  
  const required = ['docker'];
  const missing = [];
  
  required.forEach(cmd => {
    if (!commandExists(cmd)) {
      missing.push(cmd);
    }
  });
  
  if (missing.length > 0) {
    log.error(`缺少依赖：${missing.join(', ')}`);
    log.info('请先安装 Docker');
    process.exit(1);
  }
  
  log.success('系统依赖检查通过');
};

// 初始化环境变量
const initEnv = () => {
  const envPath = path.join(__dirname, '..', '.env');
  const envExamplePath = path.join(__dirname, '..', '.env.example');
  
  if (fs.existsSync(envPath)) {
    log.warning('.env 文件已存在');
    
    rl.question('是否覆盖现有配置？(y/N): ', (answer) => {
      if (answer.toLowerCase() === 'y') {
        generateEnvFile(envPath, envExamplePath);
      } else {
        log.info('跳过环境变量配置');
      }
      rl.close();
    });
  } else {
    generateEnvFile(envPath, envExamplePath);
  }
};

const generateEnvFile = (envPath, examplePath) => {
  log.info('生成环境变量配置...');
  
  let envContent = fs.readFileSync(examplePath, 'utf8');
  
  // 替换 JWT Secret
  const jwtSecret = randomString(64);
  envContent = envContent.replace(/JWT_SECRET=.*/, `JWT_SECRET=${jwtSecret}`);
  
  // 生成随机数据库密码
  const dbPassword = randomString(16) + '@A1';
  envContent = envContent.replace(/DB_PASSWORD=.*/g, `DB_PASSWORD=${dbPassword}`);
  
  fs.writeFileSync(envPath, envContent);
  
  log.success('环境变量配置已生成');
  log.warning(`数据库密码：${dbPassword}`);
  log.warning('请妥善保管 .env 文件');
};

// Docker 操作
const docker = {
  up: () => {
    log.info('启动 Docker 服务...');
    exec('docker-compose up -d');
    log.success('服务启动成功');
  },
  
  down: () => {
    log.info('停止 Docker 服务...');
    exec('docker-compose down');
    log.success('服务已停止');
  },
  
  rebuild: () => {
    log.info '重建 Docker 服务...');
    exec('docker-compose down');
    exec('docker-compose up -d --build');
    log.success('服务重建完成');
  },
  
  logs: (service = 'app', follow = true) => {
    const cmd = follow ? `docker-compose logs -f ${service}` : `docker-compose logs ${service}`;
    exec(cmd);
  },
  
  status: () => {
    log.info('服务状态:');
    exec('docker-compose ps');
  }
};

// 数据库操作
const database = {
  init: () => {
    log.info('初始化数据库...');
    exec('docker exec lynshae-mysql mysql -u root -p${DB_PASSWORD} lynshae_db < docker/mysql/init/01_init.sql', {
      ignoreError: true
    });
    log.success('数据库初始化完成');
  },
  
  backup: () => {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupFile = `backups/lynshae_${timestamp}.sql`;
    
    log.info(`备份数据库到 ${backupFile}...`);
    fs.mkdirSync('backups', { recursive: true });
    exec(`docker exec lynshae-mysql mysqldump -u root -p${process.env.DB_PASSWORD} lynshae_db > ${backupFile}`);
    log.success(`数据库已备份：${backupFile}`);
  },
  
  restore: (file) => {
    if (!file) {
      log.error('请指定备份文件');
      return;
    }
    
    log.info(`从 ${file} 恢复数据库...`);
    exec(`docker exec -i lynshae-mysql mysql -u root -p${process.env.DB_PASSWORD} lynshae_db < ${file}`);
    log.success('数据库恢复完成');
  }
};

// 显示帮助
const showHelp = () => {
  console.log(`
${colors.green}LynShae Backend 部署工具${colors.reset}

用法：node scripts/deploy.js [命令] [选项]

命令:
  init          初始化项目（创建配置、安装依赖）
  up            启动服务
  down          停止服务
  restart       重启服务
  rebuild       重建服务
  logs          查看日志
  status        查看服务状态
  db:init       初始化数据库
  db:backup     备份数据库
  db:restore    恢复数据库
  clean         清理容器和卷
  help          显示帮助

示例:
  node scripts/deploy.js init      # 初始化项目
  node scripts/deploy.js up        # 启动服务
  node scripts/deploy.js logs      # 查看日志
  node scripts/deploy.js db:backup # 备份数据库
`);
};

// 主函数
const main = async () => {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (!command || command === 'help') {
    showHelp();
    return;
  }
  
  checkDependencies();
  
  switch (command) {
    case 'init':
      initEnv();
      break;
    case 'up':
      docker.up();
      break;
    case 'down':
      docker.down();
      break;
    case 'restart':
      docker.down();
      docker.up();
      break;
    case 'rebuild':
      docker.rebuild();
      break;
    case 'logs':
      docker.logs(args[1], args[2] !== 'false');
      break;
    case 'status':
      docker.status();
      break;
    case 'db:init':
      database.init();
      break;
    case 'db:backup':
      database.backup();
      break;
    case 'db:restore':
      database.restore(args[1]);
      break;
    case 'clean':
      log.warning('清理所有容器和数据卷...');
      exec('docker-compose down -v');
      log.success('清理完成');
      break;
    default:
      log.error(`未知命令：${command}`);
      showHelp();
  }
  
  if (command !== 'logs') {
    rl.close();
  }
};

main().catch(err => {
  log.error(err.message);
  process.exit(1);
});
