import jwt from 'jsonwebtoken';

const JWT_SECRET = 'your_jwt_secret'; 

export const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];
    
    if (!token) {
        return res.sendStatus(401); // unauthorized user
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.sendStatus(403); // forbidden user
        }

        req.user = user;
        next();
    });
};