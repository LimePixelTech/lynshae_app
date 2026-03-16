/**
 * 设备路由
 */

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');

// 所有设备路由都需要认证
router.use(authenticate);

// TODO: 实现设备控制器
router.get('/', (req, res) => {
  res.json({ code: 'SUCCESS', message: '设备列表（待实现）' });
});

router.get('/:id', (req, res) => {
  res.json({ code: 'SUCCESS', message: '设备详情（待实现）' });
});

router.post('/:id/bind', (req, res) => {
  res.json({ code: 'SUCCESS', message: '绑定设备（待实现）' });
});

router.post('/:id/control', (req, res) => {
  res.json({ code: 'SUCCESS', message: '控制设备（待实现）' });
});

module.exports = router;
