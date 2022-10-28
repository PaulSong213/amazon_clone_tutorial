const express = require('express');
const User = require('../models/user');

const authRouter = express.Router();

authRouter.post('/api/signup', async(req, res) => {
    // get the data from client
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: 'User with the same email already exists!' });
        }

        let user = new User({
            email,
            password,
            name
        })

        // post that data in database
        user = await user.save();

        // return that data to user
        res.json(user);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }

});

module.exports = authRouter;