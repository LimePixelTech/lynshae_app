#!/bin/bash

# LynShae 数据库备份脚本

# 配置
DB_HOST="${MYSQL_HOST:-localhost}"
DB_PORT="${MYSQL_PORT:-3306}"
DB_NAME="${MYSQL_DATABASE:-lynshae_db}"
DB_USER="${MYSQL_USER:-lynshae_user}"
DB_PASSWORD="${MYSQL_PASSWORD}"

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# 创建备份目录
mkdir -p ${BACKUP_DIR}

echo "📦 开始备份数据库 ${DB_NAME}..."

# 执行备份
mysqldump \
  -h ${DB_HOST} \
  -P ${DB_PORT} \
  -u ${DB_USER} \
  -p${DB_PASSWORD} \
  --single-transaction \
  --routines \
  --triggers \
  ${DB_NAME} | gzip > ${BACKUP_FILE}

if [ $? -eq 0 ]; then
  BACKUP_SIZE=$(ls -lh ${BACKUP_FILE} | awk '{print $5}')
  echo "✅ 备份完成：${BACKUP_FILE} (${BACKUP_SIZE})"
  
  # 删除 7 天前的备份
  find ${BACKUP_DIR} -name "*.sql.gz" -mtime +7 -delete
  echo "🧹 已清理 7 天前的备份"
else
  echo "❌ 备份失败"
  exit 1
fi
