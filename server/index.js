//Import from packages
const express = require('express');
const mongoose = require('mongoose');

//Import from other files
const authRouter = require('./routes/auth');

//Init
const PORT = 3000
const app = express();
const DB = "mongodb+srv://amazonclone:Sj8oyqYCWOucXpyi@cluster0.ppxdfve.mongodb.net/?retryWrites=true&w=majority";

// middleware
app.use(express.json());
app.use(authRouter);

//Connections
mongoose.connect(DB)
    .then(() => {
        console.log('connection successful');
    })
    .catch((e) => {
        console.error(e);
    });

app.listen(PORT, () => {
    console.log(`connected at port ${PORT}`)
});