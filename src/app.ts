import express from 'express';
import itemRoutes from './routes/itemRoutes';
import { errorHandler } from './middlewares/errorHandler';
import helmet from 'helmet';
import logger from './config/logger';

import morgan from 'morgan';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import { securityMiddleware } from './middlewares/security';

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(helmet());
app.use(cors());
app.use(cookieParser());
app.use(
  morgan('combined', {
    stream: {
      write: (message: string) => logger.info(message.trim()),
    },
  }),
);
// Health check endpoints (must be before security middleware to avoid rate limiting)
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'OK', service: 'backend-challenge' });
});

app.get('/readyz', (req, res) => {
  res.status(200).json({ status: 'ready', service: 'backend-challenge' });
});

app.use(securityMiddleware);

// Routes
app.use('/api/items', itemRoutes);

// Global error handler (should be after routes)
app.use(errorHandler);

export default app;
