import express from "express";
import multer from "multer";

import {
  getMasterProducts,
  importMasterProducts,
  updateMasterProductImage,
  addMasterProductToProduct,
  addMasterProductsToProductBulk,
  getProductsWithoutImage,
} from "../../controllers/product/masterProduct.js";

import verify from "../../utils/verifyToken.js";

// ======================================================
// MULTER CONFIG
// ======================================================

const storage = multer.memoryStorage();

const upload = multer({
  storage,
});

// ======================================================
// ROUTER
// ======================================================

const router = express.Router();

// ======================================================
// MASTER PRODUCTS
// ======================================================

// Get all master products
router.get(
  "/v1/master-products",
  verify,
  getMasterProducts
);

// Import master products from Excel / CSV
router.post(
  "/v1/master-products/import",
  verify,
  upload.single("file"),
  importMasterProducts
);

// ======================================================
// PRODUCTS WITHOUT IMAGE
// ======================================================

// Get e-commerce products that don't have any image
//
// Example:
// GET /api/v1/products/without-image?page=1&limit=20
//
router.get(
  "/v1/products/without-image",
  verify,
  getProductsWithoutImage
);

// ======================================================
// MASTER PRODUCT IMAGE
// ======================================================

// Update master product image URL
//
// Example:
// PATCH /api/v1/master-products/:id/image
//
// Body:
// {
//   "imageUrl": "https://example.com/image.jpg"
// }
//
router.patch(
  "/v1/master-products/:id/image",
  verify,
  updateMasterProductImage
);

// ======================================================
// ADD MASTER PRODUCT → E-COMMERCE PRODUCT
// ======================================================

// Add single master product to Product table
router.post(
  "/v1/master-products/:id/add-to-product",
  verify,
  addMasterProductToProduct
);

// ======================================================
// BULK ADD MASTER PRODUCTS → E-COMMERCE PRODUCTS
// ======================================================

// Add multiple master products to Product table
router.post(
  "/v1/master-products/bulk-add-to-product",
  verify,
  addMasterProductsToProductBulk
);

// ======================================================
// EXPORT
// ======================================================

export default router;