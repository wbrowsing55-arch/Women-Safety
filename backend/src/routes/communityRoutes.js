import {Router} from 'express';import {count,registerInterest} from '../controllers/communityController.js';import {authenticate} from '../middleware/authenticate.js';
const router=Router();router.get('/count',count);router.post('/interest',authenticate,registerInterest);export default router;
