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

adminRouter.get('/admin/analytics', async(req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for (let i = 0; i < orders.length; i++) {
            totalEarnings += orders[i]['totalPrice'];
        }

        //Category wide order fetching
        let mobilesEarnings = await fetchCategoryWideProduct('Mobiles');
        let essentialsEarnings = await fetchCategoryWideProduct('Essentials');
        let appliancesEarnings = await fetchCategoryWideProduct('Appliances');
        let booksEarnings = await fetchCategoryWideProduct('Books');
        let fashionEarnings = await fetchCategoryWideProduct('Fashion');

        let earnings = {
            totalEarnings,
            mobilesEarnings,
            essentialsEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings,
        }

        res.json(earnings);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

async function fetchCategoryWideProduct(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({
        'orders.product.category': category,
    });
    for (let i = 0; i < categoryOrders.length; i++) {
        let orders = categoryOrders[i].orders;
        for (let j = 0; j < orders.length; j++) {
            let product = orders[j].product;
            let order = orders[j];
            earnings += order.quantity * product.price;
        }
    }
    return earnings;
}


module.exports = adminRouter;