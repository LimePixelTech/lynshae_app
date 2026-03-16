/**
 * 文件上传中间件
 */

const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

// 确保上传目录存在
const uploadDir = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// 存储配置
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // 按日期创建子目录
    const date = new Date().toISOString().split('T')[0];
    const dateDir = path.join(uploadDir, date);
    
    if (!fs.existsSync(dateDir)) {
      fs.mkdirSync(dateDir, { recursive: true });
    }
    
    cb(null, dateDir);
  },
  filename: (req, file, cb) => {
    // 生成唯一文件名
    const ext = path.extname(file.originalname);
    const filename = `${uuidv4()}${ext}`;
    cb(null, filename);
  }
});

// 文件过滤
const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png|gif|webp/;
  const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = allowedTypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb(new Error('只允许上传图片文件 (jpeg, jpg, png, gif, webp)'));
  }
};

// 创建上传实例
const upload = multer({
  storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 10 * 1024 * 1024 // 10MB
  },
  fileFilter
});

// 单文件上传中间件
const uploadSingle = (fieldName) => {
  return upload.single(fieldName);
};

// 多文件上传中间件
const uploadArray = (fieldName, maxCount) => {
  return upload.array(fieldName, maxCount);
};

// 多字段上传中间件
const uploadFields = (fields) => {
  return upload.fields(fields);
};

// 文件删除工具
const deleteFile = (filePath) => {
  const fullPath = path.join(__dirname, '../../', filePath);
  if (fs.existsSync(fullPath)) {
    fs.unlinkSync(fullPath);
  }
};

// 获取文件 URL
const getFileUrl = (filePath) => {
  const baseUrl = process.env.APP_URL || `http://localhost:${process.env.PORT || 3000}`;
  return `${baseUrl}${filePath}`;
};

module.exports = {
  upload,
  uploadSingle,
  uploadArray,
  uploadFields,
  deleteFile,
  getFileUrl
};
