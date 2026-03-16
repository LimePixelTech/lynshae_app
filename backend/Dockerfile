# LynShae Backend Dockerfile
# 使用阿里云镜像源加速

# 第一阶段：安装依赖
FROM node:18-slim as builder

WORKDIR /app

# 使用阿里云 apt 源和 npm 源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

RUN npm config set registry https://registry.npmmirror.com && \
    npm ci && \
    npm cache clean --force

# 第二阶段：运行环境
FROM node:18-slim

WORKDIR /app

# 使用阿里云 apt 源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && apt-get install -y --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 从构建阶段复制 node_modules
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# 复制源代码
COPY . .

# 创建上传和日志目录
RUN mkdir -p uploads logs

# 暴露端口
EXPOSE 3005

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3005/health || exit 1

# 启动命令
CMD ["node", "src/server.js"]
