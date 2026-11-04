import { defaultLimit, defaultPage } from "../../utils/defaultData.js";
import deleteFromCloudinary from "../../utils/deleteFromCloudinary.js";
import sendEmail from "../../utils/emailService.js";
import jsonResponse from "../../utils/jsonResponse.js";
import prisma from "../../utils/prismaClient.js";
import slugify from "../../utils/slugify.js";
import uploadToCLoudinary from "../../utils/uploadToCloudinary.js";
import validateInput from "../../utils/validateInput.js";
import uploadUrlToCloudinary from "../../utils/uploadToCloudinary.js";
import { v2 as cloudinary } from "cloudinary";
import { Client } from "@gradio/client";

const module_name = "product";


export const createProduct = async (req, res) => {
  try {
    const {
      name,
      brandId,
      categoryId,
      subcategoryId,
      subsubcategoryId,
      campaignId,
      supplierId,
      productCode,
      barcode,
      shortDescription,
      longDescription,
      sku,
      isTrending,
      isFeatured,
      isActive,
      productAttributes,
    } = req.body;

    /**
     * Upload images first (Outside Transaction)
     */
    let newImages = [];

    if (req.files && req.files.length > 0) {
      for (const file of req.files) {
        const result = await new Promise((resolve, reject) => {
          uploadToCLoudinary(file, "product", (err, response) => {
            if (err) {
              reject(err);
            } else {
              resolve(response);
            }
          });
        });

        newImages.push({
          image: result.secure_url,
        });
      }
    }

    /**
     * Prepare attributes
     */
    const attributes = Array.isArray(productAttributes)
      ? productAttributes
      : JSON.parse(productAttributes || "[]");

    /**
     * Database Transaction Only
     */
    const newProduct = await prisma.$transaction(async (tx) => {
      // Validate user
      const user = await tx.user.findFirst({
        where: {
          id: req.user.parentId ? req.user.parentId : req.user.id,
        },
      });

      if (!user) {
        throw new Error("This user does not exist");
      }

      // Validate category
      const category = await tx.category.findUnique({
        where: {
          id: categoryId,
        },
      });

      const categoryDiscount = category?.discount || 0;

      // Prepare product attributes
      const attributesData = attributes.map((attr) => {
        const retailPrice = Number(attr.retailPrice) || 0;

        const discountPercent =
          categoryDiscount > 0
            ? Number(categoryDiscount)
            : Number(attr.discountPercent) || 0;

        const discountPrice = (retailPrice * discountPercent) / 100;

        const discountedRetailPrice = retailPrice - discountPrice;

        return {
          size: attr.size,

          costPrice: Number(attr.costPrice) || 0,

          retailPrice,

          stockAmount: Number(attr.stockAmount) || 0,

          discountPercent,

          discountPrice,

          discountedRetailPrice,
        };
      });

      // Create Product
      const product = await tx.product.create({
        data: {
          userId: req.user.parentId ? req.user.parentId : req.user.id,

          brandId: brandId || null,

          categoryId,

          subcategoryId: subcategoryId || null,

          subsubcategoryId: subsubcategoryId || null,

          campaignId: campaignId || null,

          supplierId: supplierId || null,

          productCode: productCode || null,

          barcode: barcode || null,

          name,

          shortDescription,

          longDescription: longDescription || null,

          sku: sku || null,

          isTrending: isTrending === "true",

          isFeatured: isFeatured === "true",

          isActive: isActive === "true",

          createdBy: req.user.id,

          slug: `${slugify(user.name)}-${slugify(name)}`,

          productAttributes: {
            create: attributesData,
          },

          images:
            newImages.length > 0
              ? {
                  create: newImages,
                }
              : undefined,
        },
      });

      return product;
    });

    // =========================================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================================
   // =========================================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================================
    const frontendUrl = "http://localhost:3000" || "https://fashion-fo.vercel.app";
    const secretToken = "my_super_secret_token_123";

    // Async Request - Backend Response কে আটকে রাখবে না
    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });

        const result = await response.json();
        console.log("🚀 [Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Revalidate Error]:", err.message);
      }
    })();

    return res.status(200).json(
      jsonResponse(true, "Product has been created", newProduct)
    );
  } catch (error) {
    console.log("Create Product Error:", error);

    return res
      .status(500)
      .json(
        jsonResponse(
          false,
          error.message || "Internal Server Error",
          null
        )
      );
  }
};


export const bulkCreateProducts = async (req, res) => {
  try {
    const { products } = req.body; 
    // products array hobe, jekhane protita item-er bhitor 
    // name, categoryId, productAttributes, ittyadi thakbe.

    if (!Array.isArray(products) || products.length === 0) {
      return res.status(400).json(jsonResponse(false, "Products array is required for bulk upload", null));
    }

    // 1. User Validation (Sob product-er jonner ekoi user/parent hobe)
    const userId = req.user.parentId ? req.user.parentId : req.user.id;
    const user = await prisma.user.findFirst({
      where: { id: userId },
    });

    if (!user) {
      return res.status(404).json(jsonResponse(false, "This user does not exist", null));
    }

    const createdProducts = [];

    // 2. Loop through each product for transaction creation
    for (const item of products) {
      const {
        name,
        brandId,
        categoryId,
        subcategoryId,
        subsubcategoryId,
        campaignId,
        supplierId,
        productCode,
        barcode,
        shortDescription,
        longDescription,
        sku,
        isTrending,
        isFeatured,
        isActive,
        productAttributes,
      } = item;

      if (!name || !categoryId) {
        continue; // ba error throw korte paren jodi mandatory field miss kore
      }

      // Fetch Category for Discount calculation
      const category = await prisma.category.findUnique({
        where: { id: categoryId },
      });
      const categoryDiscount = category?.discount || 0;

      // Parse Attributes
      const attributes = Array.isArray(productAttributes)
        ? productAttributes
        : JSON.parse(productAttributes || "[]");

      const attributesData = attributes.map((attr) => {
        const retailPrice = Number(attr.retailPrice) || 0;
        const discountPercent =
          categoryDiscount > 0
            ? Number(categoryDiscount)
            : Number(attr.discountPercent) || 0;
        const discountPrice = (retailPrice * discountPercent) / 100;
        const discountedRetailPrice = retailPrice - discountPrice;

        return {
          size: attr.size || "",
          costPrice: Number(attr.costPrice) || 0,
          retailPrice,
          stockAmount: Number(attr.stockAmount) || 0,
          discountPercent,
          discountPrice,
          discountedRetailPrice,
        };
      });

      // Database Transaction for individual product
      const newProduct = await prisma.$transaction(async (tx) => {
        return await tx.product.create({
          data: {
            userId,
            brandId: brandId || null,
            categoryId,
            subcategoryId: subcategoryId || null,
            subsubcategoryId: subsubcategoryId || null,
            campaignId: campaignId || null,
            supplierId: supplierId || null,
            productCode: productCode || null,
            barcode: barcode || null,
            name,
            shortDescription: shortDescription || null,
            longDescription: longDescription || null,
            sku: sku || null,
            isTrending: Boolean(isTrending),
            isFeatured: Boolean(isFeatured),
            isActive: isActive !== undefined ? Boolean(isActive) : true,
            createdBy: req.user.id,
            slug: `${slugify(user.name)}-${slugify(name)}-${Date.now()}`, // Unique slug fix with timestamp to avoid clash
            productAttributes: {
              create: attributesData,
            },
            // Image faka thakbe, pore manually update/upload kora jabe
            images: undefined, 
          },
        });
      });

      createdProducts.push(newProduct);
    }

    // =========================================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER (Bulk)
    // =========================================================================
    const frontendUrl = "http://localhost:3000";
    const secretToken = "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log("🚀 [Bulk Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Bulk Revalidate Error]:", err.message);
      }
    })();

    return res.status(200).json(
      jsonResponse(true, `${createdProducts.length} products have been created successfully`, createdProducts)
    );

  } catch (error) {
    console.log("Bulk Create Product Error:", error);
    return res.status(500).json(
      jsonResponse(false, error.message || "Internal Server Error", null)
    );
  }
};

//send product email
export const sendProductEmail = async (req, res) => {
  try {
    const products = await prisma.product.findFirst({
      where: {
        id: req.params.id,
        isDeleted: false,
        isActive: true,
      },
      include: {
        user: true,
        category: true,
        campaign: true,
        supplier: true,
        images: true,
        productAttributes: true,
        subcategory: true,
        subsubcategory: true,
        brand: true,
        review: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    // if (products.length === 0)
    //   return res
    //     .status(200)
    //     .json(jsonResponse(true, "No product is available", null));

    if (products) {
      const emailList = await prisma.newsletter.findMany({
        where: { isActive: true },
      });

      console.log({ emailList });

      if (emailList) {
        for (let i = 0; i < emailList?.length; i++) {
          const emailGenerate = await sendEmail(
            emailList[i]?.email,
            `🌟 Just In! New Product Now Available! 🛍️`,
            `<h2>New Arrival Alert! Find Your Perfect Match 🎉</h2><br/>
    
              <p>Exciting news! A brand-new product has just landed on our store, and it’s available in multiple variants to match your style and needs!</p><br/>

              <p>✨ <b>${products?.name} – Now in Different Variants & Styles!</b></p>
              <p><b>🛍️ Choose from a variety of options to find your perfect fit.<b/></p>
              <p><b>🚀 Limited Stock – Get Yours Before It’s Gone!<b/></p>
              <br/>
              <p>Be among the first to explore and grab this latest addition!</p>

              <p>👉 <a href="https://strikeoffcial.site/product-details/${products?.slug}">Shop Now</a></p>
    
              <br/>
              <p><b>Happy Shopping!</b></p>
              <h4><b>Strike</b></h4>
            `
          );
        }
      }

      return res
        .status(200)
        .json(jsonResponse(true, `Email is sent to the subscribers`, products));
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

//get all products
export const getProducts = async (req, res) => {
  if (req.user.roleName !== "super-admin") {
    getProductsByUser(req, res);
  } else {
    try {
      const products = await prisma.product.findMany({
        where: {
          isDeleted: false,
          AND: [
            {
              name: {
                contains: req.query.name,
                mode: "insensitive",
              },
            },
            {
              productCode: {
                contains: req.query.product_code,
                mode: "insensitive",
              },
            },
            {
              barcode: {
                contains: req.query.barcode,
                mode: "insensitive",
              },
            },
          ],
        },
        include: {
          user: true,
          category: true,
          campaign: true,
          supplier: true,
          images: true,
          productAttributes: true,
          subcategory: true,
          subsubcategory: true,
          brand: true,
          review: true,
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

      if (products.length === 0)
        return res
          .status(200)
          .json(jsonResponse(true, "No product is available", null));

      if (products) {
        return res
          .status(200)
          .json(
            jsonResponse(true, `${products.length} products found`, products)
          );
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Something went wrong. Try again", null));
      }
    } catch (error) {
      console.log(error);
      return res.status(500).json(jsonResponse(false, error, null));
    }
  }
};





// Get Products By User
export const getProductsByUser = async (req, res) => {
  try {
    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 20;
    const skip = (page - 1) * limit;

    const where = {
      userId: req.user.parentId || req.user.id,
      isDeleted: false,
    };

    // Dynamic Search
    if (req.query.name) {
      where.name = {
        contains: req.query.name,
        mode: "insensitive",
      };
    }

    if (req.query.product_code) {
      where.productCode = {
        contains: req.query.product_code,
        mode: "insensitive",
      };
    }

    if (req.query.barcode) {
      where.barcode = {
        contains: req.query.barcode,
        mode: "insensitive",
      };
    }

    if (req.query.categoryId) {
      where.categoryId = req.query.categoryId;
    }

    if (req.query.brandId) {
      where.brandId = req.query.brandId;
    }

    const [products, total] = await prisma.$transaction([
      prisma.product.findMany({
        where,
        orderBy: {
          createdAt: "desc",
        },
        skip,
        take: limit,

        select: {
          id: true,
          name: true,
          slug: true,
          productCode: true,
          barcode: true,
          isActive: true,
          createdAt: true,

          category: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          subcategory: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          subsubcategory: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          brand: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          images: {
            take: 1,
            orderBy: {
              createdAt: "asc",
            },
            select: {
              id: true,
              image: true,
            },
          },

          productAttributes: {
            take: 1,
            orderBy: {
              createdAt: "asc",
            },
            select: {
              id: true,
              price: true,
              discountPrice: true,
              stockAmount: true,
            },
          },
        },
      }),

      prisma.product.count({
        where,
      }),
    ]);

    return res.status(200).json(
      jsonResponse(true, "Products fetched successfully", {
        products,
        pagination: {
          total,
          page,
          limit,
          totalPages: Math.ceil(total / limit),
        },
      })
    );
  } catch (error) {
    console.error(error);

    return res
      .status(500)
      .json(jsonResponse(false, "Internal Server Error", null));
  }
};





//get single product
// export const getProduct = async (req, res) => {
//   try {
//     const product = await prisma.product.findFirst({
//       where: { slug: req.params.slug, isDeleted: false },
//       include: {
//         user: true,
//         category: true,
//         campaign: true,
//         supplier: true,
//         images: true,
//         productAttributes: true,
//         subcategory: true,
//         subsubcategory: true,
//         brand: true,
//         review: true,
//       },
//     });

//     if (product) {
//       return res
//         .status(200)
//         .json(jsonResponse(true, `1 product found`, product));
//     } else {
//       return res
//         .status(404)
//         .json(jsonResponse(false, "No product is available", null));
//     }
//   } catch (error) {
//     console.log(error);
//     return res.status(500).json(jsonResponse(false, error, null));
//   }
// };


// Get Single Product
export const getProduct = async (req, res) => {
  try {
    const { slug } = req.params;

    const product = await prisma.product.findFirst({
      where: {
        slug,
        isDeleted: false,
      },

      select: {
        id: true,
        name: true,
        slug: true,
        shortDescription: true,
        description: true,
        productCode: true,
        barcode: true,
        videoUrl: true,
        metaTitle: true,
        metaDescription: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,

        category: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subsubcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        brand: {
          select: {
            id: true,
            name: true,
            slug: true,
            image: true,
          },
        },

        images: {
          orderBy: {
            createdAt: "asc",
          },
          select: {
            id: true,
            image: true,
          },
        },

        productAttributes: {
          orderBy: {
            createdAt: "asc",
          },
          select: {
            id: true,
            sku: true,
            size: true,
            color: true,
            price: true,
            discountPrice: true,
            stockAmount: true,
          },
        },

        review: {
          orderBy: {
            createdAt: "desc",
          },
          select: {
            id: true,
            rating: true,
            review: true,
            createdAt: true,

            user: {
              select: {
                id: true,
                name: true,
                image: true,
              },
            },
          },
        },
      },
    });

    if (!product) {
      return res
        .status(404)
        .json(jsonResponse(false, "Product not found", null));
    }

    return res.status(200).json(
      jsonResponse(true, "Product fetched successfully", product)
    );
  } catch (error) {
    console.error(error);

    return res
      .status(500)
      .json(jsonResponse(false, "Internal Server Error", null));
  }
};

//update product
export const updateProduct = async (req, res) => {
  try {
    const {
      brandId,
      categoryId,
      subcategoryId,
      subsubcategoryId,
      campaignId,
      supplierId,
      productCode,
      barcode,
      name,
      shortDescription,
      longDescription,
      sku,
      isTrending,
      isFeatured,
      isActive,
    } = req.body;

    // Validate input
    const inputValidation = validateInput(
      [name, categoryId, shortDescription],
      ["Name", "Category", "Short Description"]
    );

    if (inputValidation) {
      return res.status(400).json(jsonResponse(false, inputValidation, null));
    }

    // Perform database updates inside transaction
    const updatedProduct = await prisma.$transaction(async (tx) => {
      const findProduct = await tx.product.findFirst({
        where: { id: req.params.id },
      });

      if (!findProduct) {
        throw new Error("This product does not exist");
      }

      const user = await tx.user.findFirst({
        where: { id: findProduct.userId },
      });

      if (!user) {
        throw new Error("This user does not exist");
      }

      // Check for duplicate slug/name
      if (name && name !== findProduct.name) {
        const existingProduct = await tx.product.findFirst({
          where: {
            userId: req.user.parentId ? req.user.parentId : req.user.id,
            name: name,
            isDeleted: false,
          },
        });

        if (
          existingProduct &&
          existingProduct.slug === `${slugify(user.name)}-${slugify(name)}`
        ) {
          throw new Error(`${name} already exists. Change its name.`);
        }
      }

      // Update product record
      const product = await tx.product.update({
        where: { id: req.params.id },
        data: {
          userId: req.user.parentId ? req.user.parentId : req.user.id,
          brandId,
          categoryId,
          subcategoryId,
          subsubcategoryId,
          campaignId,
          supplierId,
          productCode,
          barcode,
          name,
          shortDescription,
          longDescription,
          sku,
          isActive: isActive === "true",
          isTrending: isTrending === "true",
          isFeatured: isFeatured === "true",
          updatedBy: req.user.id,
          slug: name
            ? `${slugify(user.name)}-${slugify(name)}`
            : findProduct.slug,
        },
      });

      return product;
    });

    // =========================================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================================
    const frontendUrl = process.env.NEXTJS_FRONTEND_URL || "http://127.0.0.1:3000";
    const secretToken = process.env.REVALIDATE_SECRET_TOKEN || "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log("🚀 [Update Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Update Revalidate Error]:", err.message);
      }
    })();

    return res
      .status(200)
      .json(jsonResponse(true, "Product has been updated", updatedProduct));

  } catch (error) {
    console.error("Update Product Error:", error);
    const status = error.message?.includes("already exists") ? 409 : 500;
    return res
      .status(status)
      .json(jsonResponse(false, error.message || "Something went wrong", null));
  }
};
//update product attribute
export const updateProductAttribute = async (req, res) => {
  try {
    const { size, costPrice, retailPrice, discountPercent, stockAmount } =
      req.body;

    // Perform DB operation inside transaction
    const updatedAttribute = await prisma.$transaction(async (tx) => {
      // Get existing product attribute
      const existingAttr = await tx.productAttribute.findFirst({
        where: { id: req.params.id },
      });

      if (!existingAttr) {
        throw new Error("This product attribute does not exist");
      }

      // Determine updated prices
      const finalRetailPrice =
        retailPrice !== undefined && retailPrice !== null
          ? Number(retailPrice)
          : existingAttr.retailPrice;

      const finalDiscountPercent =
        discountPercent !== undefined && discountPercent !== null
          ? Number(discountPercent)
          : existingAttr.discountPercent;

      const discountPrice = (finalRetailPrice * finalDiscountPercent) / 100;
      const discountedRetailPrice = finalRetailPrice - discountPrice;

      // Update product attribute
      const productAttribute = await tx.productAttribute.update({
        where: { id: req.params.id },
        data: {
          size: size !== undefined ? size : existingAttr.size,
          costPrice:
            costPrice !== undefined
              ? Number(costPrice)
              : existingAttr.costPrice,
          retailPrice: finalRetailPrice,
          discountPercent: finalDiscountPercent,
          discountPrice,
          discountedRetailPrice,
          stockAmount:
            stockAmount !== undefined
              ? Number(stockAmount)
              : existingAttr.stockAmount,
        },
      });

      return productAttribute;
    });

    // =========================================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================================
    const frontendUrl =
      process.env.NEXTJS_FRONTEND_URL || "http://127.0.0.1:3000";
    const secretToken =
      process.env.REVALIDATE_SECRET_TOKEN || "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log("🚀 [Attribute Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Attribute Revalidate Error]:", err.message);
      }
    })();

    return res.status(200).json(
      jsonResponse(
        true,
        "Product attribute has been updated",
        updatedAttribute
      )
    );
  } catch (error) {
    console.error("Update Product Attribute Error:", error);
    const status = error.message?.includes("does not exist") ? 404 : 500;
    return res
      .status(status)
      .json(
        jsonResponse(false, error.message || "Internal Server Error", null)
      );
  }
};
//update product image
// UPDATE PRODUCT IMAGE BY URL

export const updateProductImage = async (req, res) => {
  try {
    const imageId = req.params.id;

    // =====================================================
    // VALIDATION
    // =====================================================
    if (!imageId) {
      return res
        .status(400)
        .json(jsonResponse(false, "Image ID is required", null));
    }

    // =====================================================
    // FIND EXISTING IMAGE
    // =====================================================
    const existingImage = await prisma.productImage.findUnique({
      where: { id: imageId },
    });

    if (!existingImage) {
      return res
        .status(404)
        .json(jsonResponse(false, "Product image not found", null));
    }

    let finalImageUrl = "";
    const imageUrl =
      typeof req.body?.image === "string" ? req.body.image.trim() : "";

    // =====================================================
    // OPTION 1 — IMAGE URL UPDATE
    // =====================================================
    if (imageUrl) {
      if (imageUrl.includes("res.cloudinary.com/")) {
        finalImageUrl = imageUrl;
      } else {
        try {
          const cloudinaryResult = await uploadUrlToCloudinary(
            imageUrl,
            module_name
          );

          if (!cloudinaryResult?.secure_url) {
            return res
              .status(500)
              .json(
                jsonResponse(
                  false,
                  "Failed to upload image to Cloudinary",
                  null
                )
              );
          }
          finalImageUrl = cloudinaryResult.secure_url;
        } catch (uploadError) {
          console.error("Cloudinary URL upload error:", uploadError);
          return res
            .status(500)
            .json(
              jsonResponse(
                false,
                "Failed to upload image to Cloudinary",
                null
              )
            );
        }
      }
    } 
    // =====================================================
    // OPTION 2 — FILE UPDATE
    // =====================================================
    else if (req.file) {
      try {
        // Promisify file upload for cleaner await
        const uploadResult = await new Promise((resolve, reject) => {
          uploadToCLoudinary(req.file, module_name, (error, result) => {
            if (error) return reject(error);
            resolve(result);
          });
        });

        if (!uploadResult?.secure_url) {
          return res
            .status(500)
            .json(
              jsonResponse(
                false,
                "Cloudinary did not return image URL",
                null
              )
            );
        }

        finalImageUrl = uploadResult.secure_url;
      } catch (uploadError) {
        console.error("Cloudinary file upload error:", uploadError);
        return res
          .status(500)
          .json(jsonResponse(false, "Image upload failed", null));
      }
    } else {
      return res
        .status(400)
        .json(
          jsonResponse(
            false,
            "Image file or image URL is required",
            null
          )
        );
    }

    // =====================================================
    // UPDATE DATABASE
    // =====================================================
    const updatedImage = await prisma.productImage.update({
      where: { id: imageId },
      data: {
        image: finalImageUrl,
        ...(req.user?.id ? { updatedBy: req.user.id } : {}),
      },
    });

    // =====================================================
    // DELETE OLD CLOUDINARY IMAGE (BACKGROUND TASK)
    // =====================================================
    if (
      existingImage.image &&
      existingImage.image !== finalImageUrl &&
      existingImage.image.includes("res.cloudinary.com/")
    ) {
      deleteFromCloudinary(existingImage.image, (deleteError) => {
        if (deleteError) {
          console.error("Old Cloudinary image delete error:", deleteError);
        }
      }).catch((err) =>
        console.error("Old Cloudinary image delete exception:", err)
      );
    }

    // =========================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================
    const frontendUrl =
      process.env.NEXTJS_FRONTEND_URL || "http://127.0.0.1:3000";
    const secretToken =
      process.env.REVALIDATE_SECRET_TOKEN || "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log("🚀 [Image Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Image Revalidate Error]:", err.message);
      }
    })();

    // =====================================================
    // RESPONSE
    // =====================================================
    return res
      .status(200)
      .json(
        jsonResponse(
          true,
          "Product image has been updated",
          updatedImage
        )
      );
  } catch (error) {
    console.error("updateProductImage error:", error);
    return res
      .status(500)
      .json(jsonResponse(false, error?.message || "Server Error", null));
  }
};



//delete product image
export const deleteProductImage = async (req, res) => {
  try {
    const { id } = req.params;

    // Perform database delete operation inside transaction
    const deletedImage = await prisma.$transaction(async (tx) => {
      const existingImage = await tx.productImage.findUnique({
        where: { id },
      });

      if (!existingImage) {
        throw new Error("Product image not found");
      }

      const productImage = await tx.productImage.delete({
        where: { id },
      });

      return productImage;
    });

    // =========================================================
    // DELETE IMAGE FROM CLOUDINARY (BACKGROUND TASK)
    // =========================================================
    if (
      deletedImage?.image &&
      deletedImage.image.includes("res.cloudinary.com/")
    ) {
      deleteFromCloudinary(deletedImage.image, (error, result) => {
        if (error) {
          console.error("Cloudinary delete error:", error);
        } else {
          console.log("Cloudinary delete result:", result);
        }
      }).catch((err) => console.error("Cloudinary exception:", err));
    }

    // =========================================================
    // 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    // =========================================================
    const frontendUrl =
      process.env.NEXTJS_FRONTEND_URL || "http://127.0.0.1:3000";
    const secretToken =
      process.env.REVALIDATE_SECRET_TOKEN || "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log("🚀 [Delete Image Revalidate Log]:", response.status, result);
      } catch (err) {
        console.error("❌ [Delete Image Revalidate Error]:", err.message);
      }
    })();

    return res
      .status(200)
      .json(
        jsonResponse(true, "Product image has been deleted", deletedImage)
      );
  } catch (error) {
    console.error("Delete Product Image Error:", error);
    const status = error.message?.includes("not found") ? 404 : 500;
    return res
      .status(status)
      .json(
        jsonResponse(false, error.message || "Internal Server Error", null)
      );
  }
};
//increase view count
export const increaseProductViewCount = async (req, res) => {
  try {
    //get user id from product and user name from user for increasing view count
    const findProduct = await prisma.product.findFirst({
      where: { id: req.params.id, isActive: true, isDeleted: false },
    });

    if (!findProduct)
      return res
        .status(404)
        .json(jsonResponse(false, "This product does not exist", null));

    const user = await prisma.user.findFirst({
      where: { id: findProduct.userId, isActive: true, isDeleted: false },
    });

    if (!user)
      return res
        .status(404)
        .json(jsonResponse(false, "This product does not exist", null));

    //increase view count
    const product = await prisma.product.update({
      where: { id: req.params.id, isActive: true, isDeleted: false },
      data: {
        viewCount: findProduct.viewCount + 1,
      },
    });

    if (product) {
      return res
        .status(200)
        .json(
          jsonResponse(
            true,
            `A user has viewed your ${findProduct.name} product`,
            product
          )
        );
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "Something went wrong!", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//ban product
export const banProduct = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      //ban product
      const getProduct = await tx.product.findFirst({
        where: { id: req.params.id },
      });

      const product = await tx.product.update({
        where: { id: req.params.id },
        data: {
          isActive: getProduct.isActive === true ? false : true,
          updatedBy: req.user.id,
        },
      });

      if (product) {
        return res
          .status(200)
          .json(jsonResponse(true, `Product has been banned`, product));
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Product has not been banned", null));
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//delete product
// delete product
export const deleteProduct = async (req, res) => {
  try {
    const productId = req.params.id;

    // 1. Perform soft-delete inside database transaction
    const { deletedProduct, productImages } = await prisma.$transaction(
      async (tx) => {
        // Check existing product
        const existingProduct = await tx.product.findUnique({
          where: { id: productId },
        });

        if (!existingProduct || existingProduct.isDeleted) {
          throw new Error("Product not found or already deleted");
        }

        // Fetch attached images before soft deleting
        const images = await tx.productImage.findMany({
          where: { productId },
        });

        // Soft delete the main product
        const product = await tx.product.update({
          where: { id: productId },
          data: {
            isDeleted: true,
            ...(req.user?.id ? { deletedBy: req.user.id } : {}),
          },
        });

        // Optional: Soft delete related attributes & images if needed
        await tx.productAttribute.updateMany({
          where: { productId },
          data: { isDeleted: true },
        });

        await tx.productImage.updateMany({
          where: { productId },
          data: { isDeleted: true },
        });

        return { deletedProduct: product, productImages: images };
      }
    );

    // 2. Clean up Cloudinary images in background (Non-blocking)
    if (productImages && productImages.length > 0) {
      (async () => {
        for (const img of productImages) {
          if (img?.image && img.image.includes("res.cloudinary.com/")) {
            try {
              await deleteFromCloudinary(img.image, (error, result) => {
                if (error)
                  console.error("Cloudinary delete error:", error);
              });
            } catch (err) {
              console.error("Cloudinary exception:", err);
            }
          }
        }
      })();
    }

    // 3. 🚀 AUTOMATED NEXT.JS CACHE REVALIDATION TRIGGER
    const frontendUrl =
      process.env.NEXTJS_FRONTEND_URL || "http://127.0.0.1:3000";
    const secretToken =
      process.env.REVALIDATE_SECRET_TOKEN || "my_super_secret_token_123";

    (async () => {
      try {
        const response = await fetch(`${frontendUrl}/api/revalidate`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-revalidate-token": secretToken,
          },
        });
        const result = await response.json();
        console.log(
          "🚀 [Delete Product Revalidate Log]:",
          response.status,
          result
        );
      } catch (err) {
        console.error("❌ [Delete Product Revalidate Error]:", err.message);
      }
    })();

    // 4. Return success response
    return res
      .status(200)
      .json(
        jsonResponse(true, "Product has been deleted", deletedProduct)
      );
  } catch (error) {
    console.error("Delete Product Error:", error);
    const status = error.message?.includes("not found") ? 404 : 500;
    return res
      .status(status)
      .json(
        jsonResponse(false, error.message || "Internal Server Error", null)
      );
  }
};


// Get Trending Products For Customer
export const getTrendingProductsForCustomer = async (req, res) => {
  try {
    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 20;
    const skip = (page - 1) * limit;

    const where = {
      isDeleted: false,
      isActive: true,
      isTrending: true,
    };

    const [products, total] = await prisma.$transaction([
      prisma.product.findMany({
        where,

        orderBy: {
          createdAt: "desc",
        },

        skip,
        take: limit,

        select: {
          id: true,
          name: true,
          slug: true,
          shortDescription: true,
          productCode: true,
          barcode: true,
          sku: true,
          viewCount: true,
          createdAt: true,
          isActive: true,
          isTrending: true,
          isFeatured: true,

          brand: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          category: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          subcategory: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          subsubcategory: {
            select: {
              id: true,
              name: true,
              slug: true,
            },
          },

          campaign: {
            select: {
              id: true,
              name: true,
            },
          },

          images: {
            take: 1,
            orderBy: {
              createdAt: "asc",
            },
            select: {
              image: true,
            },
          },

          productAttributes: {
            take: 1,
            orderBy: {
              retailPrice: "asc",
            },
            select: {
              id: true,
              size: true,
              retailPrice: true,
              discountPercent: true,
              discountPrice: true,
              discountedRetailPrice: true,
              stockAmount: true,
            },
          },
        },
      }),

      prisma.product.count({
        where,
      }),
    ]);

    return res.status(200).json({
      success: true,
      message: `${products.length} trending products found`,
      data: products,
      pagination: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};



// Get Featured Products For Customer
export const getFeaturedProductsForCustomer = async (req, res) => {
  try {
    const products = await prisma.product.findMany({
      where: {
        isDeleted: false,
        isActive: true,
        isFeatured: true,
      },

      orderBy: {
        createdAt: "desc",
      },

      select: {
        id: true,
        name: true,
        slug: true,

        shortDescription: true,
        productCode: true,
        barcode: true,
        sku: true,
        viewCount: true,
        createdAt: true,
        isActive: true,
        isTrending: true,
        isFeatured: true,

        category: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subsubcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        brand: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        campaign: {
          select: {
            id: true,
            name: true,
          },
        },

        images: {
          take: 1,
          orderBy: {
            createdAt: "asc",
          },
          select: {
            image: true,
          },
        },

        productAttributes: {
          take: 1,
          orderBy: {
            retailPrice: "asc",
          },
          select: {
            id: true,
            size: true,
            retailPrice: true,
            discountPercent: true,
            discountPrice: true,
            discountedRetailPrice: true,
            stockAmount: true,
          },
        },
      },
    });

    if (!products.length) {
      return res
        .status(200)
        .json(jsonResponse(true, "No featured products available", []));
    }

    return res.status(200).json(
      jsonResponse(
        true,
        `${products.length} featured products found`,
        products
      )
    );
  } catch (error) {
    console.error(error);

    return res
      .status(500)
      .json(jsonResponse(false, "Internal Server Error", null));
  }
};





export const getProductsForCustomer = async (req, res) => {
  try {
    // ===================== PAGINATION =====================
    const page = Math.max(Number(req.query.page) || 1, 1);
    const requestedLimit = Number(req.query.limit) || Number(defaultLimit());
    const limit = Math.min(Math.max(requestedLimit, 1), 1000);
    const skip = (page - 1) * limit;

    // ===================== BASE WHERE =====================
    const where = {
      isDeleted: false,
      isActive: true,
    };

    // ===================== DYNAMIC FILTERS =====================
    if (req.query.name) {
      where.name = { contains: req.query.name, mode: "insensitive" };
    }
    if (req.query.product_code) {
      where.productCode = { contains: req.query.product_code, mode: "insensitive" };
    }
    if (req.query.barcode) {
      where.barcode = { contains: req.query.barcode, mode: "insensitive" };
    }
    if (req.query.categoryId) where.categoryId = req.query.categoryId;
    if (req.query.subcategoryId) where.subcategoryId = req.query.subcategoryId;
    if (req.query.subsubcategoryId) where.subsubcategoryId = req.query.subsubcategoryId;
    if (req.query.brandId) where.brandId = req.query.brandId;

    if (req.query.isFeatured !== undefined) {
      where.isFeatured = req.query.isFeatured === "true";
    }
    if (req.query.isTrending !== undefined) {
      where.isTrending = req.query.isTrending === "true";
    }

    // ACCURATE DISCOUNT FILTER
    if (req.query.hasDiscount === "true") {
      where.productAttributes = {
        some: {
          OR: [
            { discountPercent: { gt: 0 } },
            { discountPrice: { gt: 0 } },
            { discountedRetailPrice: { gt: 0 } },
          ],
        },
      };
    }

    // ===================== DYNAMIC SORTING =====================
    let orderBy = { createdAt: "desc" };

    if (req.query.sortBy === "most-selling" || req.query.sortBy === "popular") {
      orderBy = { viewCount: "desc" };
    }

    // ===================== DATABASE QUERY =====================
    const [products, total] = await prisma.$transaction([
      prisma.product.findMany({
        where,
        orderBy,
        skip,
        take: limit,
        select: {
          id: true,
          name: true,
          slug: true,
          shortDescription: true,
          productCode: true,
          barcode: true,
          sku: true,
          viewCount: true,
          createdAt: true,
          isActive: true,
          isFeatured: true,
          isTrending: true,
          user: { select: { name: true, image: true } },
          category: { select: { id: true, name: true, slug: true } },
          subcategory: { select: { id: true, name: true, slug: true } },
          subsubcategory: { select: { id: true, name: true, slug: true } },
          brand: { select: { id: true, name: true, slug: true } },
          campaign: { select: { id: true, name: true } },
          images: {
            take: 1,
            orderBy: { createdAt: "asc" },
            select: { image: true },
          },
          productAttributes: {
            take: 1,
            orderBy: { retailPrice: "asc" },
            select: {
              id: true,
              size: true,
              costPrice: true,
              retailPrice: true,
              discountPercent: true,
              discountPrice: true,
              discountedRetailPrice: true,
              stockAmount: true,
            },
          },
        },
      }),

      prisma.product.count({ where }),
    ]);

    // ===================== CDN CACHE =====================
    res.setHeader(
      "Cache-Control",
      "public, s-maxage=60, stale-while-revalidate=30"
    );

    // ===================== RESPONSE =====================
    return res.status(200).json(
      jsonResponse(true, "Products fetched successfully", {
        products,
        pagination: {
          total,
          page,
          limit,
          totalPages: Math.ceil(total / limit),
        },
      })
    );
  } catch (error) {
    console.error("❌ Get Products API Error:", error);
    return res
      .status(500)
      .json(jsonResponse(false, "Internal Server Error", null));
  }
};


export const getProductForCustomer = async (req, res) => {
  try {
    const { slug } = req.params;

    const product = await prisma.product.findFirst({
      where: {
        slug,
        isDeleted: false,
        isActive: true,
      },
      select: {
        id: true,
        name: true,
        slug: true,
        shortDescription: true,
        longDescription: true,
        productCode: true,
        barcode: true,
        sku: true,
        createdAt: true,
        isActive: true,
        isTrending: true,
        isFeatured: true,

        user: {
          select: {
            id: true,
            name: true,
            image: true,
          },
        },

        category: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        subsubcategory: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        brand: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },

        campaign: {
          select: {
            id: true,
            name: true,
          },
        },

        images: {
          orderBy: {
            createdAt: "asc",
          },
          select: {
            id: true,
            image: true,
          },
        },

        productAttributes: {
          orderBy: {
            retailPrice: "asc",
          },
          select: {
            id: true,
            size: true,
            costPrice: true,
            retailPrice: true,
            discountPercent: true,
            discountPrice: true,
            discountedRetailPrice: true,
            stockAmount: true,
          },
        },

        review: {
          orderBy: {
            createdAt: "desc",
          },
          take: 10,
          select: {
            id: true,
            rating: true,
            createdAt: true,
            user: {
              select: {
                id: true,
                name: true,
                image: true,
              },
            },
          },
        },
      },
    });

    if (!product) {
      return res
        .status(404)
        .json(jsonResponse(false, "No product found", null));
    }

    // Cache for CDN / Vercel
    res.setHeader(
      "Cache-Control",
      "public, s-maxage=60, stale-while-revalidate=30"
    );

    return res.status(200).json(
      jsonResponse(true, "Product found", product)
    );
  } catch (error) {
    console.error("❌ Product Details API Error:", error);

    return res
      .status(500)
      .json(jsonResponse(false, "Internal Server Error", null));
  }
};


//create product attribute
export const createProductAttribute = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const {
        productId,
        size,
        costPrice,
        retailPrice,
        discountPercent,
        stockAmount,
      } = req.body;

      //validate input
      const inputValidation = validateInput(
        [size, costPrice, retailPrice, stockAmount],
        ["Variant", "Cost Price", "Retail Price", "Discount Percent"]
      );

      if (inputValidation) {
        return res.status(400).json(jsonResponse(false, inputValidation, null));
      }

      //create multiple products
      let newProducts = [];
      // let requestBodyLength = req.body.length;

      //loop through request body array to upload multiple products at a time
      // for (let i = 0; i < requestBodyLength; i++) {
      //check if product exists
      const product = await tx.product.findFirst({
        where: {
          id: productId,
          isActive: true,
          isDeleted: false,
        },
      });

      if (!product)
        return res
          .status(409)
          .json(jsonResponse(false, `There is no product.`, null));

      //if there is no image selected
      // if (!req.files || req.files.length === 0) {
      //create products
      let newAttribute = await prisma.productAttribute.create({
        data: {
          productId: product?.id,
          size: size,
          costPrice: Number(costPrice),
          retailPrice: Number(retailPrice),
          discountPercent: Number(discountPercent) ?? 0,
          discountPrice: Number(retailPrice) * (Number(discountPercent) / 100),
          discountedRetailPrice:
            Number(retailPrice) -
            Number(retailPrice) * (Number(discountPercent) / 100),
          stockAmount: Number(stockAmount),
        },
      });

      if (!newAttribute) {
        return res
          .status(200)
          .json(
            jsonResponse(false, `Attribute ${variant} cannot be created`, null)
          );
      }

      // newProducts.push(newProduct);
      // }

      if (newAttribute) {
        return res
          .status(200)
          .json(jsonResponse(true, "Attribute has been created", newAttribute));
      }
      // }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all attributes
export const getProductAttributes = async (req, res) => {
  // if (req.user.roleName !== "super-admin") {
  //   getProductsByUser(req, res);
  // } else {
  try {
    const products = await prisma.productAttribute.findMany({
      where: {
        productId: req.params.id,
        isDeleted: false,
        // isActive: true,
        AND: [
          {
            size: {
              contains: req.query.size,
              mode: "insensitive",
            },
          },
          // {
          //   productCode: {
          //     contains: req.query.product_code,
          //     mode: "insensitive",
          //   },
          // },
          // {
          //   barcode: {
          //     contains: req.query.barcode,
          //     mode: "insensitive",
          //   },
          // },
        ],
      },
      include: {
        product: true,
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

    if (products.length === 0)
      return res
        .status(200)
        .json(jsonResponse(true, "No attribute is available", null));

    if (products) {
      return res
        .status(200)
        .json(
          jsonResponse(true, `${products.length} attributes found`, products)
        );
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "Something went wrong. Try again", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
  // }
};

//delete product attribute
export const deleteProductAttribute = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const product = await tx.productAttribute.delete({
        where: { id: req.params.id },
      });

      if (product) {
        return res
          .status(200)
          .json(
            jsonResponse(true, `Product Attribute has been deleted`, product)
          );
      } else {
        return res
          .status(404)
          .json(
            jsonResponse(false, "Product Attribute has not been deleted", null)
          );
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//get all images
export const getProductImages = async (req, res) => {
  // if (req.user.roleName !== "super-admin") {
  //   getProductsByUser(req, res);
  // } else {
  try {
    const products = await prisma.productImage.findMany({
      where: {
        productId: req.params.id,
        // isDeleted: false,
        // isActive: true,
      },
      include: {
        product: true,
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

    if (products.length === 0)
      return res
        .status(200)
        .json(jsonResponse(true, "No image is available", null));

    if (products) {
      return res
        .status(200)
        .json(jsonResponse(true, `${products.length} images found`, products));
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "Something went wrong. Try again", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
  // }
};

//create an image
export const createProductImage = async (req, res) => {
  try {
    const { productId, image } = req.body;

    // =====================================================
    // VALIDATION
    // =====================================================

    if (!productId) {
      return res
        .status(400)
        .json(jsonResponse(false, "Product Id is required", null));
    }

    // =====================================================
    // CHECK PRODUCT
    // =====================================================

    const product = await prisma.product.findUnique({
      where: {
        id: productId,
      },
      select: {
        id: true,
      },
    });

    if (!product) {
      return res
        .status(404)
        .json(jsonResponse(false, "Product not found", null));
    }

    // =====================================================
    // OPTION 1: EXTERNAL IMAGE URL
    // =====================================================

    if (image && typeof image === "string" && image.trim()) {
      const imageUrl = image.trim();

      console.log("==========================================");
      console.log("PRODUCT IMAGE URL UPLOAD");
      console.log("Product ID:", productId);
      console.log("Image URL:", imageUrl);
      console.log("==========================================");

      // ১. লিংকটি যদি আগে থেকেই Cloudinary-র হয়, তবে সরাসরি সেভ হবে
      if (imageUrl.includes("res.cloudinary.com/")) {
        const productImage = await prisma.productImage.create({
          data: {
            productId,
            image: imageUrl,
          },
        });

        return res
          .status(200)
          .json(
            jsonResponse(
              true,
              "Cloudinary image has been added",
              productImage
            )
          );
      }

      // ২. লিংকটি যদি অন্য যেকোনো সাইটের হয় (যেমন shopaholic.com.bd), 
      // তবে Cloudinary সরাসরি লিংক থেকে ছবি নিয়ে আপলোড করবে
      try {
        const folderName =
          typeof module_name !== "undefined" ? module_name : "products";

        const cloudinaryResult = await cloudinary.uploader.upload(imageUrl, {
          folder: folderName,
        });

        if (!cloudinaryResult?.secure_url) {
          return res
            .status(500)
            .json(
              jsonResponse(
                false,
                "Failed to upload image to Cloudinary",
                null
              )
            );
        }

        // Cloudinary থেকে নতুন তৈরি হওয়া URL ডেটাবেজে সেভ হবে
        const productImage = await prisma.productImage.create({
          data: {
            productId,
            image: cloudinaryResult.secure_url,
          },
        });

        console.log("Product image saved from URL:", productImage.id);

        return res
          .status(200)
          .json(
            jsonResponse(
              true,
              "External image uploaded to Cloudinary successfully",
              productImage
            )
          );
      } catch (uploadError) {
        console.error("External image upload failed:", uploadError);

        return res
          .status(400)
          .json(
            jsonResponse(
              false,
              uploadError?.message ||
                "Failed to process external image URL",
              null
            )
          );
      }
    }

    // =====================================================
    // OPTION 2: NORMAL FILE UPLOAD (যেমন computer/phone থেকে ফাইল সিলেক্ট করলে)
    // =====================================================

    if (!req.file) {
      return res
        .status(400)
        .json(
          jsonResponse(
            false,
            "Image file or image URL is required",
            null
          )
        );
    }

    console.log("Normal file upload started");

    const folderName =
      typeof module_name !== "undefined" ? module_name : "products";

    await uploadToCLoudinary(
      req.file,
      folderName,
      async (error, result) => {
        if (error) {
          console.error("Cloudinary file upload error:", error);

          return res
            .status(500)
            .json(jsonResponse(false, "Image upload failed", null));
        }

        if (!result?.secure_url) {
          return res
            .status(500)
            .json(
              jsonResponse(
                false,
                "Something went wrong while uploading image",
                null
              )
            );
        }

        try {
          // ডেটাবেজে সেভ হবে
          const newProductImage = await prisma.productImage.create({
            data: {
              productId,
              image: result.secure_url,
            },
          });

          console.log("Normal file image saved:", newProductImage.id);

          return res
            .status(200)
            .json(
              jsonResponse(
                true,
                "Product image has been uploaded",
                newProductImage
              )
            );
        } catch (dbError) {
          console.error("Database error:", dbError);

          return res
            .status(500)
            .json(
              jsonResponse(
                false,
                "Image uploaded but database update failed",
                null
              )
            );
        }
      }
    );
  } catch (error) {
    console.error("createProductImage error:", error);

    return res
      .status(500)
      .json(
        jsonResponse(false, error?.message || "Something went wrong", null)
      );
  }
};


export const processVirtualTryOn = async (req, res) => {
  try {
    const { userImageBase64, productImageBase64 } = req.body;

    // ১. ইনপুট ভ্যালিডেশন
    if (!userImageBase64 || !productImageBase64) {
      return res.status(400).json({
        success: false,
        message: "User image and product image are required",
        data: null,
      });
    }

    // ২. অপশনাল ইউজার চেক (যদি লগইন করা থাকে)
    if (req.user) {
      // যদি আপনার ডাটাবেজ চেক প্রয়োজন হয় এখানে রাখতে পারেন
    }

    // ৩. Base64 ইমেজগুলোকে Blob-এ কনভার্ট করা (Gradio client-এর জন্য)
    const userBlob = await (await fetch(userImageBase64)).blob();
    const productBlob = await (await fetch(productImageBase64)).blob();

    // ৪. Hugging Face IDM-VTON Space-এর সাথে কানেক্ট করা
    const app = await Client.connect("yisol/IDM-VTON");

    // ৫. AI প্রেডিকশন রান করা
    const result = await app.predict("/tryon", {
      dict: {
        background: userBlob,
        layers: [],
        composite: null,
      },
      garm_img: productBlob,
      garment_des: "clothing",
      is_checked: true,
      is_checked_crop: false,
      denoise_steps: 40,
      seed: 42,
    });

    const outputImageTempUrl = result?.data?.[0]?.url;
    if (!outputImageTempUrl) {
      throw new Error("Failed to generate virtual try-on image from AI model");
    }

    // ৬. 🔥 মূল সমাধান: Hugging Face-এর temporary URL থেকে ছবি ডাউনলোড করে Base64-এ রূপান্তর করা
    const imageRes = await fetch(outputImageTempUrl);
    if (!imageRes.ok) {
      throw new Error("Failed to fetch generated image from AI space");
    }
    
    const imageBuffer = await imageRes.arrayBuffer();
    const base64Image = `data:image/png;base64,${Buffer.from(imageBuffer).toString("base64")}`;

    // ৭. সফলভাবে ফ্রন্টএন্ডে বেস৬৪ ইমেজ পাঠানো
    return res.status(200).json({
      success: true,
      message: "Virtual try-on generated successfully",
      data: {
        resultImage: base64Image,
      },
    });

  } catch (error) {
    console.error("Virtual Try-On Backend Error:", error);

    return res.status(500).json({
      success: false,
      message: error.message || "Internal Server Error / AI server is busy",
      data: null,
    });
  }
};