const functions = require("firebase-functions");
const express = require("express");
const cors = require('cors');
const app = express();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
app.use(cors({ origin: true }));


app.post('/', (req, res) =>{
    const user = req.body;
    res.status(201).send("success" + req.body.price);
});

const stripe = require('stripe')(functions.config().stripe.testkey);
app.post('/stripePayment', async (req, res) =>{
    const paymentIntent = await stripe.paymentIntents.create({
        amount: parseFloat(req.body.price),
        currency: 'usd',
    },
        function (err, paymentIntent) {
            if (err != null) {
                console.log(err);
                res.json({
                    // error: err
                    error: req.body.price
                })
            }
            else {
                res.json({
                    paymentIntent: paymentIntent.client_secret
                })
            }
        }
    )
    // res.status(201).send("anotherrea: " + req.body.price);
});


// exports.stripePayment = functions.https.onRequest(async (req, res) => {
//     const paymentIntent = await stripe.paymentIntents.create({
//         amount: 1999,
//         currency: 'usd',
//     },
//         function (err, paymentIntent) {
//             if (err != null) {
//                 console.log(err);
//             }
//             else {
//                 res.json({
//                     paymentIntent: paymentIntent.client_secret
//                 })
//             }
//         }
//     )
// }) 

exports.api = functions.https.onRequest(app);