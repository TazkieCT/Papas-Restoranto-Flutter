var express = require('express');
var router = express.Router();

var con = require('../database/db')

router.get('/', (req, res) => {
    var htmlResponse = '<h1> GK ADA APA APA </h1>';
    res.send(htmlResponse);
})

router.get('/get-all', (req, res) => {
    const query = "SELECT * FROM product"
    con.query(query, (err, results) => {
        if(err) throw err;
        res.send(results);
    })
})

router.get('/get', (req, res) => {
    const id = req.query.id;
    const query = `SELECT * FROM product WHERE id = ${id}`
    con.query(query, (err, results) => {
        if(err) throw err;
        res.send(results);
    })
})

router.post('/add-food', (req, res) => {
    const data = req.body;

    const query = `INSERT INTO product (name, description, price, image) VALUES ('${data.name}', '${data.description}', '${data.price}', '${data.image}')`
    con.query(query, (err, results) => {
        if(err) throw err;
        res.send(results);
    })
})

router.post('/update-food', (req, res) => {
    const data = req.body;
    const query = `UPDATE product SET price = ${data.price} WHERE id  = ${data.id}`

    con.query(query, (err, results) => {
        if(err) throw err;
        res.send(results);
    })
})


router.delete('/delete-food', (req, res) => {
    const data = req.body
    const query = `DELETE FROM product WHERE id = ${data.id}`

    con.query(query, (err, results) => {
        if(err) throw err;
        res.send(results);
    })
})

module.exports = router;