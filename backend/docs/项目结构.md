# LynShae 后端项目结构

```
backend/
├── 📄 README.md                    # 项目说明文档
├── 📄 package.json                 # Node.js 依赖配置
├── 📄 .env.example                 # 环境变量示例
├── 📄 .gitignore                   # Git 忽略配置
├── 📄 docker-compose.yml           # Docker Compose 配置 (开发)
├── 📄 docker-compose.prod.yml      # Docker Compose 配置 (生产)
│
├── 📁 src/                         # 源代码目录
│   ├── 📄 server.js                # 应用入口文件
│   │
│   ├── 📁 config/                  # 配置文件
│   │   ├── 📄 index.js             # 主配置
│   │   ├── 📄 database.js          # MySQL 连接池
│   │   └── 📄 redis.js             # Redis 客户端
│   │
│   ├── 📁 controllers/             # 控制器 (业务逻辑)
│   │   ├── 📄 auth.controller.js   # 认证控制器
│   │   ├── 📄 product.controller.js # 商品控制器
│   │   ├── 📄 category.controller.js # 分类控制器
│   │   ├── 📄 brand.controller.js  # 品牌控制器
│   │   └── 📄 system.controller.js # 系统控制器
│   │
│   ├── 📁 middleware/              # 中间件
│   │   ├── 📄 auth.js              # JWT 认证
│   │   ├── 📄 errorHandler.js      # 错误处理
│   │   ├── 📄 rateLimiter.js       # 速率限制
│   │   ├── 📄 validate.js          # 数据验证
│   │   └── 📄 upload.js            # 文件上传
│   │
│   ├── 📁 models/                  # 数据模型 (可选，本项目的 SQL 直接在控制器中)
│   │
│   ├── 📁 routes/                  # 路由定义
│   │   ├── 📄 auth.routes.js       # 认证路由
│   │   ├── 📄 product.routes.js    # 商品路由
│   │   ├── 📄 category.routes.js   # 分类路由
│   │   ├── 📄 brand.routes.js      # 品牌路由
│   │   ├── 📄 upload.routes.js     # 上传路由
│   │   └── 📄 system.routes.js     # 系统路由
│   │
│   ├── 📁 services/                # 服务层 (复杂业务逻辑)
│   │
│   ├── 📁 utils/                   # 工具函数
│   │   └── 📄 logger.js            # 日志工具
│   │
│   └── 📁 validators/              # 验证规则 (可选，已在路由中定义)
│
├── 📁 docker/                      # Docker 配置
│   ├── 📁 app/                     # API 服务
│   │   └── 📄 Dockerfile
│   ├── 📁 admin/                   # 管理后台
│   │   ├── 📄 Dockerfile
│   │   └── 📄 nginx.conf
│   ├── 📁 mysql/                   # MySQL
│   │   ├── 📁 init/                # 初始化脚本
│   │   │   └── 📄 01-init-schema.sql
│   │   └── 📁 conf/                # 配置文件
│   │       └── 📄 my.cnf
│   └── 📁 nginx/                   # Nginx 反向代理
│       └── 📄 nginx.conf
│
├── 📁 docs/                        # 文档
│   └── 📄 API.md                   # API 接口文档
│
├── 📁 scripts/                     # 脚本
│   └── 📄 backup-db.sh             # 数据库备份
│
├── 📁 uploads/                     # 上传文件 (运行时创建)
│
├── 📁 logs/                        # 日志文件 (运行时创建)
│
└── 📁 tests/                       # 测试文件 (待添加)
    ├── 📄 auth.test.js
    ├── 📄 product.test.js
    └── 📄 category.test.js
```

## 目录说明

### src/
核心源代码目录，遵循 MVC 模式组织代码。

### docker/
Docker 相关配置，包含各服务的 Dockerfile 和配置文件。

### docs/
项目文档，包括 API 文档、部署指南等。

### scripts/
运维脚本，如数据库备份、数据迁移等。

## 文件命名规范

- 控制器：`*.controller.js`
- 路由：`*.routes.js`
- 中间件：`*.js` (在 middleware 目录中)
- 配置：`*.js` (在 config 目录中)

## 代码风格

- 使用 ES6+ 语法
- 使用 async/await 处理异步
- 统一使用单引号
- 缩进 2 空格
- 文件名使用小写 + 连字符
