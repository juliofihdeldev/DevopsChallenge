import { slidingWindow } from '@arcjet/node';
import aj from '../config/arcjet';
import { NextFunction, Request, Response } from 'express';
import logger from '../config/logger';

export const securityMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const role = req?.body?.role || 'guest';
    let limit = 20;
    let message = 'Too many requests, please try again later.';

    if (role === 'admin') {
      limit = 20;
      message = 'Admin rate limit exceeded.';
    } else if (role === 'user') {
      limit = 5;
      message = 'User rate limit exceeded.';
    } else {
      limit = 5;
      message = 'Guest rate limit exceeded.';
    }
    const client = await aj.withRule(
      slidingWindow({
        mode: 'LIVE',
        interval: 30, // 15 seconds
        max: limit,
      }),
    );

    let decision = await client.protect(req);

    if (decision.isDenied() && decision.reason.isBot()) {
      logger.warn(`Bot detected: ${req.ip} - ${req.headers['user-agent']}`);
      res.status(403).json({ error: 'No bots allowed' });
      return;
    }
    if (decision.isDenied() && decision.reason.isShield()) {
      logger.warn(`Shield violation: ${req.ip} - ${req.headers['user-agent']}`);
      res.status(403).json({ error: 'Forbidden' });
      return;
    }
    if (decision.isDenied() && decision.reason.isRateLimit()) {
      logger.warn(
        `Rate limit exceeded: ${req.ip} - ${req.headers['user-agent']}`,
      );
      res.status(429).json({ error: message });
      return;
    }
    next();
  } catch (error) {
    next(error);
  }
};
