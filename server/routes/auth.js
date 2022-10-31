const express = require('express');
const User = require('../models/user');
const bycrptjs = require('bcryptjs');
const authRouter = express.Router();
const bycryptSalt = 8;
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');

// SIGN UP
authRouter.post('/api/signup', async(req, res) => {
    // get the data from client
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: 'User with the same email already exists!' });
        }

        const hashedPassword = await bycrptjs.hash(password, bycryptSalt);

        let user = new User({
            email,
            password: hashedPassword,
            name
        });

        // post that data in database
        user = await user.save();

        // return that data to user
        res.json(user);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }

});

// Sign in Route
authRouter.post('/api/signin', async(req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(400).json({ msg: 'User with email does exist!' });
        }
        const isMatch = await bycrptjs.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ msg: 'Incorrect password.' });
        }
        const token = jwt.sign({ id: user._id }, "passwordKey");
        res.json({ token, ...user._doc });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

authRouter.post("/tokenIsValid", async(req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified) return res.json(false);

        const user = await User.findById(isVerified.id);
        if (!user) return res.json(false);
        res.json(true);
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
});

//get user data
authRouter.get('/', auth, async(req, res) => {
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token });
});

module.exports = authRouter;