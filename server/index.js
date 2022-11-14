//Import from packages
const express = require('express');
const mongoose = require('mongoose');

//Import from other files
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');

//Init
const PORT = 3000
const app = express();
const DB = "mongodb+srv://amazonclone:Sj8oyqYCWOucXpyi@cluster0.ppxdfve.mongodb.net/?retryWrites=true&w=majority";

// middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

//Connections
mongoose.connect(DB)
    .then(() => {
        console.log('connection successful');
    })
    .catch((e) => {
        console.error(e);
    });

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`)
});