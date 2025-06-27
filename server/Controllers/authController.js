import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import User from '../Database/user.js';
import dotenv from 'dotenv';
dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET;
export const registerUser=async(req,res)=>{
   
    const {username,password}=req.body;

    try{
        const existingUser = await User.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ message: 'Username already exists' });
        
    }
    const hashedPassword= await bcrypt.hash(password,10);
        const newUser= new User({username,password:hashedPassword});
        await newUser.save();

        res.status(201).json({message:"User registered successfully"});

}catch(error){
        console.error("error registered user:",error);
        res.status(500).json({message:'Error registered user',error});
    }
};

export const loginuser=async(req,res)=>{
    console.log("Request body received:", req.body);

    const { username, password } = req.body;
    if (!username || !password) {
        console.log("Missing username or password");
        return res.status(400).json({ message: 'Username and password are required' });
    }
    try {
        const user = await User.findOne({ username });
        if (!user) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }

        const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    } catch (error) {
        console.error('Error logging in user:', error);
        res.status(500).json({ message: 'Server error' });
    }
};