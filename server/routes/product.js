const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const Product = require('../models/product');


productRouter.get('/api/products', async(req, res) => {
    try {
        const products = await Product.find({ category: req.query.category });
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

productRouter.get('/api/products/search/:name', async(req, res) => {
    try {
        const products = await Product.find({
            name: { $regex: req.params.name, $options: "i" }
        });
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = productRouter;