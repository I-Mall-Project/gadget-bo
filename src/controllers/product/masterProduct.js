import { defaultLimit, defaultPage } from "../../utils/defaultData.js";
import deleteFromCloudinary from "../../utils/deleteFromCloudinary.js";
import sendEmail from "../../utils/emailService.js";
import jsonResponse from "../../utils/jsonResponse.js";
import prisma from "../../utils/prismaClient.js";
import slugify from "../../utils/slugify.js";
import uploadToCLoudinary from "../../utils/uploadToCloudinary.js";
import validateInput from "../../utils/validateInput.js";
import * as XLSX from "xlsx";

const module_name = "product";

export const getMasterProducts = async (req, res) => {
  try {
    // ===================== PAGINATION =====================

    const page = Math.max(
      Number(req.query.page) || 1,
      1
    );

    const requestedLimit =
      Number(req.query.limit) || 20;

    const limit = Math.min(
      Math.max(requestedLimit, 1),
      100
    );

    const skip =
      (page - 1) * limit;

    // ===================== BASE WHERE =====================

    const where = {
      isDeleted: false,
      isActive: true,
    };

    // ===================== SEARCH =====================

    if (req.query.name) {
      where.name = {
        contains: req.query.name,
        mode: "insensitive",
      };
    }

    // ===================== BRAND =====================

    if (req.query.brandId) {
      where.brandId =
        req.query.brandId;
    }

    // ===================== CATEGORY =====================

    if (req.query.categoryId) {
      where.categoryId =
        req.query.categoryId;
    }

    // ===================== SUBCATEGORY =====================

    if (req.query.subcategoryId) {
      where.subcategoryId =
        req.query.subcategoryId;
    }

    // ===================== NO IMAGE =====================

    if (req.query.noImage === "true") {
      where.OR = [
        {
          imageUrl: null,
        },
        {
          imageUrl: "",
        },
      ];
    }

    // ===================== HAS IMAGE =====================

    if (req.query.hasImage === "true") {
      where.imageUrl = {
        not: null,
      };
    }

    // ===================== DATABASE =====================

    const [products, total] =
      await prisma.$transaction([
        prisma.masterProduct.findMany({
          where,

          orderBy: {
            createdAt: "desc",
          },

          skip,
          take: limit,

          select: {
            id: true,
            name: true,

            priceUsd: true,
            rating: true,
            reviewCount: true,

            productSize: true,
            usageFrequency: true,
            skinType: true,
            genderTarget: true,
            packagingType: true,
            mainIngredient: true,
            crueltyFree: true,
            countryOfOrigin: true,

            imageUrl: true,

            isActive: true,
            isDeleted: true,

            createdAt: true,
            updatedAt: true,

            brandId: true,
            categoryId: true,
            subcategoryId: true,
            subsubcategoryId: true,

            Brand: {
              select: {
                id: true,
                name: true,
                slug: true,
                image: true,
              },
            },

            Category: {
              select: {
                id: true,
                name: true,
                slug: true,
              },
            },

            Subcategory: {
              select: {
                id: true,
                name: true,
                slug: true,
              },
            },

            Subsubcategory: {
              select: {
                id: true,
                name: true,
                slug: true,
              },
            },
          },
        }),

        prisma.masterProduct.count({
          where,
        }),
      ]);

    // ===================== CACHE =====================

    res.setHeader(
      "Cache-Control",
      "public, s-maxage=3600, stale-while-revalidate=86400"
    );

    // ===================== RESPONSE =====================

    return res.status(200).json(
      jsonResponse(
        true,
        "Master products fetched successfully",
        {
          products,

          pagination: {
            total,
            page,
            limit,

            totalPages:
              Math.ceil(
                total / limit
              ),
          },
        }
      )
    );
  } catch (error) {
    console.error(
      "❌ Get Master Products API Error:",
      error
    );

    return res.status(500).json(
      jsonResponse(
        false,
        "Internal Server Error",
        null
      )
    );
  }
};


// ============================================================
// 2. IMPORT MASTER PRODUCTS FROM EXCEL / CSV
// ============================================================

export const importMasterProducts = async (
  req,
  res
) => {
  try {
    // ===================== FILE =====================

    if (!req.file) {
      return res.status(400).json(
        jsonResponse(
          false,
          "Excel or CSV file is required",
          null
        )
      );
    }

    // ===================== READ FILE =====================

    const workbook = XLSX.read(
      req.file.buffer,
      {
        type: "buffer",
      }
    );

    const sheetName =
      workbook.SheetNames[0];

    const worksheet =
      workbook.Sheets[sheetName];

    const rows =
      XLSX.utils.sheet_to_json(
        worksheet,
        {
          defval: null,
          raw: false,
        }
      );

    if (!rows.length) {
      return res.status(400).json(
        jsonResponse(
          false,
          "The uploaded file is empty",
          null
        )
      );
    }

    console.log(
      `📦 Master Product Import Started: ${rows.length} rows`
    );

    // ===================== USER =====================

    const userId =
      req.user.parentId
        ? req.user.parentId
        : req.user.id;

    const user =
      await prisma.user.findFirst({
        where: {
          id: userId,
        },

        select: {
          id: true,
          name: true,
        },
      });

    if (!user) {
      return res.status(404).json(
        jsonResponse(
          false,
          "User does not exist",
          null
        )
      );
    }

    // ===================== COUNTERS =====================

    let created = 0;
    let duplicates = 0;
    let failed = 0;

    const errors = [];

    // ===================== CACHE =====================

    const brandCache =
      new Map();

    const categoryCache =
      new Map();

    // ===================== EXISTING BRANDS =====================

    const existingBrands =
      await prisma.brand.findMany({
        select: {
          id: true,
          name: true,
        },
      });

    for (const brand of existingBrands) {
      brandCache.set(
        brand.name
          .trim()
          .toLowerCase(),
        brand.id
      );
    }

    // ===================== EXISTING CATEGORIES =====================

    const existingCategories =
      await prisma.category.findMany({
        where: {
          userId,
          isDeleted: false,
        },

        select: {
          id: true,
          name: true,
        },
      });

    for (
      const category
      of existingCategories
    ) {
      categoryCache.set(
        category.name
          .trim()
          .toLowerCase(),
        category.id
      );
    }

    // ===================== PROCESS =====================

    for (
      let i = 0;
      i < rows.length;
      i++
    ) {
      const row = rows[i];

      try {
        // ===================== PRODUCT NAME =====================

        const productName =
          String(
            row.Product_Name || ""
          ).trim();

        if (!productName) {
          failed++;

          errors.push({
            row: i + 2,
            error:
              "Product_Name is required",
          });

          continue;
        }

        // ===================== BRAND =====================

        const brandName =
          String(
            row.Brand || ""
          ).trim();

        let brandId = null;

        if (brandName) {
          const brandKey =
            brandName.toLowerCase();

          if (
            brandCache.has(
              brandKey
            )
          ) {
            brandId =
              brandCache.get(
                brandKey
              );
          } else {
            const newBrand =
              await prisma.brand.create({
                data: {
                  name: brandName,

                  slug: slugify(
                    brandName,
                    {
                      lower: true,
                      strict: true,
                    }
                  ),

                  isActive: true,
                },

                select: {
                  id: true,
                },
              });

            brandId =
              newBrand.id;

            brandCache.set(
              brandKey,
              brandId
            );
          }
        }

        // ===================== CATEGORY =====================

        const categoryName =
          String(
            row.Category || ""
          ).trim();

        let categoryId = null;

        if (categoryName) {
          const categoryKey =
            categoryName.toLowerCase();

          if (
            categoryCache.has(
              categoryKey
            )
          ) {
            categoryId =
              categoryCache.get(
                categoryKey
              );
          } else {
            const newCategory =
              await prisma.category.create({
                data: {
                  userId,

                  name: categoryName,

                  slug: slugify(
                    categoryName,
                    {
                      lower: true,
                      strict: true,
                    }
                  ),

                  isActive: true,
                  isDeleted: false,
                },

                select: {
                  id: true,
                },
              });

            categoryId =
              newCategory.id;

            categoryCache.set(
              categoryKey,
              categoryId
            );
          }
        }

        // ===================== PRODUCT SIZE =====================

        const productSize =
          String(
            row.Product_Size || ""
          ).trim();

        // ===================== DUPLICATE =====================

        const existingProduct =
          await prisma.masterProduct.findFirst({
            where: {
              name: productName,
              brandId,
              productSize,
              isDeleted: false,
            },

            select: {
              id: true,
            },
          });

        if (existingProduct) {
          duplicates++;
          continue;
        }

        // ===================== BOOLEAN =====================

        const crueltyFreeValue =
          String(
            row.Cruelty_Free || ""
          )
            .trim()
            .toLowerCase();

        const crueltyFree =
          crueltyFreeValue ===
            "true" ||
          crueltyFreeValue ===
            "yes" ||
          crueltyFreeValue ===
            "1";

        // ===================== NUMBERS =====================

        const priceUsd =
          Number(
            String(
              row.Price_USD || "0"
            ).replace(/,/g, "")
          ) || 0;

        const rating =
          Number(
            String(
              row.Rating || "0"
            ).replace(/,/g, "")
          ) || 0;

        const reviewCount =
          Number(
            String(
              row.Number_of_Reviews ||
                "0"
            ).replace(/,/g, "")
          ) || 0;

        // ===================== CREATE =====================

        await prisma.masterProduct.create({
          data: {
            name:
              productName,

            brandId,

            categoryId,

            subcategoryId:
              null,

            subsubcategoryId:
              null,

            usageFrequency:
              row.Usage_Frequency
                ? String(
                    row.Usage_Frequency
                  ).trim()
                : null,

            priceUsd,

            rating,

            reviewCount,

            productSize,

            skinType:
              row.Skin_Type
                ? String(
                    row.Skin_Type
                  ).trim()
                : null,

            genderTarget:
              row.Gender_Target
                ? String(
                    row.Gender_Target
                  ).trim()
                : null,

            packagingType:
              row.Packaging_Type
                ? String(
                    row.Packaging_Type
                  ).trim()
                : null,

            mainIngredient:
              row.Main_Ingredient
                ? String(
                    row.Main_Ingredient
                  ).trim()
                : null,

            crueltyFree,

            countryOfOrigin:
              row.Country_of_Origin
                ? String(
                    row.Country_of_Origin
                  ).trim()
                : null,

            imageUrl: null,

            isActive: true,
            isDeleted: false,
          },
        });

        created++;
      } catch (rowError) {
        failed++;

        errors.push({
          row: i + 2,

          productName:
            row.Product_Name ||
            null,

          error:
            rowError.message ||
            "Unknown error",
        });
      }
    }

    console.log(
      "✅ Master Import Finished",
      {
        totalRows:
          rows.length,
        created,
        duplicates,
        failed,
      }
    );

    return res.status(200).json(
      jsonResponse(
        true,
        "Master products imported successfully",
        {
          totalRows:
            rows.length,

          created,

          duplicates,

          failed,

          errors:
            errors.length
              ? errors.slice(
                  0,
                  100
                )
              : [],
        }
      )
    );
  } catch (error) {
    console.error(
      "❌ Import Master Products Error:",
      error
    );

    return res.status(500).json(
      jsonResponse(
        false,
        error.message ||
          "Internal Server Error",
        null
      )
    );
  }
};

export const getProductsWithoutImage = async (req, res) => {
  try {
    const page = Math.max(Number(req.query.page) || 1, 1);
    const limit = Math.min(Number(req.query.limit) || 20, 100);

    const skip = (page - 1) * limit;

    // শুধু যেসব product-এর কোনো image নেই
    const where = {
      isDeleted: false,
      isActive: true,

      images: {
        none: {},
      },
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
          brandId: true,
          categoryId: true,
          subcategoryId: true,
          subsubcategoryId: true,
          masterProductId: true,

          brand: {
            select: {
              id: true,
              name: true,
            },
          },

          category: {
            select: {
              id: true,
              name: true,
            },
          },

          subcategory: {
            select: {
              id: true,
              name: true,
            },
          },

          subsubcategory: {
            select: {
              id: true,
              name: true,
            },
          },

          MasterProduct: {
            select: {
              id: true,
              name: true,
              imageUrl: true,
            },
          },

          images: {
            take: 1,
            select: {
              id: true,
              imageUrl: true,
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
      message: "Products without image fetched successfully",

      data: products,

      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
        hasNextPage: page * limit < total,
        hasPreviousPage: page > 1,
      },
    });
  } catch (error) {
    console.error(
      "❌ Get Products Without Image Error:",
      error
    );

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
// ============================================================
// 3. UPDATE MASTER PRODUCT IMAGE
// ============================================================

export const updateMasterProductImage =
  async (req, res) => {
    try {
      const { id } =
        req.params;

      const { imageUrl } =
        req.body;

      // ===================== VALIDATION =====================

      if (
        !imageUrl ||
        !imageUrl.trim()
      ) {
        return res.status(400).json(
          jsonResponse(
            false,
            "Image URL is required",
            null
          )
        );
      }

      // ===================== FIND PRODUCT =====================

      const product =
        await prisma.masterProduct.findFirst({
          where: {
            id,

            isDeleted: false,
          },

          select: {
            id: true,
            name: true,
            imageUrl: true,
          },
        });

      if (!product) {
        return res.status(404).json(
          jsonResponse(
            false,
            "Master product not found",
            null
          )
        );
      }

      // ===================== UPDATE =====================

      const updatedProduct =
        await prisma.masterProduct.update({
          where: {
            id,
          },

          data: {
            imageUrl:
              imageUrl.trim(),
          },

          select: {
            id: true,
            name: true,
            imageUrl: true,
          },
        });

      return res.status(200).json(
        jsonResponse(
          true,
          "Product image updated successfully",
          updatedProduct
        )
      );
    } catch (error) {
      console.error(
        "❌ Update Master Product Image Error:",
        error
      );

      return res.status(500).json(
        jsonResponse(
          false,
          "Internal Server Error",
          null
        )
      );
    }
  };


// ============================================================
// 4. ADD MASTER PRODUCT TO BRANCH PRODUCT
// ============================================================

export const addMasterProductToProduct =
  async (req, res) => {
    try {
      const {
        id: masterProductId,
      } = req.params;

      const {
        branchId,

        size,

        costPrice,

        retailPrice,

        stockAmount,

        discountPercent,

        categoryId,

        subcategoryId,

        subsubcategoryId,

        sku,

        barcode,

        isTrending,

        isFeatured,
      } = req.body;

      // ======================================================
      // DETERMINE OWNER
      // ======================================================

      const ownerId =
        req.user.parentId
          ? req.user.parentId
          : req.user.id;

      // ======================================================
      // DETERMINE BRANCH
      // ======================================================

      let selectedBranchId =
        null;

      // ------------------------------------------------------
      // Logged-in user is branch
      // ------------------------------------------------------

      if (req.user.parentId) {
        selectedBranchId =
          req.user.id;
      }

      // ------------------------------------------------------
      // Logged-in user is owner
      // ------------------------------------------------------

      else {
        if (branchId) {
          const branch =
            await prisma.user.findFirst({
              where: {
                id: branchId,

                parentId:
                  ownerId,

                isDeleted: false,

                isActive: true,
              },

              select: {
                id: true,
                name: true,
              },
            });

          if (!branch) {
            return res.status(400).json(
              jsonResponse(
                false,
                "Selected branch does not belong to this owner",
                null
              )
            );
          }

          selectedBranchId =
            branch.id;
        } else {
          const branches =
            await prisma.user.findMany({
              where: {
                parentId:
                  ownerId,

                isDeleted: false,

                isActive: true,
              },

              select: {
                id: true,
                name: true,
              },
            });

          if (!branches.length) {
            return res.status(400).json(
              jsonResponse(
                false,
                "No branch found for this owner",
                null
              )
            );
          }

          if (
            branches.length > 1
          ) {
            return res.status(400).json(
              jsonResponse(
                false,
                "Please select a branch",
                {
                  branches,
                }
              )
            );
          }

          selectedBranchId =
            branches[0].id;
        }
      }

      // ======================================================
      // GET MASTER PRODUCT
      // ======================================================

      const masterProduct =
        await prisma.masterProduct.findFirst({
          where: {
            id:
              masterProductId,

            isDeleted: false,

            isActive: true,
          },
        });

      if (!masterProduct) {
        return res.status(404).json(
          jsonResponse(
            false,
            "Master product not found",
            null
          )
        );
      }

      // ======================================================
      // CATEGORY
      // ======================================================

      const finalCategoryId =
        categoryId ||
        masterProduct.categoryId;

      if (!finalCategoryId) {
        return res.status(400).json(
          jsonResponse(
            false,
            "Category is required",
            null
          )
        );
      }

      const category =
        await prisma.category.findFirst({
          where: {
            id:
              finalCategoryId,

            isDeleted: false,

            isActive: true,
          },

          select: {
            id: true,
            discount: true,
          },
        });

      if (!category) {
        return res.status(400).json(
          jsonResponse(
            false,
            "Category not found",
            null
          )
        );
      }

      // ======================================================
      // DUPLICATE PRODUCT IN BRANCH
      // ======================================================

      const existingProduct =
        await prisma.product.findFirst({
          where: {
            userId:
              selectedBranchId,

            name:
              masterProduct.name,

            isDeleted: false,
          },

          select: {
            id: true,
            name: true,
          },
        });

      if (existingProduct) {
        return res.status(409).json(
          jsonResponse(
            false,
            "This product already exists in this branch",
            existingProduct
          )
        );
      }

      // ======================================================
      // PRICE
      // ======================================================

      const finalRetailPrice =
        Number(retailPrice);

      if (
        !Number.isFinite(
          finalRetailPrice
        ) ||
        finalRetailPrice <= 0
      ) {
        return res.status(400).json(
          jsonResponse(
            false,
            "Valid retailPrice is required",
            null
          )
        );
      }

      const finalCostPrice =
        Number(costPrice) || 0;

      const finalStockAmount =
        Number(stockAmount) || 0;

      // ======================================================
      // DISCOUNT
      // ======================================================

      const categoryDiscount =
        Number(
          category.discount
        ) || 0;

      const finalDiscountPercent =
        categoryDiscount > 0
          ? categoryDiscount
          : Number(
              discountPercent
            ) || 0;

      const discountPrice =
        (
          finalRetailPrice *
          finalDiscountPercent
        ) / 100;

      const discountedRetailPrice =
        finalRetailPrice -
        discountPrice;

      // ======================================================
      // IMAGE
      // ======================================================

      let cloudinaryImageUrl =
        null;

      if (
        masterProduct.imageUrl &&
        masterProduct.imageUrl.trim()
      ) {
        const imageUrl =
          masterProduct.imageUrl.trim();

        // ----------------------------------------------------
        // Already Cloudinary
        // ----------------------------------------------------

        if (
          imageUrl.includes(
            "res.cloudinary.com"
          )
        ) {
          cloudinaryImageUrl =
            imageUrl;
        }

        // ----------------------------------------------------
        // External URL → Cloudinary
        // ----------------------------------------------------

        else {
          try {
            const uploadResult =
              await cloudinary.uploader.upload(
                imageUrl,
                {
                  folder:
                    "product",

                  resource_type:
                    "image",
                }
              );

            cloudinaryImageUrl =
              uploadResult.secure_url;

            // IMPORTANT:
            // Also update MasterProduct
            // with Cloudinary URL

            await prisma.masterProduct.update({
              where: {
                id:
                  masterProduct.id,
              },

              data: {
                imageUrl:
                  cloudinaryImageUrl,
              },
            });
          } catch (imageError) {
            console.error(
              "❌ Cloudinary Upload Error:",
              imageError
            );

            return res.status(400).json(
              jsonResponse(
                false,
                "Unable to upload master product image to Cloudinary",
                null
              )
            );
          }
        }
      }

      // ======================================================
      // BRANCH USER
      // ======================================================

      const branchUser =
        await prisma.user.findFirst({
          where: {
            id:
              selectedBranchId,

            isDeleted: false,

            isActive: true,
          },

          select: {
            id: true,
            name: true,
          },
        });

      if (!branchUser) {
        return res.status(404).json(
          jsonResponse(
            false,
            "Branch not found",
            null
          )
        );
      }

      // ======================================================
      // TRANSACTION
      // ======================================================

      const newProduct =
        await prisma.$transaction(
          async (tx) => {

            // ----------------------------------------------
            // SLUG
            // ----------------------------------------------

            const baseSlug =
              `${slugify(
                branchUser.name
              )}-${slugify(
                masterProduct.name
              )}`;

            let slug =
              baseSlug;

            const slugExists =
              await tx.product.findFirst({
                where: {
                  slug,
                },

                select: {
                  id: true,
                },
              });

            if (slugExists) {
              slug =
                `${baseSlug}-${Date.now()}`;
            }

            // ----------------------------------------------
            // PRODUCT
            // ----------------------------------------------

            const product =
              await tx.product.create({
                data: {

                  // Branch
                  userId:
                    selectedBranchId,

                  // Master data
                  brandId:
                    masterProduct.brandId ||
                    null,

                  categoryId:
                    finalCategoryId,

                  subcategoryId:
                    subcategoryId ||
                    masterProduct.subcategoryId ||
                    null,

                  subsubcategoryId:
                    subsubcategoryId ||
                    masterProduct.subsubcategoryId ||
                    null,

                  name:
                    masterProduct.name,

                  shortDescription:
                    [
                      masterProduct.skinType
                        ? `Skin Type: ${masterProduct.skinType}`
                        : null,

                      masterProduct.mainIngredient
                        ? `Main Ingredient: ${masterProduct.mainIngredient}`
                        : null,

                      masterProduct.countryOfOrigin
                        ? `Country: ${masterProduct.countryOfOrigin}`
                        : null,
                    ]
                      .filter(Boolean)
                      .join(" • ") ||
                    null,

                  longDescription:
                    null,

                  productCode:
                    `MP-${masterProduct.id.slice(
                      0,
                      8
                    )}`,

                  barcode:
                    barcode || null,

                  sku:
                    sku || null,

                  isTrending:
                    isTrending ===
                      true ||
                    isTrending ===
                      "true",

                  isFeatured:
                    isFeatured ===
                      true ||
                    isFeatured ===
                      "true",

                  isActive:
                    true,

                  isDeleted:
                    false,

                  createdBy:
                    req.user.id,

                  slug,

                  // ------------------------------------------
                  // ATTRIBUTE
                  // ------------------------------------------

                  productAttributes: {
                    create: {
                      size:
                        size ||
                        masterProduct.productSize ||
                        "Default",

                      costPrice:
                        finalCostPrice,

                      retailPrice:
                        finalRetailPrice,

                      stockAmount:
                        finalStockAmount,

                      discountPercent:
                        finalDiscountPercent,

                      discountPrice,

                      discountedRetailPrice,

                      isDeleted:
                        false,

                      createdBy:
                        req.user.id,
                    },
                  },

                  // ------------------------------------------
                  // IMAGE
                  // ------------------------------------------

                  images:
                    cloudinaryImageUrl
                      ? {
                          create: {
                            image:
                              cloudinaryImageUrl,

                            createdBy:
                              req.user.id,
                          },
                        }
                      : undefined,
                },

                select: {
                  id: true,
                  name: true,
                  slug: true,
                  userId: true,
                  brandId: true,
                  categoryId: true,

                  productAttributes: {
                    select: {
                      id: true,
                      size: true,
                      costPrice: true,
                      retailPrice: true,
                      stockAmount: true,
                      discountPercent: true,
                      discountPrice: true,
                      discountedRetailPrice: true,
                    },
                  },

                  images: {
                    select: {
                      id: true,
                      image: true,
                    },
                  },
                },
              });

            return product;
          }
        );

      // ======================================================
      // RESPONSE
      // ======================================================

      return res.status(201).json(
        jsonResponse(
          true,
          "Master product added successfully",
          {
            product:
              newProduct,

            branchId:
              selectedBranchId,

            masterProductId:
              masterProduct.id,

            imageUploaded:
              Boolean(
                cloudinaryImageUrl
              ),
          }
        )
      );
    } catch (error) {
      console.error(
        "❌ Add Master Product Error:",
        error
      );

      return res.status(500).json(
        jsonResponse(
          false,
          error.message ||
            "Internal Server Error",
          null
        )
      );
    }
  };

  export const addMasterProductsToProductBulk = async (req, res) => {
  try {
    const { products, branchId } = req.body;

    // ======================================================
    // VALIDATE PRODUCTS
    // ======================================================

    if (!Array.isArray(products) || products.length === 0) {
      return res.status(400).json(
        jsonResponse(
          false,
          "At least one product is required",
          null
        )
      );
    }

    // ======================================================
    // DETERMINE OWNER
    // ======================================================

    const ownerId = req.user.parentId
      ? req.user.parentId
      : req.user.id;

    // ======================================================
    // DETERMINE BRANCH
    // ======================================================

    let selectedBranchId = null;

    // Logged-in user is branch
    if (req.user.parentId) {
      selectedBranchId = req.user.id;
    }

    // Logged-in user is owner
    else {
      if (branchId) {
        const branch = await prisma.user.findFirst({
          where: {
            id: branchId,
            parentId: ownerId,
            isDeleted: false,
            isActive: true,
          },

          select: {
            id: true,
            name: true,
          },
        });

        if (!branch) {
          return res.status(400).json(
            jsonResponse(
              false,
              "Selected branch does not belong to this owner",
              null
            )
          );
        }

        selectedBranchId = branch.id;
      } else {
        const branches = await prisma.user.findMany({
          where: {
            parentId: ownerId,
            isDeleted: false,
            isActive: true,
          },

          select: {
            id: true,
            name: true,
          },
        });

        if (!branches.length) {
          return res.status(400).json(
            jsonResponse(
              false,
              "No branch found for this owner",
              null
            )
          );
        }

        if (branches.length > 1) {
          return res.status(400).json(
            jsonResponse(
              false,
              "Please select a branch",
              {
                branches,
              }
            )
          );
        }

        selectedBranchId = branches[0].id;
      }
    }

    // ======================================================
    // BRANCH USER
    // ======================================================

    const branchUser = await prisma.user.findFirst({
      where: {
        id: selectedBranchId,
        isDeleted: false,
        isActive: true,
      },

      select: {
        id: true,
        name: true,
      },
    });

    if (!branchUser) {
      return res.status(404).json(
        jsonResponse(
          false,
          "Branch not found",
          null
        )
      );
    }

    // ======================================================
    // MASTER PRODUCT IDS
    // ======================================================

    const masterProductIds = [
      ...new Set(
        products
          .map((item) => item.masterProductId)
          .filter(Boolean)
      ),
    ];

    if (!masterProductIds.length) {
      return res.status(400).json(
        jsonResponse(
          false,
          "No valid master products found",
          null
        )
      );
    }

    // ======================================================
    // GET MASTER PRODUCTS
    // ======================================================

    const masterProducts =
      await prisma.masterProduct.findMany({
        where: {
          id: {
            in: masterProductIds,
          },

          isDeleted: false,
          isActive: true,
        },
      });

    const masterProductMap = new Map(
      masterProducts.map((product) => [
        product.id,
        product,
      ])
    );

    // ======================================================
    // CHECK EXISTING PRODUCTS
    // ======================================================

    const existingProducts =
      await prisma.product.findMany({
        where: {
          userId: selectedBranchId,
          isDeleted: false,

          name: {
            in: masterProducts.map(
              (product) => product.name
            ),
          },
        },

        select: {
          id: true,
          name: true,
        },
      });

    const existingProductNames = new Set(
      existingProducts.map(
        (product) => product.name
      )
    );

    // ======================================================
    // PREPARE RESULTS
    // ======================================================

    const createdProducts = [];
    const alreadyAdded = [];
    const failed = [];

    // ======================================================
    // IMAGE CACHE
    // ======================================================

    const imageCache = new Map();

    // ======================================================
    // PROCESS PRODUCTS
    // ======================================================

    for (const item of products) {
      try {
        const {
          masterProductId,
          size,
          costPrice,
          retailPrice,
          stockAmount,
          discountPercent,
          categoryId,
          subcategoryId,
          subsubcategoryId,
          sku,
          barcode,
          isTrending,
          isFeatured,
        } = item;

        // --------------------------------------------------
        // MASTER PRODUCT
        // --------------------------------------------------

        const masterProduct =
          masterProductMap.get(
            masterProductId
          );

        if (!masterProduct) {
          failed.push({
            masterProductId,
            reason:
              "Master product not found",
          });

          continue;
        }

        // --------------------------------------------------
        // DUPLICATE
        // --------------------------------------------------

        if (
          existingProductNames.has(
            masterProduct.name
          )
        ) {
          alreadyAdded.push({
            masterProductId:
              masterProduct.id,

            name:
              masterProduct.name,
          });

          continue;
        }

        // --------------------------------------------------
        // CATEGORY
        // --------------------------------------------------

        const finalCategoryId =
          categoryId ||
          masterProduct.categoryId;

        if (!finalCategoryId) {
          failed.push({
            masterProductId:
              masterProduct.id,

            name:
              masterProduct.name,

            reason:
              "Category is required",
          });

          continue;
        }

        const category =
          await prisma.category.findFirst({
            where: {
              id: finalCategoryId,

              isDeleted: false,

              isActive: true,
            },

            select: {
              id: true,
              discount: true,
            },
          });

        if (!category) {
          failed.push({
            masterProductId:
              masterProduct.id,

            name:
              masterProduct.name,

            reason:
              "Category not found",
          });

          continue;
        }

        // --------------------------------------------------
        // PRICE
        // --------------------------------------------------

        const finalRetailPrice =
          Number(retailPrice);

        if (
          !Number.isFinite(
            finalRetailPrice
          ) ||
          finalRetailPrice <= 0
        ) {
          failed.push({
            masterProductId:
              masterProduct.id,

            name:
              masterProduct.name,

            reason:
              "Valid retailPrice is required",
          });

          continue;
        }

        const finalCostPrice =
          Number(costPrice) || 0;

        const finalStockAmount =
          Number(stockAmount) || 0;

        // --------------------------------------------------
        // DISCOUNT
        // --------------------------------------------------

        const categoryDiscount =
          Number(
            category.discount
          ) || 0;

        const finalDiscountPercent =
          categoryDiscount > 0
            ? categoryDiscount
            : Number(
                discountPercent
              ) || 0;

        const discountPrice =
          (
            finalRetailPrice *
            finalDiscountPercent
          ) / 100;

        const discountedRetailPrice =
          finalRetailPrice -
          discountPrice;

        // --------------------------------------------------
        // IMAGE
        // --------------------------------------------------

        let cloudinaryImageUrl = null;

        if (
          masterProduct.imageUrl &&
          masterProduct.imageUrl.trim()
        ) {
          const imageUrl =
            masterProduct.imageUrl.trim();

          // Already Cloudinary
          if (
            imageUrl.includes(
              "res.cloudinary.com"
            )
          ) {
            cloudinaryImageUrl =
              imageUrl;
          }

          // External URL
          else if (
            imageCache.has(imageUrl)
          ) {
            cloudinaryImageUrl =
              imageCache.get(imageUrl);
          }

          else {
            try {
              const uploadResult =
                await cloudinary.uploader.upload(
                  imageUrl,
                  {
                    folder:
                      "product",
                    resource_type:
                      "image",
                  }
                );

              cloudinaryImageUrl =
                uploadResult.secure_url;

              imageCache.set(
                imageUrl,
                cloudinaryImageUrl
              );

              // Update MasterProduct
              await prisma.masterProduct.update({
                where: {
                  id:
                    masterProduct.id,
                },

                data: {
                  imageUrl:
                    cloudinaryImageUrl,
                },
              });
            } catch (imageError) {
              console.error(
                "Cloudinary upload failed:",
                imageError
              );

              // Don't fail entire bulk
              failed.push({
                masterProductId:
                  masterProduct.id,

                name:
                  masterProduct.name,

                reason:
                  "Unable to upload image to Cloudinary",
              });

              continue;
            }
          }
        }

        // --------------------------------------------------
        // CREATE PRODUCT
        // --------------------------------------------------

        const newProduct =
          await prisma.$transaction(
            async (tx) => {
              const baseSlug =
                `${slugify(
                  branchUser.name
                )}-${slugify(
                  masterProduct.name
                )}`;

              let slug = baseSlug;

              const slugExists =
                await tx.product.findFirst({
                  where: {
                    slug,
                  },

                  select: {
                    id: true,
                  },
                });

              if (slugExists) {
                slug =
                  `${baseSlug}-${Date.now()}-${Math.floor(
                    Math.random() * 1000
                  )}`;
              }

              const product =
                await tx.product.create({
                  data: {
                    userId:
                      selectedBranchId,

                    brandId:
                      masterProduct.brandId ||
                      null,

                    categoryId:
                      finalCategoryId,

                    subcategoryId:
                      subcategoryId ||
                      masterProduct.subcategoryId ||
                      null,

                    subsubcategoryId:
                      subsubcategoryId ||
                      masterProduct.subsubcategoryId ||
                      null,

                    name:
                      masterProduct.name,

                    shortDescription:
                      [
                        masterProduct.skinType
                          ? `Skin Type: ${masterProduct.skinType}`
                          : null,

                        masterProduct.mainIngredient
                          ? `Main Ingredient: ${masterProduct.mainIngredient}`
                          : null,

                        masterProduct.countryOfOrigin
                          ? `Country: ${masterProduct.countryOfOrigin}`
                          : null,
                      ]
                        .filter(Boolean)
                        .join(" • ") ||
                      null,

                    longDescription:
                      null,

                    productCode:
                      `MP-${masterProduct.id.slice(
                        0,
                        8
                      )}`,

                    barcode:
                      barcode || null,

                    sku:
                      sku || null,

                    isTrending:
                      isTrending === true ||
                      isTrending === "true",

                    isFeatured:
                      isFeatured === true ||
                      isFeatured === "true",

                    isActive:
                      true,

                    isDeleted:
                      false,

                    createdBy:
                      req.user.id,

                    slug,

                    productAttributes: {
                      create: {
                        size:
                          size ||
                          masterProduct.productSize ||
                          "Default",

                        costPrice:
                          finalCostPrice,

                        retailPrice:
                          finalRetailPrice,

                        stockAmount:
                          finalStockAmount,

                        discountPercent:
                          finalDiscountPercent,

                        discountPrice,

                        discountedRetailPrice,

                        isDeleted:
                          false,

                        createdBy:
                          req.user.id,
                      },
                    },

                    images:
                      cloudinaryImageUrl
                        ? {
                            create: {
                              image:
                                cloudinaryImageUrl,

                              createdBy:
                                req.user.id,
                            },
                          }
                        : undefined,
                  },

                  select: {
                    id: true,
                    name: true,
                    slug: true,
                    userId: true,
                    brandId: true,
                    categoryId: true,
                  },
                });

              return product;
            }
          );

        // Add to duplicate cache
        existingProductNames.add(
          masterProduct.name
        );

        createdProducts.push({
          masterProductId:
            masterProduct.id,

          productId:
            newProduct.id,

          name:
            masterProduct.name,
        });
      } catch (productError) {
        console.error(
          "Bulk product error:",
          productError
        );

        failed.push({
          masterProductId:
            item.masterProductId,

          reason:
            productError.message ||
            "Failed to create product",
        });
      }
    }

    // ======================================================
    // RESPONSE
    // ======================================================

    return res.status(201).json(
      jsonResponse(
        true,
        "Master products processed successfully",
        {
          branchId:
            selectedBranchId,

          total:
            masterProductIds.length,

          created:
            createdProducts.length,

          alreadyAdded:
            alreadyAdded.length,

          failed:
            failed.length,

          createdProducts,

          alreadyAdded,

          errors:
            failed,
        }
      )
    );
  } catch (error) {
    console.error(
      "❌ Bulk Add Master Products Error:",
      error
    );

    return res.status(500).json(
      jsonResponse(
        false,
        error.message ||
          "Internal Server Error",
        null
      )
    );
  }
};