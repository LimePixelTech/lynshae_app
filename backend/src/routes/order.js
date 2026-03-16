/**
 * 订单路由
 */

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');

router.use(authenticate);

// TODO: 实现订单控制器
router.get('/', (req, res) => {
  res.json({ code: 'SUCCESS', message: '订单列表（待实现）' });
});

router.get('/:id', (req, res) => {
  res.json({ code: 'SUCCESS', message: '订单详情（待实现）' });
});

router.post('/', (req, res) => {
  res.json({ code: 'SUCCESS', message: '创建订单（待实现）' });
});

module.exports = router;
