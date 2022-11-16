const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const { find } = require('../models/product');
const { Product } = require('../models/product');
const { Order } = require('../models/order');
// Add product
adminRouter.post('/admin/add-product', admin, async(req, res) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;
        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category
        });
        product = await product.save();
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all products
adminRouter.post('/admin/get-products', admin, async(req, res) => {
    try {
        const products = await Product.find({});
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete the product
adminRouter.post('/admin/delete-product', admin, async(req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all order
adminRouter.get('/admin/get-orders', admin, async(req, res) => {
    try {
        const orders = await Order.find({});
        res.json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Change order status
adminRouter.post('/admin/change-order-status', admin, async(req, res) => {
    try {
        const { id, status } = req.body;
        const order = await Order.findById(id);
        order.status = status;
        order.save();
        res.json(order);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = adminRouter;