import express from 'express';
import { getBookings, createBooking , deleteBooking , statusBooking} from '../Controllers/bookingController.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// authenticateToken
router.get('/all', getBookings);
router.post('/create', createBooking);
router.delete('/delete/:id', deleteBooking);
router.patch('/:id/status' , statusBooking);

export default router;
