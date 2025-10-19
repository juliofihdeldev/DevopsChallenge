import { Router } from 'express';
import {
  createItem,
  getItems,
  getItemById,
  updateItem,
  deleteItem,
} from '../controllers/itemController';

const router = Router();

router.get('/', getItems);
router.get('/:id', getItemById);
router.post('/', createItem);
router.put('/:id', updateItem);
router.delete('/:id', deleteItem);

router.get('/live', (req, res) => {
  res.status(200).send({
    message: 'Service is live',
    service: 'Item Service',
    pod: process.env.HOSTNAME || 'unknown',
    time: new Date().toISOString(),
  });
});

router.get('/readyz', (req, res) => {
  res.status(200).send('ready');
});

router.get('/healthz', (req, res) => {
  res.status(200).send('OK');
});

export default router;
