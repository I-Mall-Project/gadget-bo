// import pkg from "sslcommerz-lts";
// import dotenv from "dotenv";
import SSLCommerzPayment from "sslcommerz-lts";
import { defaultLimit, defaultPage } from "../../utils/defaultData.js";
import sendEmail from "../../utils/emailService.js";
import jsonResponse from "../../utils/jsonResponse.js";
import prisma from "../../utils/prismaClient.js";
import validateInput from "../../utils/validateInput.js";

// dotenv.config();

const module_name = "order";

const store_id = "strik679cf43feb667";
const store_passwd = "strik679cf43feb667@ssl";
const is_live = false; //true for live, false for sandbox

//create order
export const createOrder = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const {
        userId,
        couponId,
        customerName,
        customerPhone,
        customerAddress,
        customerBillingAddress,
        customerEmail,
        customerCity,
        customerPostalCode,
        invoiceNumber,
        paymentMethod,
        deliveryChargeInside,
        deliveryChargeOutside,
        // totalItems,
        // subtotalCost,
        // subtotal,
        orderItems,
      } = req.body;

      //validate input
      const inputValidation = validateInput(
        [
          customerName,
          customerPhone,
          customerAddress,
          // customerBillingAddress,
          // customerEmail,
          // customerCity,
          invoiceNumber,
          paymentMethod,
        ],
        [
          "Name",
          "Phone",
          "Shipping Address",
          // "Billing Address",
          // "Email",
          "City",
          "Invoice",
          "Payment Method",
        ]
      );

      if (inputValidation) {
        return res.status(400).json(jsonResponse(false, inputValidation, null));
      }

      // console.log("SSL");

      //count total items and subtotal price for order and get name,size,prices info
      let totalNumberOfItems = 0;
      let subtotal = 0;
      let subtotalCost = 0;
      let newOrderItems = [];
      let allProductNames = "";

      if (orderItems && orderItems.length > 0) {
        const orderItemLength = orderItems.length;
        for (let i = 0; i < orderItemLength; i++) {
          //get product and product attribute for getting prices,name,size info
          const product = await tx.product.findFirst({
            where: {
              id: orderItems[i].productId,
              isDeleted: false,
              isActive: true,
            },
          });
          const productAttribute = await tx.productAttribute.findFirst({
            where: { id: orderItems[i].productAttributeId, isDeleted: false },
          });

          if (!product && !productAttribute) {
            return res
              .status(409)
              .json(jsonResponse(false, "Product does not exist", null));
          }

          newOrderItems.push({
            ...orderItems[i],
            name: product.name,
            size: productAttribute?.size,
            costPrice: productAttribute?.costPrice,
            retailPrice: productAttribute?.retailPrice,
            discountPercent: productAttribute?.discountPercent,
            discountPrice: productAttribute?.discountPrice,
            discountedRetailPrice: productAttribute?.discountedRetailPrice,
            totalCostPrice:
              orderItems[i].quantity * productAttribute?.costPrice,
            totalPrice:
              orderItems[i].quantity * productAttribute?.discountedRetailPrice,
            quantity: orderItems[i].quantity,
          });

          //calculate total number of items
          totalNumberOfItems = totalNumberOfItems + orderItems[i].quantity;

          //calculate discount prices
          let discountPrice =
            productAttribute?.retailPrice *
            (productAttribute?.discountPercent / 100);
          let discountedRetailPrice =
            (productAttribute?.retailPrice - discountPrice) *
            orderItems[i].quantity;

          //calculate subtotal and subtotal cost price
          // subtotal = subtotal + discountedRetailPrice;
          subtotal = subtotal + orderItems[i]?.totalPrice;
          subtotalCost = subtotalCost + orderItems[i]?.totalCostPrice;
          // subtotalCost =
          //   subtotalCost + orderItems[i].quantity * productAttribute.costPrice;

          allProductNames = allProductNames + ", " + orderItems[i]?.name;
        }
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Please select at least 1 item", null));
      }

      //get coupon
      let coupon = couponId
        ? await tx.coupon.findFirst({
            where: { id: couponId, isActive: true },
          })
        : undefined;

      //create order
      let newOrder = await tx.order.create({
        data: {
          userId,
          couponId,
          customerName,
          customerPhone,
          customerAddress,
          customerEmail,
          customerBillingAddress,
          customerCity,
          customerPostalCode,
          invoiceNumber,
          totalItems: totalNumberOfItems,
          subtotalCost: subtotalCost,
          subtotal:
            subtotal +
            (deliveryChargeInside ?? deliveryChargeOutside) -
            (coupon?.discountAmount ?? 0),
          paymentMethod,
          deliveryChargeInside: deliveryChargeInside ?? null,
          deliveryChargeOutside: deliveryChargeOutside ?? null,
          orderItems: {
            create: newOrderItems,
          },
        },
      });

      if (!newOrder) {
        return res
          .status(200)
          .json(jsonResponse(false, `Order cannot be placed`, null));
      }

      //reduce stock amount
      for (let i = 0; i < orderItems.length; i++) {
        await tx.productAttribute.update({
          where: { id: orderItems[i].productAttributeId },
          data: {
            stockAmount: { decrement: orderItems[i].quantity },
          },
        });
      }

      console.log("ORDER CHECK");

      // <tr>
      //             <td></td>
      //             <td></td>
      //             <td><b>Discount: </b></td>
      //             <td>${subtotal + deliveryChargeInside - subtotal} TK</td>
      //           </tr>

      //send email invoice
      const emailGenerate = await sendEmail(
        customerEmail,
        `Order Invoice #${invoiceNumber}`,
        `<p>Dear ${customerName},</p>

          <p>Your order has been placed successfully!</p>

          <p><b>Order Information:</b></p>
          <p><b>Phone:</b> ${customerPhone}</p>
          <p><b>Shipping Address:</b> ${customerAddress}</p>
          <p><b>Billing Address:</b> ${customerBillingAddress}</p>
          <p><b>City:</b> ${customerCity}</p>
          <p><b>Postal Code:</b> ${customerPostalCode}</p>
          <p><b>Payment Method:</b> ${paymentMethod}</p>
          <p><b>Total Items:</b> ${totalNumberOfItems}</p>
          <p><b>Order Status:</b> Pending</p>
          <br/>
          <table border="1">
            <thead>
              <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              ${orderItems?.map(
                (orderItm) =>
                  `<tr>
                  <td>
                    ${orderItm?.name} (${orderItm?.size})
                  </td>
                  <td>${orderItm?.discountedRetailPrice} TK</td>
                  <td>${orderItm?.quantity}</td>
                  <td>${orderItm?.totalPrice} TK</td>
                </tr>`
              )}
                <tr>
                  <td></td>
                  <td></td>
                  <td><b>Coupon Discount: </b></td>
                  <td>${coupon?.discountAmount ?? 0} TK</td>
                </tr>
                <tr>
                  <td></td>
                  <td></td>
                  <td><b>Delivery Charge: </b></td>
                  <td>${deliveryChargeInside ?? 0} TK</td>
                </tr>
                <tr>
                  <td></td>
                  <td></td>
                  <td><b>Subtotal: </b></td>
                  <td><b>${
                    subtotal +
                    deliveryChargeInside -
                    (coupon?.discountAmount ?? 0)
                  } TK</b></td>
                </tr>
            </tbody>
          </table>

          <br/><br/>
          <p>Thank you for shopping. Your order status will be updated soon.</p>
        `
      );

      return res
        .status(200)
        .json(
          jsonResponse(
            true,
          "Your order has been placed successfully" ,
            newOrder
          )
        );
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//create order ssl
export const createOrderSsl = async (req, res) => {
  const {
    userId,
    couponId,
    customerName,
    customerPhone,
    customerAddress,
    customerBillingAddress,
    customerEmail,
    customerCity,
    customerPostalCode,
    invoiceNumber,
    paymentMethod,
    deliveryChargeInside,
    deliveryChargeOutside,
    // totalItems,
    // subtotalCost,
    // subtotal,
    orderItems,
  } = req.body;

  //count total items and subtotal price for order and get name,size,prices info
  let totalNumberOfItems = 0;
  let subtotal = 0;
  let subtotalCost = 0;
  let newOrderItems = [];
  let allProductNames = "";

  if (orderItems && orderItems.length > 0) {
    const orderItemLength = orderItems.length;
    for (let i = 0; i < orderItemLength; i++) {
      //get product and product attribute for getting prices,name,size info
      const product = await prisma.product.findFirst({
        where: {
          id: orderItems[i].productId,
          isDeleted: false,
          isActive: true,
        },
      });
      const productAttribute = await prisma.productAttribute.findFirst({
        where: { id: orderItems[i].productAttributeId, isDeleted: false },
      });

      if (!product && !productAttribute) {
        return res
          .status(409)
          .json(jsonResponse(false, "Product does not exist", null));
      }

      newOrderItems.push({
        ...orderItems[i],
        name: product.name,
        size: productAttribute.size,
        costPrice: productAttribute.costPrice,
        retailPrice: productAttribute.retailPrice,
        discountPercent: productAttribute.discountPercent,
        discountPrice: productAttribute.discountPrice,
        discountedRetailPrice: productAttribute.discountedRetailPrice,
        totalCostPrice: orderItems[i].quantity * productAttribute.costPrice,
        totalPrice:
          orderItems[i].quantity * productAttribute.discountedRetailPrice,
        quantity: orderItems[i].quantity,
      });

      //calculate total number of items
      totalNumberOfItems = totalNumberOfItems + orderItems[i].quantity;

      //calculate discount prices
      let discountPrice =
        productAttribute.retailPrice * (productAttribute.discountPercent / 100);
      let discountedRetailPrice =
        (productAttribute.retailPrice - discountPrice) * orderItems[i].quantity;

      //calculate subtotal and subtotal cost price
      subtotal = subtotal + orderItems[i]?.totalPrice;
      subtotalCost = subtotalCost + orderItems[i]?.totalCostPrice;
      // subtotal = subtotal + discountedRetailPrice;
      // subtotalCost =
      //   subtotalCost + orderItems[i].quantity * productAttribute.costPrice;

      allProductNames = allProductNames + ", " + orderItems[i]?.name;
    }
  } else {
    return res
      .status(404)
      .json(jsonResponse(false, "Please select at least 1 item", null));
  }

  //get coupon
  let coupon = couponId
    ? await prisma.coupon.findFirst({
        where: { id: couponId, isActive: true },
      })
    : undefined;

  //ssl commerz
  if (paymentMethod?.toLowerCase() === "digital payment") {
    const data = {
      total_amount:
        subtotal + deliveryChargeInside - (coupon?.discountAmount ?? 0),
      currency: "BDT",
      tran_id: invoiceNumber, // use unique tran_id for each api call
      // success_url: "http://localhost:4000/api/v1/orders-success",
      // fail_url: "http://localhost:4000/api/v1/orders-fail",
      // cancel_url: "http://localhost:4000/api/v1/orders-fail",
      success_url: "https://strike-core.vercel.app/api/v1/orders-success",
      fail_url: "https://strike-core.vercel.app/api/v1/orders-fail",
      cancel_url: "https://strike-core.vercel.app/api/v1/orders-fail",
      ipn_url: "http://localhost:3000/ipn/",
      shipping_method: "Courier",
      product_name: allProductNames,
      product_category: "Product",
      product_profile: "general",
      cus_name: customerName,
      cus_email: customerEmail,
      cus_add1: customerBillingAddress,
      cus_add2: "",
      cus_city: customerCity,
      cus_state: customerCity,
      cus_postcode: customerPostalCode,
      cus_country: "Bangladesh",
      cus_phone: customerPhone,
      cus_fax: "",
      ship_name: customerName,
      ship_add1: customerAddress,
      ship_add2: "",
      ship_city: customerCity,
      ship_state: customerCity,
      ship_postcode: Number(customerPostalCode),
      ship_country: "Bangladesh",
    };
    const sslcz = new SSLCommerzPayment(store_id, store_passwd, is_live);
    await sslcz.init(data).then((apiResponse) => {
      console.log("Full API Response:", apiResponse); // Debugging API response

      if (!apiResponse || !apiResponse.GatewayPageURL) {
        return res.status(400).json(
          jsonResponse(false, "Failed to get Gateway URL", {
            error: apiResponse,
          })
        );
      }

      let GatewayPageURL = apiResponse.GatewayPageURL;
      console.log("Redirecting to:", GatewayPageURL);

      // ✅ Ensure only ONE response is sent
      if (!res.headersSent) {
        return res.status(200).json(
          jsonResponse(true, "Redirecting to SSL COMMERZ.", {
            gateway: GatewayPageURL,
          })
        );
      }
    });
    // return;
  }
};

export const createOrderSuccess = async (req, res) => {
  // console.log({ req });
  // res.redirect("http://localhost:3000/checkout?isSuccess=true");
  res.redirect("https://strike-shoes.vercel.app/checkout?isSuccess=true");
};

export const createOrderFail = async (req, res) => {
  // console.log({ res });
  // res.redirect("http://localhost:3000/checkout?isSuccess=false");
  res.redirect("https://strike-shoes.vercel.app/checkout?isSuccess=false");
};

//get orders ssl
export const getOrdersSsl = async (req, res) => {
  try {
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

// //get all orders
// export const getOrders = async (req, res) => {
//   if (req.user.roleName !== "super-admin") {
//     getOrdersByUser(req, res);
//   } else {
//     try {
//       const orders = await prisma.order.findMany({
//         where: {
//           isDeleted: false,
//           // AND: [
//           //   {
//           //     customerName: {
//           //       contains: req.query.customer_name,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     customerPhone: {
//           //       contains: req.query.customer_phone,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     customerAddress: {
//           //       contains: req.query.customer_address,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     customerCity: {
//           //       contains: req.query.customer_city,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     customerPostalCode: {
//           //       contains: req.query.customer_postal_code,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     invoiceNumber: {
//           //       contains: req.query.invoice_number,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     paymentMethod: {
//           //       contains: req.query.payment_method,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           //   {
//           //     status: {
//           //       contains: req.query.status,
//           //       mode: "insensitive",
//           //     },
//           //   },
//           // ],
//         },
//         include: {
//           orderItems: true,
//         },
//         orderBy: {
//           createdAt: "desc",
//         },
//         skip:
//           req.query.limit && req.query.page
//             ? parseInt(req.query.limit * (req.query.page - 1))
//             : parseInt(defaultLimit() * (defaultPage() - 1)),
//         take: req.query.limit
//           ? parseInt(req.query.limit)
//           : parseInt(defaultLimit()),
//       });

//       if (orders.length === 0)
//         return res
//           .status(200)
//           .json(jsonResponse(true, "No order is available", null));

//       if (orders) {
//         return res
//           .status(200)
//           .json(jsonResponse(true, `${orders.length} orders found`, orders));
//       } else {
//         return res
//           .status(404)
//           .json(jsonResponse(false, "Something went wrong. Try again", null));
//       }
//     } catch (error) {
//       console.log(error);
//       return res.status(500).json(jsonResponse(false, error, null));
//     }
//   }
// };

//get all orders
export const getOrders = async (req, res) => {
  if (req.user.roleName !== "super-admin") {
    return getOrdersByUser(req, res);
  } else {
    try {
      const orders = await prisma.order.findMany({
        where: {
          isDeleted: false,
        },
        include: {
          orderItems: {
            include: {
              product: {
                include: {
                  images: true, // include product images
                },
              },
            },
          },
        },
        orderBy: {
          createdAt: "desc",
        },
        skip:
          req.query.limit && req.query.page
            ? parseInt(req.query.limit * (req.query.page - 1))
            : parseInt(defaultLimit() * (defaultPage() - 1)),
        take: req.query.limit
          ? parseInt(req.query.limit)
          : parseInt(defaultLimit()),
      });

      if (!orders || orders.length === 0) {
        return res
          .status(200)
          .json(jsonResponse(true, "No order is available", null));
      }

      // Map orderItems to include first image only
      const ordersWithImages = orders.map((order) => ({
        ...order,
        orderItems: order.orderItems.map((item) => ({
          ...item,
          image: item.product?.images?.length > 0 ? item.product.images[0].image : null,
        })),
      }));

      return res.status(200).json(
        jsonResponse(
          true,
          `${ordersWithImages.length} orders found`,
          ordersWithImages
        )
      );
    } catch (error) {
      console.log(error);
      return res
        .status(500)
        .json(jsonResponse(false, "Something went wrong. Try again", null));
    }
  }
};



//get all orders by user
export const getOrdersByUser = async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      where: {
        userId: req.params.id,
        isDeleted: false,
        // AND: [
        //   {
        //     customerName: {
        //       contains: req.query.customer_name,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     customerPhone: {
        //       contains: req.query.customer_phone,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     customerAddress: {
        //       contains: req.query.customer_address,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     customerCity: {
        //       contains: req.query.customer_city,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     customerPostalCode: {
        //       contains: req.query.customer_postal_code,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     invoiceNumber: {
        //       contains: req.query.invoice_number,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     paymentMethod: {
        //       contains: req.query.payment_method,
        //       mode: "insensitive",
        //     },
        //   },
        //   {
        //     status: {
        //       contains: req.query.status,
        //       mode: "insensitive",
        //     },
        //   },
        // ],
      },
      include: {
        orderItems: true,
      },

      orderBy: {
        createdAt: "desc",
      },
      skip:
        req.query.limit && req.query.page
          ? parseInt(req.query.limit * (req.query.page - 1))
          : parseInt(defaultLimit() * (defaultPage() - 1)),
      take: req.query.limit
        ? parseInt(req.query.limit)
        : parseInt(defaultLimit()),
    });

    if (orders.length === 0)
      return res
        .status(200)
        .json(jsonResponse(true, "No order is available", null));

    if (orders) {
      return res
        .status(200)
        .json(jsonResponse(true, `${orders.length} orders found`, orders));
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "Something went wrong. Try again", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get single order
// get single order (ID অথবা Invoice Number দিয়ে সার্চ করবে)
export const getOrder = async (req, res) => {
  try {
    const { id } = req.params;

    const order = await prisma.order.findFirst({
      where: {
        OR: [
          { id: id },
          { invoiceNumber: id },
          { invoice: id }, // আপনার স্কিমায় যদি 'invoice' নামে থাকে
        ],
        isDeleted: false,
      },
      include: {
        orderItems: true,
      },
    });

    if (!order) {
      return res
        .status(404)
        .json(jsonResponse(false, "No order is available", null));
    }

    // ডেলিভারি চার্জ নির্ধারণ (যদি আলাদা আলাদা চার্জ ফিল্ড থাকে)
    const deliveryCharge =
      order.deliveryCharge ??
      (order.customerCity?.toLowerCase().includes("dhaka")
        ? order.deliveryChargeInside
        : order.deliveryChargeOutside) ?? 60;

    // কাস্টমারের সব ইনফরমেশনসহ ফ্রন্টএন্ডে পাঠানো
    const responseData = {
      ...order,
      invoice: order.invoiceNumber || order.invoice,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      customerAddress: order.customerAddress || order.customerBillingAddress,
      deliveryCharge: deliveryCharge,
    };

    return res
      .status(200)
      .json(jsonResponse(true, "1 order found", responseData));
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(jsonResponse(false, error.message || "Something went wrong", null));
  }
};

//update order status
export const updateOrder = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const { status } = req.body;

      const orderItems = await tx.orderItem.findMany({
        where: { orderId: req.params.id },
      });

      const orderItemsLength = orderItems.length;

      const getOrder = await tx.order.findFirst({
        where: { id: req.params.id },
      });

      //update order status
      let order;
      if (orderItems && orderItemsLength > 0) {
        order = await tx.order.update({
          where: { id: req.params.id },
          data: {
            status,
          },
        });

        if (order) {
          //stock amount reduction calculation
          // if (order.status === "DELIVERED") {
          //   for (let i = 0; i < orderItemsLength; i++) {
          //     const productAttribute = await tx.productAttribute.update({
          //       where: { id: orderItems[i].productAttributeId },
          //       data: {
          //         stockAmount: { decrement: orderItems[i].quantity },
          //       },
          //     });
          //   }
          // }

          if (order.status === "CANCELED" || order.status === "RETURNED") {
            for (let i = 0; i < orderItemsLength; i++) {
              const productAttribute = await tx.productAttribute.update({
                where: { id: orderItems[i].productAttributeId },
                data: {
                  stockAmount: { increment: orderItems[i].quantity },
                },
              });
            }
          }
        }
      }

      if (order && orderItemsLength > 0) {
        //send email invoice
        let orderStatus = "SHIPPED";
        if (order?.status === "CANCELED") {
          orderStatus = "CANCELED";
        }
        if (order?.status === "RETURNED") {
          orderStatus = "RETURNED";
        }
        if (order?.status === "DELIVERED") {
          orderStatus = "DELIVERED";
        }
        const emailGenerate = await sendEmail(
          order?.customerEmail,
          `Order Status Updated For Invoice #${order?.invoiceNumber}`,
          `<p>Dear ${order?.customerName},</p>

          <p>Your order has been ${orderStatus}!</p>

          <p><b>Order Information:</b></p>
          <p><b>Phone:</b> ${order?.customerPhone}</p>
          <p><b>Shipping Address:</b> ${order?.customerAddress}</p>
          <p><b>Billing Address:</b> ${order?.customerBillingAddress}</p>
          <p><b>City:</b> ${order?.customerCity}</p>
          <p><b>Postal Code:</b> ${order?.customerPostalCode}</p>
          <p><b>Payment Method:</b> ${order?.paymentMethod}</p>
          <p><b>Total Items:</b> ${order?.totalItems}</p>
          <p><b>Order Status:</b> ${status}</p>
          <br/>
          <table border="1">
            <thead>
              <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              ${orderItems?.map(
                (orderItm) =>
                  `<tr>
                  <td>
                    ${orderItm?.name} (${orderItm?.size})
                  </td>
                  <td>${orderItm?.discountedRetailPrice} TK</td>
                  <td>${orderItm?.quantity}</td>
                  <td>${orderItm?.totalPrice} TK</td>
                </tr>`
              )}
                <tr>
                  <td></td>
                  <td></td>
                  <td><b>Delivery Charge: </b></td>
                  <td>${order?.deliveryChargeInside ?? 0} TK</td>
                </tr>
                <tr>
                  <td></td>
                  <td></td>
                  <td><b>Subtotal: </b></td>
                  <td><b>${order?.subtotal} TK</b></td>
                </tr>
            </tbody>
          </table>

          <br/><br/>
          <p>Thank you for shopping.</p>
        `
        );

        return res
          .status(200)
          .json(jsonResponse(true, `Order status has been updated`, order));
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Order status has not been updated", null));
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//delete order
export const deleteOrder = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const order = await tx.order.update({
        where: { id: req.params.id },
        data: { isDeleted: true },
      });

      if (order) {
        return res
          .status(200)
          .json(jsonResponse(true, `Order has been deleted`, order));
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Order has not been deleted", null));
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null))
  }
};




// track order by invoice number
export const trackOrder = async (req, res) => {
  try {
    const { invoice } = req.query;
    if (!invoice) {
      return res.status(400).json({ success: false, message: "Invoice number required", data: null });
    }

    const order = await prisma.order.findFirst({
      where: { 
        invoiceNumber: String(invoice),
        isDeleted: false 
      },
      include: { 
        orderItems: true 
      },
    });

    if (!order) {
      return res.status(404).json({ success: false, message: "Order not found", data: null });
    }

    // ডেলিভারি চার্জ হিসাব
    const deliveryCharge = order.deliveryChargeInside ?? order.deliveryChargeOutside ?? 60;

    return res.status(200).json({
      success: true,
      message: "Order fetched successfully",
      data: {
        invoice: order.invoiceNumber,
        status: order.status,
        updatedAt: order.updatedAt,
        subtotal: order.subtotal,
        
        // Explicitly mapping values (Null হলেও N/A দেখাবে)
        customerName: order.customerName || "N/A",
        customerPhone: order.customerPhone || "N/A",
        customerAddress: order.customerAddress || order.customerBillingAddress || "N/A",
        customerCity: order.customerCity || "",
        
        deliveryCharge: deliveryCharge,
        orderItems: order.orderItems,
      },
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: err.message || "Internal server error", data: null });
  }
};







/**
 * OFFLINE / POS ORDER CONTROLLER
 * ------------------------------
 * Two endpoints:
 *   GET  /pos/products/search?search=<term>   -> searchProductsForPos
 *   POST /pos/orders                          -> createOfflineOrder
 *
 * Wire these into your router, e.g.:
 *   router.get("/pos/products/search", auth, searchProductsForPos);
 *   router.post("/pos/orders", auth, createOfflineOrder);
 *
 * Assumes `prisma` and `jsonResponse` are already available the same way
 * they are in your existing analyticsController.js (import from wherever
 * that file gets them from).
 */

// ---------------------------------------------------------------------------
// GET: search sellable product variants (for the POS search box)
// ---------------------------------------------------------------------------
export const searchProductsForPos = async (req, res) => {
  try {
    const { search = "" } = req.query;
    const userIdWhere = req.user?.parentId ? req.user.parentId : req.user?.id;

    const products = await prisma.product.findMany({
      where: {
        userId: userIdWhere,
        isActive: true,
        isDeleted: false,
        ...(search ? { name: { contains: search, mode: "insensitive" } } : {}),
      },
      select: {
        id: true,
        name: true,
        images: {
          where: { isDeleted: false },
          select: {
            image: true, // ProductImage মডেলে ফিল্ডের নাম 'image'
          },
          take: 1,
        },
        productAttributes: {
          where: { isDeleted: false, stockAmount: { gt: 0 } },
          select: {
            id: true,
            size: true,
            discountedRetailPrice: true,
            retailPrice: true,
            costPrice: true,
            stockAmount: true,
          },
        },
      },
      take: 100, // ৬০+ প্রোডাক্ট একসাথে পাওয়ার জন্য
      orderBy: { name: "asc" },
    });

    // Flatten to one row per sellable size/variant
    const variants = [];
    products.forEach((p) => {
      // images array থেকে প্রথম ছবির URL নেওয়া
      const imageUrl = p.images && p.images.length > 0 ? p.images[0].image : null;

      p.productAttributes.forEach((attr) => {
        variants.push({
          productId: p.id,
          productName: p.name,
          image: imageUrl, // ফ্রন্টএন্ডে 'image' কি (key) দিয়ে পাঠানো হলো
          productAttributeId: attr.id,
          size: attr.size,
          price: Number(attr.discountedRetailPrice) || 0,
          retailPrice: Number(attr.retailPrice) || 0,
          costPrice: Number(attr.costPrice) || 0,
          stockAmount: Number(attr.stockAmount) || 0,
        });
      });
    });

    return res.status(200).json(jsonResponse(true, "Products fetched", variants));
  } catch (error) {
    console.error("POS Product Search Error:", error);
    return res.status(500).json(jsonResponse(false, error.message, null));
  }
};
// ---------------------------------------------------------------------------
// POST: create an in-person (offline/POS) sale
// ---------------------------------------------------------------------------
/**
 * Body shape:
 * {
 *   items: [{ productAttributeId: string, quantity: number }],
 *   discountType: "FLAT" | "PERCENT" | null,
 *   discountValue: number | null,
 *   customerName?: string,
 *   customerPhone?: string,
 *   customerEmail?: string,
 *   paymentMethod: "CASH" | "BKASH" | "NAGAD",
 *   transactionId?: string,   // recommended when paymentMethod is BKASH/NAGAD
 * }
 */
export const createOfflineOrder = async (req, res) => {
  try {
    const {
      items,
      discountType,
      discountValue,
      customerName,
      customerPhone,
      customerEmail,
      paymentMethod,
      transactionId,
    } = req.body;

    if (!Array.isArray(items) || items.length === 0) {
      return res.status(400).json(jsonResponse(false, "Cart is empty", null));
    }
    if (!paymentMethod) {
      return res.status(400).json(jsonResponse(false, "Payment method is required", null));
    }

    const orderUserId = req.user?.parentId ? req.user.parentId : req.user?.id;
    const staffId = req.user?.id;

    // Fetch all referenced product-attribute rows in one query.
    const attrIds = items.map((i) => i.productAttributeId);
    const attributes = await prisma.productAttribute.findMany({
      where: { id: { in: attrIds }, isDeleted: false },
      include: { product: { select: { id: true, name: true, userId: true } } },
    });
    const attrMap = new Map(attributes.map((a) => [a.id, a]));

    // Validate every cart line: exists, belongs to this store, enough stock.
    const lineItems = [];
    for (const line of items) {
      const attr = attrMap.get(line.productAttributeId);
      const qty = Number(line.quantity) || 0;

      if (!attr) {
        return res
          .status(400)
          .json(jsonResponse(false, `Product variant not found: ${line.productAttributeId}`, null));
      }
      if (attr.product.userId !== orderUserId) {
        return res.status(403).json(jsonResponse(false, "One or more products don't belong to this store", null));
      }
      if (qty <= 0) {
        return res.status(400).json(jsonResponse(false, `Invalid quantity for ${attr.product.name}`, null));
      }
      if (attr.stockAmount < qty) {
        return res
          .status(400)
          .json(
            jsonResponse(
              false,
              `Not enough stock for ${attr.product.name} (${attr.size}). Available: ${attr.stockAmount}`,
              null
            )
          );
      }

      lineItems.push({
        productId: attr.product.id,
        productAttributeId: attr.id,
        name: attr.product.name,
        size: attr.size,
        costPrice: attr.costPrice,
        retailPrice: attr.retailPrice,
        discountPercent: attr.discountPercent || 0,
        discountPrice: attr.discountPrice || 0,
        discountedRetailPrice: attr.discountedRetailPrice,
        quantity: qty,
        totalCostPrice: attr.costPrice * qty,
        totalPrice: attr.discountedRetailPrice * qty,
      });
    }

    const rawSubtotal = lineItems.reduce((sum, i) => sum + i.totalPrice, 0);
    const totalCostPrice = lineItems.reduce((sum, i) => sum + i.totalCostPrice, 0);
    const totalItems = lineItems.reduce((sum, i) => sum + i.quantity, 0);

    // Single order-level custom discount — flat amount or percentage.
    let discountAmount = 0;
    if (discountType === "PERCENT" && Number(discountValue) > 0) {
      discountAmount = (rawSubtotal * Number(discountValue)) / 100;
    } else if (discountType === "FLAT" && Number(discountValue) > 0) {
      discountAmount = Number(discountValue);
    }
    discountAmount = Math.min(discountAmount, rawSubtotal); // never push subtotal below 0
    const finalSubtotal = Math.round((rawSubtotal - discountAmount) * 100) / 100;

    // Create the order + items, and decrement stock, all in one transaction.
    // Stock decrement uses a conditional updateMany so a race condition
    // can't oversell — if another sale beat us to the last units, the whole
    // transaction rolls back instead of leaving a phantom sold order.
    const createdOrder = await prisma.$transaction(async (tx) => {
      const order = await tx.order.create({
        data: {
          userId: orderUserId,
          customerName: customerName || null,
          customerPhone: customerPhone || null,
          customerEmail: customerEmail || null,
          totalItems,
          subtotalCost: totalCostPrice,
          subtotal: finalSubtotal,
          paymentMethod, // "CASH" | "BKASH" | "NAGAD"
          transactionId: transactionId || null,
          status: "DELIVERED",
          isPaymentVerified: true,
          advancePaidAmount: finalSubtotal,
          dueAmount: 0,
          createdBy: staffId,
          orderSource: "OFFLINE", // POS sale — every order created here is offline/showroom
          orderItems: {
            create: lineItems.map((item) => ({
              productId: item.productId,
              productAttributeId: item.productAttributeId,
              name: item.name,
              size: item.size,
              costPrice: item.costPrice,
              retailPrice: item.retailPrice,
              discountPercent: item.discountPercent,
              discountPrice: item.discountPrice,
              discountedRetailPrice: item.discountedRetailPrice,
              quantity: item.quantity,
              totalCostPrice: item.totalCostPrice,
              totalPrice: item.totalPrice,
            })),
          },
        },
        include: { orderItems: true },
      });

      for (const item of lineItems) {
        const updated = await tx.productAttribute.updateMany({
          where: { id: item.productAttributeId, stockAmount: { gte: item.quantity } },
          data: { stockAmount: { decrement: item.quantity } },
        });
        if (updated.count === 0) {
          throw new Error(`Stock changed for ${item.name} (${item.size}) — please recheck and try again.`);
        }
      }

      return order;
    });

    return res.status(201).json(
      jsonResponse(true, "Offline sale completed", {
        orderId: createdOrder.id,
        invoiceNumber: createdOrder.invoiceNumber,
        subtotal: createdOrder.subtotal,
        totalItems: createdOrder.totalItems,
        discountAmount,
        paymentMethod: createdOrder.paymentMethod,
      })
    );
  } catch (error) {
    console.error("Offline Order Error:", error);
    return res.status(500).json(jsonResponse(false, error.message, null));
  }
};