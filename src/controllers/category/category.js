import { defaultLimit, defaultPage } from "../../utils/defaultData.js";
import deleteFromCloudinary from "../../utils/deleteFromCloudinary.js";
import jsonResponse from "../../utils/jsonResponse.js";
import prisma from "../../utils/prismaClient.js";
import slugify from "../../utils/slugify.js";
import uploadToCLoudinary from "../../utils/uploadToCloudinary.js";
import validateInput from "../../utils/validateInput.js";
// import uploadImage from "../../utils/uploadImage.js";

const module_name = "category";

// export const createCategory = async (req, res) => {
//   try {
//     return await prisma.$transaction(async (tx) => {
//       const { name } = req.body;

//       //validate input
//       const inputValidation = validateInput([name], ["Name"]);

//       if (inputValidation) {
//         return res.status(400).json(jsonResponse(false, inputValidation, null));
//       }

//       //get user name for slugify
//       const user = await tx.user.findFirst({
//         where: { id: req.user.parentId ? req.user.parentId : req.user.id },
//       });

//       if (!user)
//         return res
//           .status(404)
//           .json(jsonResponse(false, "This user does not exist", null));

//       //check if category exists
//       const category = await tx.category.findFirst({
//         where: {
//           userId: req.user.parentId ? req.user.parentId : req.user.id,
//           name: name,
//           isDeleted: false,
//         },
//       });

//       if (
//         category &&
//         category.slug === `${slugify(user.name)}-${slugify(name)}`
//       )
//         return res
//           .status(409)
//           .json(
//             jsonResponse(
//               false,
//               `${name} already exists. Change its name.`,
//               null
//             )
//           );

//       //if there is no image selected
//       if (!req.file) {
//         //create category
//         const newCategory = await prisma.category.create({
//           data: {
//             userId: req.user.parentId ? req.user.parentId : req.user.id,
//             name,
//             createdBy: req.user.id,
//             slug: `${slugify(user.name)}-${slugify(name)}`,
//           },
//         });

//         if (newCategory) {
//           return res
//             .status(200)
//             .json(jsonResponse(true, "Category has been created", newCategory));
//         }
//       }

//       //upload image
//       // const imageUpload = await uploadImage(req.file);
//       await uploadToCLoudinary(req.file, module_name, async (error, result) => {
//         if (error) {
//           console.error("error", error);
//           return res.status(404).json(jsonResponse(false, error, null));
//         }

//         if (!result.secure_url) {
//           return res
//             .status(404)
//             .json(
//               jsonResponse(
//                 false,
//                 "Something went wrong while uploading image. Try again",
//                 null
//               )
//             );
//         }

//         //create category
//         const newCategory = await prisma.category.create({
//           data: {
//             userId: req.user.parentId ? req.user.parentId : req.user.id,
//             name,
//             image: result.secure_url,
//             createdBy: req.user.id,
//             slug: `${slugify(user.name)}-${slugify(name)}`,
//           },
//         });

//         if (newCategory) {
//           return res
//             .status(200)
//             .json(jsonResponse(true, "Category has been created", newCategory));
//         }
//       });
//     });
//   } catch (error) {
//     console.log(error);
//     return res.status(500).json(jsonResponse(false, error, null));
//   }
// };


//create category
export const createCategory = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const { name, discount } = req.body; // new field

      // validate input
      const inputValidation = validateInput([name], ["Name"]);
      if (inputValidation) {
        return res.status(400).json(jsonResponse(false, inputValidation, null));
      }

      // get user
      const user = await tx.user.findFirst({
        where: { id: req.user.parentId ? req.user.parentId : req.user.id },
      });

      if (!user) {
        return res
          .status(404)
          .json(jsonResponse(false, "This user does not exist", null));
      }

      // check if category exists
      const category = await tx.category.findFirst({
        where: {
          userId: req.user.parentId ? req.user.parentId : req.user.id,
          name: name,
          isDeleted: false,
        },
      });

      if (
        category &&
        category.slug === `${slugify(user.name)}-${slugify(name)}`
      ) {
        return res
          .status(409)
          .json(jsonResponse(false, `${name} already exists.`, null));
      }

      // create category
      const newCategory = await tx.category.create({
        data: {
          userId: req.user.parentId ? req.user.parentId : req.user.id,
          name,
          discount: discount ? Number(discount) : 0, // save discount
          createdBy: req.user.id,
          slug: `${slugify(user.name)}-${slugify(name)}`,
        },
      });

      // if discount provided -> update all products under this category
      if (newCategory.discount > 0) {
        const products = await tx.product.findMany({
          where: { categoryId: newCategory.id },
        });

        for (let product of products) {
          const discountedPrice =
            product.price - (product.price * newCategory.discount) / 100;

          await tx.product.update({
            where: { id: product.id },
            data: { discountedPrice },
          });
        }
      }

      return res
        .status(200)
        .json(jsonResponse(true, "Category has been created", newCategory));
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error.message, null));
  }
};


//get all categories
export const getCategories = async (req, res) => {
  if (req.user.roleName !== "super-admin") {
    getCategoriesByUser(req, res);
  } else {
    try {
      const categories = await prisma.category.findMany({
        where: {
          isDeleted: false,
          AND: [
            {
              name: {
                contains: req.query.name,
                mode: "insensitive",
              },
            },
          ],
        },
        include: { user: true },
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

      if (categories.length === 0)
        return res
          .status(200)
          .json(jsonResponse(true, "No category is available", null));

      if (categories) {
        return res
          .status(200)
          .json(
            jsonResponse(
              true,
              `${categories.length} categories found`,
              categories
            )
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

//get all categories by user
export const getCategoriesByUser = async (req, res) => {
  try {
    const categories = await prisma.category.findMany({
      where: {
        userId: req.user.parentId ? req.user.parentId : req.user.id,
        isDeleted: false,
        AND: [
          {
            name: {
              contains: req.query.name,
              mode: "insensitive",
            },
          },
        ],
      },
      include: { user: true },
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

    if (categories.length === 0)
      return res
        .status(200)
        .json(jsonResponse(true, "No category is available", null));

    if (categories) {
      return res
        .status(200)
        .json(
          jsonResponse(
            true,
            `${categories.length} categories found`,
            categories
          )
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
};

//get single category
export const getCategory = async (req, res) => {
  try {
    const category = await prisma.category.findFirst({
      where: { slug: req.params.slug, isDeleted: false },
    });

    if (category) {
      return res
        .status(200)
        .json(jsonResponse(true, `1 category found`, category));
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "No category is available", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};




// Update category
export const updateCategory = async (req, res) => {
  try {
    const { name, discount } = req.body;

    // Validate input
    const inputValidation = validateInput([name], ["Name"]);
    if (inputValidation) return res.status(400).json(jsonResponse(false, inputValidation, null));

    // Find category and user
    const findCategory = await prisma.category.findUnique({ where: { id: req.params.id } });
    if (!findCategory) return res.status(404).json(jsonResponse(false, "Category not found", null));

    const user = await prisma.user.findUnique({ where: { id: findCategory.userId } });
    if (!user) return res.status(404).json(jsonResponse(false, "User not found", null));

    // Check name conflict
    if (name && name !== findCategory.name) {
      const existingCategory = await prisma.category.findFirst({
        where: { userId: req.user.parentId ?? req.user.id, name, isDeleted: false }
      });
      if (existingCategory) return res.status(409).json(jsonResponse(false, `${name} already exists`, null));
    }

    // Upload image if provided
    let imageUrl = findCategory.image;
    if (req.file) {
      const result = await new Promise((resolve, reject) => {
        uploadToCLoudinary(req.file, "category", (err, result) => {
          if (err) reject(err);
          else resolve(result);
        });
      });
      imageUrl = result.secure_url;
      if (findCategory.image) await deleteFromCloudinary(findCategory.image, () => {});
    }

    // Update category only in a transaction
    const updatedCategory = await prisma.$transaction(async (tx) => {
      return tx.category.update({
        where: { id: req.params.id },
        data: {
          name,
          discount: discount ? Number(discount) : 0,
          updatedBy: req.user.id,
          image: imageUrl,
          slug: name ? `${slugify(user.name)}-${slugify(name)}` : findCategory.slug,
        },
      });
    });

    // **Update all product attributes outside the transaction**
    if (updatedCategory.discount !== undefined) {
      const products = await prisma.product.findMany({
        where: { categoryId: updatedCategory.id },
        include: { productAttributes: true },
      });

      for (let product of products) {
        const updates = product.productAttributes.map(attr => {
          const retailPrice = Number(attr.retailPrice);
          const discountPercent = updatedCategory.discount;
          const discountPrice = (retailPrice * discountPercent) / 100;
          const discountedRetailPrice = retailPrice - discountPrice;

          return prisma.productAttribute.update({
            where: { id: attr.id },
            data: { discountPercent, discountPrice, discountedRetailPrice },
          });
        });

        // Execute updates in parallel
        await Promise.all(updates);
      }
    }

    return res.status(200).json(jsonResponse(true, "Category has been updated", updatedCategory));
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error.message, null));
  }
};



//ban category
export const banCategory = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      //ban category
      const getCategory = await tx.category.findFirst({
        where: { id: req.params.id },
      });

      const category = await tx.category.update({
        where: { id: req.params.id },
        data: {
          isActive: getCategory.isActive === true ? false : true,
        },
      });

      if (category) {
        return res
          .status(200)
          .json(jsonResponse(true, `Category has been banned`, category));
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Category has not been banned", null));
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};

//delete category
export const deleteCategory = async (req, res) => {
  try {
    return await prisma.$transaction(async (tx) => {
      const category = await tx.category.update({
        where: { id: req.params.id },
        data: { deletedBy: req.user.id, isDeleted: true },
      });

      if (category) {
        // fs.unlinkSync(
        //   `public\\images\\${module_name}\\${category.image.split("/")[2]}`
        // );
        await deleteFromCloudinary(category.image, async (error, result) => {
          console.log("error", error);
          console.log("result", result);
        });

        return res
          .status(200)
          .json(jsonResponse(true, `Category has been deleted`, category));
      } else {
        return res
          .status(404)
          .json(jsonResponse(false, "Category has not been deleted", null));
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};





// get all categories for customer
export const getCategoriesForCustomer = async (req, res) => {
  try {
    const { name = "", limit, page } = req.query;

    const categories = await prisma.category.findMany({
      where: {
        isDeleted: false,
        isActive: true,
        name: {
          contains: name,
          mode: "insensitive",
        },
      },
      select: {
        user: { select: { name: true, image: true } },
        id: true,
        name: true,
        image: true,
        slug: true,
        discount: true, // added discount
        createdAt: true,
        subcategory: true,
        subsubcategory: true,
      },
      orderBy: {
        createdAt: "desc",
      },
      skip: limit && page ? parseInt(limit) * (parseInt(page) - 1) : parseInt(defaultLimit()) * (parseInt(defaultPage()) - 1),
      take: limit ? parseInt(limit) : parseInt(defaultLimit()),
    });

    if (!categories || categories.length === 0) {
      return res
        .status(200)
        .json(jsonResponse(true, "No category is available", []));
    }

    return res
      .status(200)
      .json(
        jsonResponse(
          true,
          `${categories.length} categories found`,
          categories
        )
      );
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(jsonResponse(false, "Something went wrong. Try again", null));
  }
};






























//get single category for customer
export const getCategoryForCustomer = async (req, res) => {
  try {
    const category = await prisma.category.findFirst({
      where: {
        slug: req.params.slug,
        isDeleted: false,
        isActive: true,
      },
      select: {
        user: { select: { name: true, image: true } },
        id: true,
        name: true,
        image: true,
        slug: true,
        createdAt: true,
        subcategory: true,
        subsubcategory: true,
      },
    });

    if (category) {
      return res
        .status(200)
        .json(jsonResponse(true, `1 category found`, category));
    } else {
      return res
        .status(404)
        .json(jsonResponse(false, "No category is available", null));
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json(jsonResponse(false, error, null));
  }
};


/***Size chart */

const TARGET_FIELDS = ["categoryId", "subcategoryId", "subsubcategoryId"];


const validate = (body) => {
  const { name, columns, rows, unit } = body;
 
  if (!name || !String(name).trim()) return "Name is required";
  if (!Array.isArray(columns) || columns.length < 2) {
    return "At least 2 columns required (e.g. Size, Chest)";
  }
  if (!Array.isArray(rows) || rows.length === 0) return "At least 1 row required";
  if (rows.some((r) => !Array.isArray(r) || r.length !== columns.length)) {
    return "Every row must have the same number of cells as columns";
  }
  if (unit && !["inch", "cm"].includes(unit)) return "unit must be inch or cm";
 
  // ঠিক একটা level-এ attach করতে হবে
  const targets = TARGET_FIELDS.filter((f) => body[f]);
  if (targets.length !== 1) {
    return "Attach to exactly one of categoryId, subcategoryId or subsubcategoryId";
  }
  return null;
};
 
const pickData = (body) => ({
  name: String(body.name).trim(),
  categoryId: body.categoryId || null,
  subcategoryId: body.subcategoryId || null,
  subsubcategoryId: body.subsubcategoryId || null,
  unit: body.unit || "inch",
  columns: body.columns,
  rows: body.rows,
  note: body.note || null,
  image: body.image || null,
  isActive: body.isActive ?? true,
});
 
// ---------- Admin ----------
export const createSizeChart = async (req, res) => {
  try {
    const error = validate(req.body);
    if (error) return res.status(400).json({ message: error });
 
    const sizeChart = await prisma.sizeChart.create({ data: pickData(req.body) });
    res.status(201).json({ sizeChart });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to create size chart" });
  }
};
 
export const getSizeCharts = async (req, res) => {
  try {
    const sizeCharts = await prisma.sizeChart.findMany({ orderBy: { createdAt: "desc" } });
    res.status(200).json({ sizeCharts });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch size charts" });
  }
};
 
export const getSizeChart = async (req, res) => {
  try {
    const sizeChart = await prisma.sizeChart.findUnique({ where: { id: req.params.id } });
    if (!sizeChart) return res.status(404).json({ message: "Size chart not found" });
    res.status(200).json({ sizeChart });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch size chart" });
  }
};
 
export const updateSizeChart = async (req, res) => {
  try {
    const error = validate(req.body);
    if (error) return res.status(400).json({ message: error });
 
    const sizeChart = await prisma.sizeChart.update({
      where: { id: req.params.id },
      data: pickData(req.body),
    });
    res.status(200).json({ sizeChart });
  } catch (err) {
    console.error(err);
    if (err.code === "P2025") return res.status(404).json({ message: "Size chart not found" });
    res.status(500).json({ message: "Failed to update size chart" });
  }
};
 
export const deleteSizeChart = async (req, res) => {
  try {
    await prisma.sizeChart.delete({ where: { id: req.params.id } });
    res.status(200).json({ message: "Size chart deleted" });
  } catch (err) {
    console.error(err);
    if (err.code === "P2025") return res.status(404).json({ message: "Size chart not found" });
    res.status(500).json({ message: "Failed to delete size chart" });
  }
};
 
// ---------- Customer ----------
// Priority: product.sizeChartId → subsubcategory → subcategory → category
export const getSizeChartForProduct = async (req, res) => {
  try {
    const product = await prisma.product.findFirst({
      where: { id: req.params.productId, isDeleted: false },
      select: {
        sizeChartId: true,
        categoryId: true,
        subcategoryId: true,
        subsubcategoryId: true,
      },
    });
    if (!product) return res.status(404).json({ message: "Product not found" });
 
    const lookups = [
      product.sizeChartId && { id: product.sizeChartId },
      product.subsubcategoryId && { subsubcategoryId: product.subsubcategoryId },
      product.subcategoryId && { subcategoryId: product.subcategoryId },
      product.categoryId && { categoryId: product.categoryId },
    ].filter(Boolean);
 
    for (const where of lookups) {
      const sizeChart = await prisma.sizeChart.findFirst({
        where: { ...where, isActive: true },
        select: { id: true, name: true, unit: true, columns: true, rows: true, note: true, image: true },
      });
      if (sizeChart) return res.status(200).json({ sizeChart });
    }
 
    // কোনো chart নেই — error না, শুধু null
    res.status(200).json({ sizeChart: null });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch size chart" });
  }
};