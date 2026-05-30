import createError from "../utils/createError.js";
import Order from "../models/order.model.js";
import Gig from "../models/gig.model.js";
import User from "../models/user.model.js";
import Stripe from "stripe";

export const intent = async (req, res, next) => {
  const stripe = new Stripe(process.env.STRIPE);

  const gig = await Gig.findById(req.params.id);
  if (!gig) {
    return next(createError(404, "Gig not found."));
  }

  const seller = await User.findById(gig.userId);
  if (!seller || !seller.stripeAccountId) {
    return next(
      createError(400, "Seller payout account is not configured.")
    );
  }

  // All prices are in INR, convert to paise (smallest unit)
  const amount = Math.round(gig.price * 100);
  const applicationFee = Math.round(amount * 0.1);

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,
    currency: "inr",
    application_fee_amount: applicationFee,
    transfer_data: {
      destination: seller.stripeAccountId,
    },
    automatic_payment_methods: {
      enabled: true,
    },
  });

  const newOrder = new Order({
    gigId: gig._id,
    img: gig.cover,
    title: gig.title,
    buyerId: req.userId,
    sellerId: gig.userId,
    price: gig.price,
    payment_intent: paymentIntent.id,
  });

  await newOrder.save();

  res.status(200).send({
    clientSecret: paymentIntent.client_secret,
  });
};

export const getOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({
      ...(req.isSeller ? { sellerId: req.userId } : { buyerId: req.userId }),
      isCompleted: true,
    });

    res.status(200).send(orders);
  } catch (err) {
    next(err);
  }
};
export const confirm = async (req, res, next) => {
  try {
    const orders = await Order.findOneAndUpdate(
      {
        payment_intent: req.body.payment_intent,
      },
      {
        $set: {
          isCompleted: true,
        },
      }
    );

    res.status(200).send("Order has been confirmed.");
  } catch (err) {
    next(err);
  }
};
