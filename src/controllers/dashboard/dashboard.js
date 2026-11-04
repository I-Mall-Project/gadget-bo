import jsonResponse from "../../utils/jsonResponse.js";
import prisma from "../../utils/prismaClient.js";

const module_name = "dashboard";

import { Prisma } from "@prisma/client"; // needed for Prisma.sql / Prisma.empty fragments below





//get all total category by user
export const getTotalCategory = async (req, res) => {
  try {
    const totalCategory = await prisma.category.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        isDeleted: false,
        isActive: true,
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(true, `${totalCategory} categories found`, totalCategory)
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total campaign by user
export const getTotalCampaign = async (req, res) => {
  try {
    const totalCampaign = await prisma.campaign.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        isDeleted: false,
        isActive: true,
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(true, `${totalCampaign} campaigns found`, totalCampaign)
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total product by user
export const getTotalProduct = async (req, res) => {
  try {
    const totalProduct = await prisma.product.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        isDeleted: false,
        isActive: true,
      },
    });

    return res
      .status(200)
      .json(jsonResponse(true, `${totalProduct} products found`, totalProduct));
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total order by user
export const getTotalOrder = async (req, res) => {
  try {
    const totalOrder = await prisma.order.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
      },
    });

    return res
      .status(200)
      .json(jsonResponse(true, `${totalOrder} orders found`, totalOrder));
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total pending order by user
export const getPendingOrder = async (req, res) => {
  try {
    const pendingOrder = await prisma.order.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        status: "PENDING",
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(true, `${pendingOrder} pending orders found`, pendingOrder)
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total canceled order by user
export const getCanceledOrder = async (req, res) => {
  try {
    const canceledOrder = await prisma.order.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        status: "CANCELED",
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(
          true,
          `${canceledOrder} canceled orders found`,
          canceledOrder
        )
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total delivered order by user
export const getDeliveredOrder = async (req, res) => {
  try {
    const deliveredOrder = await prisma.order.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        status: "DELIVERED",
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(
          true,
          `${deliveredOrder} delivered orders found`,
          deliveredOrder
        )
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total inprogress order by user
export const getInProgressOrder = async (req, res) => {
  try {
    const inProgressOrder = await prisma.order.count({
      where: {
        // userId: req.user.parentId ? req.user.parentId : req.user.id,
        status: "SHIPPED",
      },
    });

    return res
      .status(200)
      .json(
        jsonResponse(
          true,
          `${inProgressOrder} in progress orders found`,
          inProgressOrder
        )
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total revenue by user
export const getTotalRevenue = async (req, res) => {
  try {
    const subtotal = await prisma.order.aggregate({
      // where: { userId: req.user.parentId ? req.user.parentId : req.user.id },
      _sum: {
        subtotal: true,
        subtotalCost: true,
      },
    });

    const totalRevenue = subtotal._sum.subtotal - subtotal._sum.subtotalCost;

    return res
      .status(200)
      .json(
        jsonResponse(true, `Total revenue is ${totalRevenue}`, totalRevenue)
      );
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all total revenue year wise by user
export const getTotalRevenueYearWise = async (req, res) => {
  try {
    const currentYear = req.params.year
      ? Number(req.params.year)
      : new Date().getFullYear();

    const monthlyRevenues = await prisma.$queryRaw`
  SELECT 
    EXTRACT(MONTH FROM "createdAt") AS month,
    SUM("subtotal") AS total_subtotal,
    SUM("subtotalCost") AS total_subtotalCost
  FROM "Order"
  WHERE "createdAt" >= ${new Date(`${currentYear}-01-01`)}
    AND "createdAt" < ${new Date(`${currentYear + 1}-01-01`)}
  GROUP BY EXTRACT(MONTH FROM "createdAt")
  ORDER BY month ASC;
`;

    // WHERE "userId" = ${req.user.parentId ? req.user.parentId : req.user.id}

    console.log({ monthlyRevenues });

    const revenues = monthlyRevenues.map((row) => ({
      month: row.month,
      revenue: row.total_subtotal - row.total_subtotalcost,
    }));

    return res
      .status(200)
      .json(jsonResponse(true, `Revenue generated`, revenues));
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};


// Backend Helper: Get Today's Start & End in BD Time
const getBDTodayBounds = () => {
  const now = new Date();
  const bdTimeStr = now.toLocaleString("en-US", { timeZone: "Asia/Dhaka" });
  const bdDate = new Date(bdTimeStr);

  const start = new Date(bdDate.getFullYear(), bdDate.getMonth(), bdDate.getDate(), 0, 0, 0, 0);
  const end = new Date(bdDate.getFullYear(), bdDate.getMonth(), bdDate.getDate(), 23, 59, 59, 999);

  return { start, end };
};

// Example Controller for Today's Sell Amount
export const getTodaySellAmount = async (req, res) => {
  try {
    const { start, end } = getBDTodayBounds();

    const aggregateResult = await prisma.order.aggregate({
      where: {
        createdAt: { gte: start, lte: end },
      },
      _sum: { subtotal: true },
    });

    return res.status(200).json({
      success: true,
      data: aggregateResult._sum.subtotal || 0,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// Comprehensive Analytics & Date-Filtered Report API


export const getAnalyticsReport = async (req, res) => {
  try {
    const { startDate, endDate, channel } = req.query;

    let start, end;

    if (startDate && endDate) {
      start = new Date(`${startDate}T00:00:00.000+06:00`);
      end = new Date(`${endDate}T23:59:59.999+06:00`);
    } else {
      end = new Date();
      start = new Date(Date.now() - 14 * 24 * 60 * 60 * 1000);
      start.setHours(0, 0, 0, 0);
      end.setHours(23, 59, 59, 999);
    }

    const userIdWhere = req.user?.parentId ? req.user.parentId : req.user?.id;

    // Only accept the two known values — anything else (missing, typo, etc.)
    // is treated as "no channel filter", same as today.
    const validChannel = channel === "OFFLINE" || channel === "ONLINE" ? channel : null;

    const whereCondition = {
      createdAt: {
        gte: start,
        lte: end,
      },
      ...(userIdWhere && { userId: userIdWhere }),
      ...(validChannel && { orderSource: validChannel }),
    };

    const hasUser = Boolean(userIdWhere);

    // Raw-SQL channel fragments — interpolated into the $queryRaw templates
    // below. "NoAlias" is for queries selecting straight from "Order";
    // "O" is for queries that join it in as alias `o`.
    const channelFilterNoAlias = validChannel
      ? Prisma.sql`AND "orderSource"::text = ${validChannel}`
      : Prisma.empty;

    const channelFilterO = validChannel
      ? Prisma.sql`AND o."orderSource"::text = ${validChannel}`
      : Prisma.empty;

    const [
      aggregateResult,
      deliveredAggregateResult,
      statusCounts,
      dailyAnalytics,
      customerInsightsRaw,
      topProductsRaw,
      topCustomersRaw,
      peakTimesRaw,
      districtDistributionRaw,
      highestOrderRaw,
      paymentMethodRaw,
      paymentVerificationRaw,
      deliveryChargeRaw,
      discountImpactRaw,
      topCategoriesRaw,
      topBrandsRaw,
      topSuppliersRaw,
      trendingVsRegularRaw,
      featuredVsRegularRaw,
      viewToSaleRaw,
      campaignPerformanceRaw,
      customerLifetimeValueRaw,
      recentOrdersRaw,
    ] = await Promise.all([
      // ALL ORDERS (any status) — used for "Today's Orders" count and
      // non-revenue aggregates (due/advance/delivery charge totals).
      prisma.order.aggregate({
        where: whereCondition,
        _sum: {
          dueAmount: true,
          advancePaidAmount: true,
          deliveryChargeInside: true,
          deliveryChargeOutside: true,
        },
        _count: {
          id: true,
        },
      }),

      // DELIVERED ORDERS ONLY — this is the real Sales/Profit figure.
      // Placed-but-not-yet-delivered orders (PENDING/PROCESSING/SHIPPED) and
      // CANCELED/RETURNED orders never contribute to revenue, so there's no
      // "add then subtract on cancel" logic needed anywhere.
      prisma.order.aggregate({
        where: { ...whereCondition, status: "DELIVERED" },
        _sum: {
          subtotal: true,
          subtotalCost: true,
        },
      }),

      // Per-status count AND amount — powers the "first look" order summary
      // (Placed / Delivered / In Progress / Cancelled / Returned, each with
      // its own count and ৳ value).
      prisma.order.groupBy({
        by: ["status"],
        where: whereCondition,
        _count: {
          id: true,
        },
        _sum: {
          subtotal: true,
        },
      }),

      // DAILY GRAPH — orders count reflects ALL orders placed that day,
      // but sell/profit only sum the DELIVERED ones (via FILTER), so the
      // chart's revenue line matches the same "delivered = revenue" rule.
      hasUser
        ? prisma.$queryRaw`
            SELECT 
              TO_CHAR("createdAt" AT TIME ZONE 'Asia/Dhaka', 'YYYY-MM-DD') AS date,
              COALESCE(SUM("subtotal") FILTER (WHERE "status" = 'DELIVERED'), 0) AS sell,
              COALESCE(SUM("subtotal" - "subtotalCost") FILTER (WHERE "status" = 'DELIVERED'), 0) AS profit,
              COUNT("id")::INTEGER AS orders
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "userId" = ${userIdWhere}
              ${channelFilterNoAlias}
            GROUP BY TO_CHAR("createdAt" AT TIME ZONE 'Asia/Dhaka', 'YYYY-MM-DD')
            ORDER BY date ASC;
          `
        : prisma.$queryRaw`
            SELECT 
              TO_CHAR("createdAt" AT TIME ZONE 'Asia/Dhaka', 'YYYY-MM-DD') AS date,
              COALESCE(SUM("subtotal") FILTER (WHERE "status" = 'DELIVERED'), 0) AS sell,
              COALESCE(SUM("subtotal" - "subtotalCost") FILTER (WHERE "status" = 'DELIVERED'), 0) AS profit,
              COUNT("id")::INTEGER AS orders
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              ${channelFilterNoAlias}
            GROUP BY TO_CHAR("createdAt" AT TIME ZONE 'Asia/Dhaka', 'YYYY-MM-DD')
            ORDER BY date ASC;
          `,

      hasUser
        ? prisma.$queryRaw`
            SELECT 
              COUNT(DISTINCT CASE WHEN order_count = 1 THEN "customerPhone" END)::INTEGER AS new_customers,
              COUNT(DISTINCT CASE WHEN order_count > 1 THEN "customerPhone" END)::INTEGER AS repeat_customers
            FROM (
              SELECT "customerPhone", COUNT("id") AS order_count
              FROM "Order"
              WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
                AND "status" != 'CANCELED'
                AND "userId" = ${userIdWhere}
                ${channelFilterNoAlias}
              GROUP BY "customerPhone"
            ) AS customer_orders;
          `
        : prisma.$queryRaw`
            SELECT 
              COUNT(DISTINCT CASE WHEN order_count = 1 THEN "customerPhone" END)::INTEGER AS new_customers,
              COUNT(DISTINCT CASE WHEN order_count > 1 THEN "customerPhone" END)::INTEGER AS repeat_customers
            FROM (
              SELECT "customerPhone", COUNT("id") AS order_count
              FROM "Order"
              WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
                AND "status" != 'CANCELED'
                ${channelFilterNoAlias}
              GROUP BY "customerPhone"
            ) AS customer_orders;
          `,

      // TOP 5 SELLING PRODUCTS
      hasUser
        ? prisma.$queryRaw`
            SELECT 
              oi."productId" AS product_id,
              MAX(oi."name") AS product_name,
              SUM(oi."quantity")::INTEGER AS sales_count,
              SUM(oi."totalPrice")::NUMERIC AS total_revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY oi."productId"
            ORDER BY sales_count DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT 
              oi."productId" AS product_id,
              MAX(oi."name") AS product_name,
              SUM(oi."quantity")::INTEGER AS sales_count,
              SUM(oi."totalPrice")::NUMERIC AS total_revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY oi."productId"
            ORDER BY sales_count DESC
            LIMIT 5;
          `,

      // TOP 5 CUSTOMERS — grouped by phone number (unique customer identifier),
      // with name/phone/location taken from their most recent order.
      hasUser
        ? prisma.$queryRaw`
            SELECT
              "customerPhone" AS customer_phone,
              (ARRAY_AGG("customerName" ORDER BY "createdAt" DESC))[1] AS customer_name,
              (ARRAY_AGG("customerCity" ORDER BY "createdAt" DESC))[1] AS customer_city,
              (ARRAY_AGG("customerAddress" ORDER BY "createdAt" DESC))[1] AS customer_address,
              COUNT("id")::INTEGER AS order_count,
              SUM("subtotal")::NUMERIC AS total_amount
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              AND "userId" = ${userIdWhere}
              AND "customerPhone" IS NOT NULL
              ${channelFilterNoAlias}
            GROUP BY "customerPhone"
            ORDER BY total_amount DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT
              "customerPhone" AS customer_phone,
              (ARRAY_AGG("customerName" ORDER BY "createdAt" DESC))[1] AS customer_name,
              (ARRAY_AGG("customerCity" ORDER BY "createdAt" DESC))[1] AS customer_city,
              (ARRAY_AGG("customerAddress" ORDER BY "createdAt" DESC))[1] AS customer_address,
              COUNT("id")::INTEGER AS order_count,
              SUM("subtotal")::NUMERIC AS total_amount
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              AND "customerPhone" IS NOT NULL
              ${channelFilterNoAlias}
            GROUP BY "customerPhone"
            ORDER BY total_amount DESC
            LIMIT 5;
          `,

      hasUser
        ? prisma.$queryRaw`
            SELECT 
              EXTRACT(HOUR FROM "createdAt" AT TIME ZONE 'Asia/Dhaka')::INTEGER AS hour,
              COUNT("id")::INTEGER AS orders
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              AND "userId" = ${userIdWhere}
              ${channelFilterNoAlias}
            GROUP BY hour
            ORDER BY hour ASC;
          `
        : prisma.$queryRaw`
            SELECT 
              EXTRACT(HOUR FROM "createdAt" AT TIME ZONE 'Asia/Dhaka')::INTEGER AS hour,
              COUNT("id")::INTEGER AS orders
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              ${channelFilterNoAlias}
            GROUP BY hour
            ORDER BY hour ASC;
          `,

      hasUser
        ? prisma.$queryRaw`
            SELECT 
              "customerCity" AS district,
              COUNT("id")::INTEGER AS orders,
              ROUND(
                (COUNT("id")::DECIMAL / NULLIF((
                  SELECT COUNT("id") FROM "Order" 
                  WHERE "createdAt" >= ${start} AND "createdAt" <= ${end} 
                    AND "status" != 'CANCELED'
                    AND "userId" = ${userIdWhere}
                    ${channelFilterNoAlias}
                ), 0)) * 100, 1
              )::FLOAT AS percentage
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              AND "userId" = ${userIdWhere}
              ${channelFilterNoAlias}
            GROUP BY "customerCity"
            ORDER BY orders DESC
            LIMIT 8;
          `
        : prisma.$queryRaw`
            SELECT 
              "customerCity" AS district,
              COUNT("id")::INTEGER AS orders,
              ROUND(
                (COUNT("id")::DECIMAL / NULLIF((
                  SELECT COUNT("id") FROM "Order" 
                  WHERE "createdAt" >= ${start} AND "createdAt" <= ${end} 
                    AND "status" != 'CANCELED'
                    ${channelFilterNoAlias}
                ), 0)) * 100, 1
              )::FLOAT AS percentage
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              ${channelFilterNoAlias}
            GROUP BY "customerCity"
            ORDER BY orders DESC
            LIMIT 8;
          `,

      // HIGHEST SINGLE ORDER — the single largest order (by amount) in the
      // selected period, with full customer + item-level details.
      prisma.order.findFirst({
        where: {
          ...whereCondition,
          status: { not: "CANCELED" },
        },
        orderBy: { subtotal: "desc" },
        include: { orderItems: true },
      }),

      // PAYMENT METHOD BREAKDOWN
      prisma.order.groupBy({
        by: ["paymentMethod"],
        where: { ...whereCondition, status: { not: "CANCELED" } },
        _count: { id: true },
        _sum: { subtotal: true },
      }),

      // PAYMENT VERIFICATION STATUS
      prisma.order.groupBy({
        by: ["isPaymentVerified"],
        where: { ...whereCondition, status: { not: "CANCELED" } },
        _count: { id: true },
        _sum: { subtotal: true },
      }),

      // DELIVERY CHARGE BREAKDOWN (Inside vs Outside)
      hasUser
        ? prisma.$queryRaw`
            SELECT
              COUNT(*) FILTER (WHERE "deliveryChargeInside" IS NOT NULL)::INTEGER AS inside_orders,
              COALESCE(SUM("deliveryChargeInside"), 0)::NUMERIC AS inside_total,
              COUNT(*) FILTER (WHERE "deliveryChargeOutside" IS NOT NULL)::INTEGER AS outside_orders,
              COALESCE(SUM("deliveryChargeOutside"), 0)::NUMERIC AS outside_total
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              AND "userId" = ${userIdWhere}
              ${channelFilterNoAlias}
          `
        : prisma.$queryRaw`
            SELECT
              COUNT(*) FILTER (WHERE "deliveryChargeInside" IS NOT NULL)::INTEGER AS inside_orders,
              COALESCE(SUM("deliveryChargeInside"), 0)::NUMERIC AS inside_total,
              COUNT(*) FILTER (WHERE "deliveryChargeOutside" IS NOT NULL)::INTEGER AS outside_orders,
              COALESCE(SUM("deliveryChargeOutside"), 0)::NUMERIC AS outside_total
            FROM "Order"
            WHERE "createdAt" >= ${start} AND "createdAt" <= ${end}
              AND "status" != 'CANCELED'
              ${channelFilterNoAlias}
          `,

      // DISCOUNT IMPACT (item-level discount total + coupon usage)
      hasUser
        ? prisma.$queryRaw`
            SELECT
              (SELECT COALESCE(SUM(oi."discountPrice" * oi."quantity"), 0) FROM "OrderItem" oi
                JOIN "Order" o ON o."id" = oi."orderId"
                WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
                  AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
                  ${channelFilterO})::NUMERIC AS total_discount,
              (SELECT COUNT(*) FROM "Order"
                WHERE "couponId" IS NOT NULL AND "createdAt" >= ${start} AND "createdAt" <= ${end}
                  AND "status" != 'CANCELED' AND "userId" = ${userIdWhere}
                  ${channelFilterNoAlias})::INTEGER AS coupon_orders,
              (SELECT COALESCE(SUM("subtotal"), 0) FROM "Order"
                WHERE "couponId" IS NOT NULL AND "createdAt" >= ${start} AND "createdAt" <= ${end}
                  AND "status" != 'CANCELED' AND "userId" = ${userIdWhere}
                  ${channelFilterNoAlias})::NUMERIC AS coupon_revenue;
          `
        : prisma.$queryRaw`
            SELECT
              (SELECT COALESCE(SUM(oi."discountPrice" * oi."quantity"), 0) FROM "OrderItem" oi
                JOIN "Order" o ON o."id" = oi."orderId"
                WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
                  AND o."status" != 'CANCELED'
                  ${channelFilterO})::NUMERIC AS total_discount,
              (SELECT COUNT(*) FROM "Order"
                WHERE "couponId" IS NOT NULL AND "createdAt" >= ${start} AND "createdAt" <= ${end}
                  AND "status" != 'CANCELED'
                  ${channelFilterNoAlias})::INTEGER AS coupon_orders,
              (SELECT COALESCE(SUM("subtotal"), 0) FROM "Order"
                WHERE "couponId" IS NOT NULL AND "createdAt" >= ${start} AND "createdAt" <= ${end}
                  AND "status" != 'CANCELED'
                  ${channelFilterNoAlias})::NUMERIC AS coupon_revenue;
          `,

      // TOP CATEGORIES BY REVENUE
      hasUser
        ? prisma.$queryRaw`
            SELECT c."name" AS category_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            JOIN "Category" c ON c."id" = p."categoryId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY c."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT c."name" AS category_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            JOIN "Category" c ON c."id" = p."categoryId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY c."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `,

      // TOP BRANDS BY REVENUE
      hasUser
        ? prisma.$queryRaw`
            SELECT COALESCE(b."name", 'Unbranded') AS brand_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Brand" b ON b."id" = p."brandId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY b."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT COALESCE(b."name", 'Unbranded') AS brand_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Brand" b ON b."id" = p."brandId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY b."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `,

      // TOP SUPPLIERS BY REVENUE
      hasUser
        ? prisma.$queryRaw`
            SELECT COALESCE(s."name", 'Unknown') AS supplier_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Supplier" s ON s."id" = p."supplierId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY s."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT COALESCE(s."name", 'Unknown') AS supplier_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Supplier" s ON s."id" = p."supplierId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY s."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `,

      // TRENDING vs REGULAR PRODUCT PERFORMANCE
      hasUser
        ? prisma.$queryRaw`
            SELECT p."isTrending" AS is_trending,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY p."isTrending";
          `
        : prisma.$queryRaw`
            SELECT p."isTrending" AS is_trending,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY p."isTrending";
          `,

      // FEATURED vs REGULAR PRODUCT PERFORMANCE
      hasUser
        ? prisma.$queryRaw`
            SELECT p."isFeatured" AS is_featured,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY p."isFeatured";
          `
        : prisma.$queryRaw`
            SELECT p."isFeatured" AS is_featured,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY p."isFeatured";
          `,

      // VIEW-TO-SALE CONVERSION — top viewed products vs their actual sales in this period.
      // View counts are global (not channel-specific), but the "sold" side of the
      // conversion respects the channel filter so the ratio stays meaningful.
      hasUser
        ? prisma.$queryRaw`
            SELECT p."id" AS product_id, p."name" AS product_name, p."viewCount" AS view_count,
              COALESCE(SUM(oi."quantity") FILTER (
                WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end} AND o."status" != 'CANCELED'
                ${channelFilterO}
              ), 0)::INTEGER AS units_sold
            FROM "Product" p
            LEFT JOIN "OrderItem" oi ON oi."productId" = p."id"
            LEFT JOIN "Order" o ON o."id" = oi."orderId"
            WHERE p."isDeleted" = false AND p."userId" = ${userIdWhere}
            GROUP BY p."id", p."name", p."viewCount"
            ORDER BY p."viewCount" DESC
            LIMIT 10;
          `
        : prisma.$queryRaw`
            SELECT p."id" AS product_id, p."name" AS product_name, p."viewCount" AS view_count,
              COALESCE(SUM(oi."quantity") FILTER (
                WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end} AND o."status" != 'CANCELED'
                ${channelFilterO}
              ), 0)::INTEGER AS units_sold
            FROM "Product" p
            LEFT JOIN "OrderItem" oi ON oi."productId" = p."id"
            LEFT JOIN "Order" o ON o."id" = oi."orderId"
            WHERE p."isDeleted" = false
            GROUP BY p."id", p."name", p."viewCount"
            ORDER BY p."viewCount" DESC
            LIMIT 10;
          `,

      // CAMPAIGN PERFORMANCE
      hasUser
        ? prisma.$queryRaw`
            SELECT COALESCE(cam."name", 'No Campaign') AS campaign_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Campaign" cam ON cam."id" = p."campaignId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED' AND o."userId" = ${userIdWhere}
              ${channelFilterO}
            GROUP BY cam."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT COALESCE(cam."name", 'No Campaign') AS campaign_name,
              SUM(oi."quantity")::INTEGER AS units_sold,
              SUM(oi."totalPrice")::NUMERIC AS revenue
            FROM "OrderItem" oi
            JOIN "Order" o ON o."id" = oi."orderId"
            JOIN "Product" p ON p."id" = oi."productId"
            LEFT JOIN "Campaign" cam ON cam."id" = p."campaignId"
            WHERE o."createdAt" >= ${start} AND o."createdAt" <= ${end}
              AND o."status" != 'CANCELED'
              ${channelFilterO}
            GROUP BY cam."name"
            ORDER BY revenue DESC
            LIMIT 5;
          `,

      // CUSTOMER LIFETIME VALUE — all-time (not limited to the selected date range),
      // but still respects the channel filter so "Offline CLV" vs "Online CLV" differ.
      hasUser
        ? prisma.$queryRaw`
            SELECT "customerPhone" AS customer_phone,
              (ARRAY_AGG("customerName" ORDER BY "createdAt" DESC))[1] AS customer_name,
              COUNT("id")::INTEGER AS total_orders,
              SUM("subtotal")::NUMERIC AS lifetime_value
            FROM "Order"
            WHERE "status" != 'CANCELED' AND "customerPhone" IS NOT NULL AND "userId" = ${userIdWhere}
              ${channelFilterNoAlias}
            GROUP BY "customerPhone"
            ORDER BY lifetime_value DESC
            LIMIT 5;
          `
        : prisma.$queryRaw`
            SELECT "customerPhone" AS customer_phone,
              (ARRAY_AGG("customerName" ORDER BY "createdAt" DESC))[1] AS customer_name,
              COUNT("id")::INTEGER AS total_orders,
              SUM("subtotal")::NUMERIC AS lifetime_value
            FROM "Order"
            WHERE "status" != 'CANCELED' AND "customerPhone" IS NOT NULL
              ${channelFilterNoAlias}
            GROUP BY "customerPhone"
            ORDER BY lifetime_value DESC
            LIMIT 5;
          `,

      // RECENT ORDERS FEED — latest orders within the selected period
      prisma.order.findMany({
        where: whereCondition,
        orderBy: { createdAt: "desc" },
        take: 15,
        select: {
          id: true,
          invoiceNumber: true,
          customerName: true,
          customerPhone: true,
          subtotal: true,
          status: true,
          paymentMethod: true,
          createdAt: true,
        },
      }),
    ]);

    // Sales/Profit come ONLY from delivered orders now.
    const totalSell = Number(deliveredAggregateResult._sum.subtotal) || 0;
    const totalCost = Number(deliveredAggregateResult._sum.subtotalCost) || 0;
    const totalProfit = totalSell - totalCost;

    // Orders count still reflects ALL orders placed in the period,
    // regardless of status — this is "activity", not "revenue".
    const totalOrders = aggregateResult._count.id || 0;

    const getStatusData = (statusName) => {
      const match = statusCounts.find((item) => item.status === statusName);
      return {
        count: match ? match._count.id : 0,
        amount: match ? Number(match._sum.subtotal) || 0 : 0,
      };
    };

    // Total order value across ALL statuses (placed, regardless of outcome) —
    // used for the "Total Orders Placed: ৳X" line in the summary.
    const totalOrderValue = statusCounts.reduce(
      (sum, row) => sum + (Number(row._sum.subtotal) || 0),
      0
    );

    const newCust = Number(customerInsightsRaw[0]?.new_customers) || 0;
    const repeatCust = Number(customerInsightsRaw[0]?.repeat_customers) || 0;
    const totalCust = newCust + repeatCust;
    const repeatRatio = totalCust > 0 ? ((repeatCust / totalCust) * 100).toFixed(1) : "0.0";

    const reportData = {
      totalSell,
      totalProfit,
      totalOrders,
      totalOrderValue, // ৳ value of ALL orders placed, any status

      // Each of these is now { count, amount } — everything needed for a
      // single "first look" summary card (Placed / Delivered / In Progress
      // / Cancelled / Returned), each with its own count and ৳ value.
      pendingOrders: getStatusData("PENDING"),
      inProgressOrders: getStatusData("SHIPPED"),
      deliveredOrders: getStatusData("DELIVERED"),
      canceledOrders: getStatusData("CANCELED"),
      returnedOrders: getStatusData("RETURNED"),

      graphData: dailyAnalytics.map((row) => ({
        date: row.date,
        sell: Number(row.sell) || 0,
        profit: Number(row.profit) || 0,
        orders: Number(row.orders) || 0,
      })),

      customerInsights: {
        newCustomers: newCust,
        repeatCustomers: repeatCust,
        repeatRatio: `${repeatRatio}%`,
      },
      topProducts: topProductsRaw.map((row) => ({
        productId: row.product_id,
        productName: row.product_name,
        salesCount: Number(row.sales_count) || 0,
        totalRevenue: Number(row.total_revenue) || 0,
      })),
      topCustomers: topCustomersRaw.map((row) => ({
        customerPhone: row.customer_phone,
        customerName: row.customer_name || "N/A",
        // Prefer city; fall back to full address if city isn't set.
        customerLocation: row.customer_city || row.customer_address || "N/A",
        orderCount: Number(row.order_count) || 0,
        totalAmount: Number(row.total_amount) || 0,
      })),
      peakTimes: peakTimesRaw.map((row) => ({
        hour: `${String(row.hour).padStart(2, "0")}:00`,
        orders: Number(row.orders) || 0,
      })),
      districtDistribution: districtDistributionRaw.map((row) => ({
        district: row.district || "Unknown",
        orders: Number(row.orders) || 0,
        percentage: Number(row.percentage) || 0,
      })),
      highestOrder: highestOrderRaw
        ? {
            invoiceNumber: highestOrderRaw.invoiceNumber,
            customerName: highestOrderRaw.customerName || "N/A",
            customerPhone: highestOrderRaw.customerPhone || "N/A",
            customerAddress: highestOrderRaw.customerAddress || "N/A",
            customerCity: highestOrderRaw.customerCity || "N/A",
            customerEmail: highestOrderRaw.customerEmail || "N/A",
            paymentMethod: highestOrderRaw.paymentMethod || "N/A",
            status: highestOrderRaw.status,
            totalItems: highestOrderRaw.totalItems || 0,
            subtotal: Number(highestOrderRaw.subtotal) || 0,
            createdAt: highestOrderRaw.createdAt,
            items: highestOrderRaw.orderItems.map((item) => ({
              name: item.name,
              size: item.size,
              quantity: item.quantity,
              totalPrice: Number(item.totalPrice) || 0,
            })),
          }
        : null,

      // PAYMENT & DUE
      paymentMethodBreakdown: paymentMethodRaw.map((row) => ({
        method: row.paymentMethod || "Unknown",
        orders: row._count.id || 0,
        totalAmount: Number(row._sum.subtotal) || 0,
      })),
      paymentVerification: paymentVerificationRaw.map((row) => ({
        verified: row.isPaymentVerified,
        orders: row._count.id || 0,
        totalAmount: Number(row._sum.subtotal) || 0,
      })),
      dueAmountTracker: {
        totalDue: Number(aggregateResult._sum.dueAmount) || 0,
        totalAdvancePaid: Number(aggregateResult._sum.advancePaidAmount) || 0,
      },
      deliveryChargeBreakdown: {
        insideOrders: Number(deliveryChargeRaw[0]?.inside_orders) || 0,
        insideTotal: Number(deliveryChargeRaw[0]?.inside_total) || 0,
        outsideOrders: Number(deliveryChargeRaw[0]?.outside_orders) || 0,
        outsideTotal: Number(deliveryChargeRaw[0]?.outside_total) || 0,
      },
      discountImpact: {
        totalDiscount: Number(discountImpactRaw[0]?.total_discount) || 0,
        couponOrders: Number(discountImpactRaw[0]?.coupon_orders) || 0,
        couponRevenue: Number(discountImpactRaw[0]?.coupon_revenue) || 0,
      },

      // PRODUCT & CATALOG
      topCategories: topCategoriesRaw.map((row) => ({
        name: row.category_name || "Unknown",
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),
      topBrands: topBrandsRaw.map((row) => ({
        name: row.brand_name || "Unbranded",
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),
      topSuppliers: topSuppliersRaw.map((row) => ({
        name: row.supplier_name || "Unknown",
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),
      trendingVsRegular: trendingVsRegularRaw.map((row) => ({
        isTrending: row.is_trending,
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),
      featuredVsRegular: featuredVsRegularRaw.map((row) => ({
        isFeatured: row.is_featured,
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),
      viewToSaleConversion: viewToSaleRaw.map((row) => ({
        productId: row.product_id,
        productName: row.product_name,
        viewCount: Number(row.view_count) || 0,
        unitsSold: Number(row.units_sold) || 0,
      })),
      campaignPerformance: campaignPerformanceRaw.map((row) => ({
        name: row.campaign_name || "No Campaign",
        unitsSold: Number(row.units_sold) || 0,
        revenue: Number(row.revenue) || 0,
      })),

      // CUSTOMER LIFETIME VALUE (all-time)
      customerLifetimeValue: customerLifetimeValueRaw.map((row) => ({
        customerPhone: row.customer_phone,
        customerName: row.customer_name || "N/A",
        totalOrders: Number(row.total_orders) || 0,
        lifetimeValue: Number(row.lifetime_value) || 0,
      })),

      // RECENT ORDERS FEED
      recentOrders: recentOrdersRaw.map((row) => ({
        invoiceNumber: row.invoiceNumber,
        customerName: row.customerName || "N/A",
        customerPhone: row.customerPhone || "N/A",
        subtotal: Number(row.subtotal) || 0,
        status: row.status,
        paymentMethod: row.paymentMethod || "N/A",
        createdAt: row.createdAt,
      })),
    };

    return res
      .status(200)
      .json(jsonResponse(true, "Analytics report generated", reportData));
  } catch (error) {
    console.error("Analytics Error:", error);
    return res.status(500).json(jsonResponse(false, error.message, null));
  }
};

const calculateGrowth = (current, previous) => {
  if (!previous || previous === 0) return current > 0 ? 100 : 0;
  return parseFloat((((current - previous) / previous) * 100).toFixed(1));
};

// Fixed DB Metrics Fetcher matching your Prisma Schema
const getPeriodMetrics = async (startDate, endDate) => {
  const result = await prisma.order.aggregate({
    where: {
      createdAt: {
        gte: startDate,
        lte: endDate,
      },
      isDeleted: false, // Exclude soft-deleted orders
    },
    _sum: {
      subtotal: true,     // Total Revenue
      subtotalCost: true, // Product Cost
    },
    _count: {
      id: true,
    },
  });

  const sell = result._sum?.subtotal || 0;
  const cost = result._sum?.subtotalCost || 0;

  return {
    sell,
    profit: sell - cost, // Profit = subtotal - subtotalCost
    orders: result._count?.id || 0,
  };
};

// Helper: Get pure UTC boundaries for any Asia/Dhaka local YYYY-MM-DD
const getDhakaBoundaries = (year, month, day) => {
  // Asia/Dhaka is UTC+6 (offset -360 mins)
  // Day start: YYYY-MM-DD 00:00:00 BD = YYYY-MM-DD (Prev Day) 18:00:00 UTC
  const start = new Date(Date.UTC(year, month, day, 0, 0, 0, 0) - (6 * 60 * 60 * 1000));
  
  // Day end: YYYY-MM-DD 23:59:59.999 BD = YYYY-MM-DD 17:59:59.999 UTC
  const end = new Date(Date.UTC(year, month, day + 1, 0, 0, 0, 0) - (6 * 60 * 60 * 1000) - 1);

  return { start, end };
};

export const getComparisonTrend = async (req, res) => {
  try {
    // Current time in Asia/Dhaka context
    const bdNow = new Date(new Date().toLocaleString("en-US", { timeZone: "Asia/Dhaka" }));
    const y = bdNow.getFullYear();
    const m = bdNow.getMonth();
    const d = bdNow.getDate();

    // 1. Daily (Today vs Yesterday)
    const { start: todayStart, end: todayEnd } = getDhakaBoundaries(y, m, d);
    const { start: yesterdayStart, end: yesterdayEnd } = getDhakaBoundaries(y, m, d - 1);

    // 2. Weekly (Last 7 Days vs Previous 7 Days)
    const { start: thisWeekStart } = getDhakaBoundaries(y, m, d - 6);
    const { start: lastWeekStart, end: lastWeekEnd } = getDhakaBoundaries(y, m, d - 13);
    const { end: lastWeekEndExact } = getDhakaBoundaries(y, m, d - 7);

    // 3. Monthly (This Month vs Last Month)
    const { start: thisMonthStart } = getDhakaBoundaries(y, m, 1);
    const { start: lastMonthStart } = getDhakaBoundaries(m === 0 ? y - 1 : y, m === 0 ? 11 : m - 1, 1);
    const { end: lastMonthEnd } = getDhakaBoundaries(y, m, 0); // 0 = last day of previous month

    // 4. Yearly (This Year vs Last Year)
    const { start: thisYearStart } = getDhakaBoundaries(y, 0, 1);
    const { start: lastYearStart } = getDhakaBoundaries(y - 1, 0, 1);
    const { end: lastYearEnd } = getDhakaBoundaries(y - 1, 11, 31);

    // Concurrently Fetch Period Metrics
    const [
      dayCurrent, dayPrev,
      weekCurrent, weekPrev,
      monthCurrent, monthPrev,
      yearCurrent, yearPrev
    ] = await Promise.all([
      getPeriodMetrics(todayStart, todayEnd),
      getPeriodMetrics(yesterdayStart, yesterdayEnd),

      getPeriodMetrics(thisWeekStart, todayEnd),
      getPeriodMetrics(lastWeekStart, lastWeekEndExact),

      getPeriodMetrics(thisMonthStart, todayEnd),
      getPeriodMetrics(lastMonthStart, lastMonthEnd),

      getPeriodMetrics(thisYearStart, todayEnd),
      getPeriodMetrics(lastYearStart, lastYearEnd),
    ]);

    return res.status(200).json({
      success: true,
      data: {
        day: {
          currentSell: dayCurrent.sell,
          prevSell: dayPrev.sell,
          sellGrowth: calculateGrowth(dayCurrent.sell, dayPrev.sell),
          currentProfit: dayCurrent.profit,
          prevProfit: dayPrev.profit,
          profitGrowth: calculateGrowth(dayCurrent.profit, dayPrev.profit),
          currentOrders: dayCurrent.orders,
          prevOrders: dayPrev.orders,
        },
        week: {
          currentSell: weekCurrent.sell,
          prevSell: weekPrev.sell,
          sellGrowth: calculateGrowth(weekCurrent.sell, weekPrev.sell),
          currentProfit: weekCurrent.profit,
          prevProfit: weekPrev.profit,
          profitGrowth: calculateGrowth(weekCurrent.profit, weekPrev.profit),
          currentOrders: weekCurrent.orders,
          prevOrders: weekPrev.orders,
        },
        month: {
          currentSell: monthCurrent.sell,
          prevSell: monthPrev.sell,
          sellGrowth: calculateGrowth(monthCurrent.sell, monthPrev.sell),
          currentProfit: monthCurrent.profit,
          prevProfit: monthPrev.profit,
          profitGrowth: calculateGrowth(monthCurrent.profit, monthPrev.profit),
          currentOrders: monthCurrent.orders,
          prevOrders: monthPrev.orders,
        },
        year: {
          currentSell: yearCurrent.sell,
          prevSell: yearPrev.sell,
          sellGrowth: calculateGrowth(yearCurrent.sell, yearPrev.sell),
          currentProfit: yearCurrent.profit,
          prevProfit: yearPrev.profit,
          profitGrowth: calculateGrowth(yearCurrent.profit, yearPrev.profit),
          currentOrders: yearCurrent.orders,
          prevOrders: yearPrev.orders,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};