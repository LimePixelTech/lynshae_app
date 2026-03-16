/**
 * 上传路由
 */
const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { upload } = require('../middleware/upload');
const path = require('path');
const fs = require('fs');
const { AppError } = require('../middleware/errorHandler');

/**
 * @route POST /api/upload/image
 * @desc 上传单张图片
 * @access Private
 */
router.post('/image', authenticate, upload.single('image'), (req, res, next) => {
  try {
    if (!req.file) {
      throw new AppError('请上传图片文件', 400, 'NO_FILE_UPLOADED');
    }

    const relativePath = `/uploads/${req.file.path.replace(/\\/g, '/').split('uploads/')[1]}`;

    res.json({
      success: true,
      message: '上传成功',
      data: {
        url: relativePath,
        filename: req.file.filename,
        size: req.file.size,
        mimetype: req.file.mimetype,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route POST /api/upload/images
 * @desc 上传多张图片
 * @access Private
 */
router.post('/images', authenticate, upload.array('images', 20), (req, res, next) => {
  try {
    if (!req.files || req.files.length === 0) {
      throw new AppError('请上传至少一张图片', 400, 'NO_FILES_UPLOADED');
    }

    const files = req.files.map(file => ({
      url: `/uploads/${file.path.replace(/\\/g, '/').split('uploads/')[1]}`,
      filename: file.filename,
      size: file.size,
      mimetype: file.mimetype,
    }));

    res.json({
      success: true,
      message: `成功上传 ${files.length} 张图片`,
      data: {
        count: files.length,
        files,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @route DELETE /api/upload/:filename
 * @desc 删除上传的文件
 * @access Private
 */
router.delete('/:filename', authenticate, (req, res, next) => {
  try {
    const { filename } = req.params;
    const uploadPath = path.join(__dirname, '../../uploads', filename);

    if (!fs.existsSync(uploadPath)) {
      throw new AppError('文件不存在', 404, 'FILE_NOT_FOUND');
    }

    fs.unlinkSync(uploadPath);

    res.json({
      success: true,
      message: '文件删除成功',
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
