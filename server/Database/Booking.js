// models/Booking.js
import mongoose from 'mongoose';

const bookingSchema = new mongoose.Schema({
    RoomName: {
        type: String,
        required: true,
    },
    Guest: {
        type: String,
        required: true,
    },
    EventName: {
        type: String,
        required: true,
    },
    MobileNumber: {
        type: String,
        required: true,
    },
    Date: {
        type: String, 
        required: true,
    },
    BookedFrom: {
        type: String,
        required: true,
    },
    BookedTill: {
        type: String,
        required: true,
    },
    Status: {
        type: String,
        required: true,
    },
});

const Booking = mongoose.model('Booking', bookingSchema);

export default Booking;
