/**
 * ============================================================
 * PRODUCT IMAGE → CLOUDINARY MIGRATION
 * ============================================================
 *
 * This script:
 * 1. Reads ProductImage records from Prisma
 * 2. Finds external image URLs
 * 3. Uploads them directly to Cloudinary
 * 4. Updates ProductImage.image with Cloudinary secure_url
 * 5. Skips images already hosted on Cloudinary
 * 6. Keeps original URL if upload fails
 *
 * ENV:
 *
 * CLOUDINARY_NAME=xxxxxxxx
 * CLOUDINARY_API_KEY=xxxxxxxx
 * CLOUDINARY_API_SECRET=xxxxxxxx
 *
 * ============================================================
 */

import dotenv from "dotenv";
import { v2 as cloudinary } from "cloudinary";
import { PrismaClient } from "@prisma/client";

// ============================================================
// LOAD ENVIRONMENT
// ============================================================

dotenv.config();

// ============================================================
// PRISMA
// ============================================================

const prisma = new PrismaClient();

// ============================================================
// CLOUDINARY ENV VALIDATION
// ============================================================

const CLOUDINARY_NAME = process.env.CLOUDINARY_NAME;
const CLOUDINARY_API_KEY = process.env.CLOUDINARY_API_KEY;
const CLOUDINARY_API_SECRET = process.env.CLOUDINARY_API_SECRET;

if (!CLOUDINARY_NAME) {
  throw new Error(
    "CLOUDINARY_NAME is missing from environment variables"
  );
}

if (!CLOUDINARY_API_KEY) {
  throw new Error(
    "CLOUDINARY_API_KEY is missing from environment variables"
  );
}

if (!CLOUDINARY_API_SECRET) {
  throw new Error(
    "CLOUDINARY_API_SECRET is missing from environment variables"
  );
}

// ============================================================
// CLOUDINARY CONFIG
// ============================================================

cloudinary.config({
  cloud_name: CLOUDINARY_NAME,
  api_key: CLOUDINARY_API_KEY,
  api_secret: CLOUDINARY_API_SECRET,
});

// ============================================================
// CONFIG
// ============================================================

const CLOUDINARY_FOLDER = "products";

const MAX_RETRIES = 3;

const RETRY_DELAY = 2000;

// ============================================================
// HELPERS
// ============================================================

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// ============================================================
// CHECK CLOUDINARY URL
// ============================================================

function isCloudinaryUrl(url) {
  if (!url || typeof url !== "string") {
    return false;
  }

  return (
    url.includes("res.cloudinary.com") ||
    url.includes("cloudinary.com")
  );
}

// ============================================================
// CHECK EXTERNAL IMAGE
// ============================================================

function isExternalImage(url) {
  if (!url || typeof url !== "string") {
    return false;
  }

  if (url === "images/product/product.png") {
    return false;
  }

  if (isCloudinaryUrl(url)) {
    return false;
  }

  return (
    url.startsWith("http://") ||
    url.startsWith("https://")
  );
}

// ============================================================
// UPLOAD IMAGE WITH RETRY
// ============================================================

async function uploadToCloudinary(imageUrl, attempt = 1) {
  try {
    console.log(
      `Uploading to Cloudinary... Attempt ${attempt}/${MAX_RETRIES}`
    );

    const result = await cloudinary.uploader.upload(imageUrl, {
      folder: CLOUDINARY_FOLDER,

      resource_type: "image",

      // Let Cloudinary generate unique public ID
      use_filename: false,

      unique_filename: true,

      overwrite: false,
    });

    return result;
  } catch (error) {
    console.log(
      `Upload attempt ${attempt} failed: ${
        error?.message || error
      }`
    );

    if (attempt >= MAX_RETRIES) {
      throw error;
    }

    console.log(
      `Retrying in ${RETRY_DELAY / 1000} seconds...`
    );

    await sleep(RETRY_DELAY);

    return uploadToCloudinary(
      imageUrl,
      attempt + 1
    );
  }
}

// ============================================================
// MIGRATION
// ============================================================

async function migrateProductImages() {
  console.log("");
  console.log("==============================================");
  console.log("PRODUCT IMAGE → CLOUDINARY MIGRATION");
  console.log("==============================================");

  console.log("");
  console.log("Cloudinary configuration:");
  console.log(
    "Cloud name:",
    CLOUDINARY_NAME
  );
  console.log(
    "API key:",
    CLOUDINARY_API_KEY ? "LOADED" : "MISSING"
  );
  console.log(
    "API secret:",
    CLOUDINARY_API_SECRET ? "LOADED" : "MISSING"
  );

  console.log("");
  console.log("Cloudinary folder:", CLOUDINARY_FOLDER);

  console.log("");
  console.log("----------------------------------------------");

  // ==========================================================
  // GET PRODUCT IMAGES
  // ==========================================================

  const productImages =
    await prisma.productImage.findMany({
      where: {
        isDeleted: false,
      },
      select: {
        id: true,
        productId: true,
        image: true,
      },
      orderBy: {
        createdAt: "asc",
      },
    });

  console.log(
    `Total ProductImage records: ${productImages.length}`
  );

  // ==========================================================
  // FILTER EXTERNAL IMAGES
  // ==========================================================

  const externalImages = productImages.filter(
    (item) => isExternalImage(item.image)
  );

  const alreadyCloudinary =
    productImages.filter((item) =>
      isCloudinaryUrl(item.image)
    );

  console.log(
    `External images to migrate: ${externalImages.length}`
  );

  console.log(
    `Already Cloudinary: ${alreadyCloudinary.length}`
  );

  console.log(
    `Skipped/default images: ${
      productImages.length -
      externalImages.length -
      alreadyCloudinary.length
    }`
  );

  console.log("----------------------------------------------");
  console.log("");

  // ==========================================================
  // RESULT TRACKING
  // ==========================================================

  const successful = [];

  const failed = [];

  const skipped = [];

  // ==========================================================
  // MIGRATE ONE BY ONE
  // ==========================================================

  for (let i = 0; i < externalImages.length; i++) {
    const productImage = externalImages[i];

    const currentNumber = i + 1;

    console.log("");
    console.log(
      `[${currentNumber}/${externalImages.length}]`
    );

    console.log(
      `ProductImage ID: ${productImage.id}`
    );

    console.log(
      `Product ID: ${productImage.productId}`
    );

    console.log(
      `Source: ${productImage.image}`
    );

    console.log("");

    try {
      // ========================================================
      // EXTRA SAFETY CHECK
      // ========================================================

      if (!isExternalImage(productImage.image)) {
        console.log("SKIPPED");

        skipped.push({
          productImageId: productImage.id,
          productId: productImage.productId,
          reason: "Not an external image",
        });

        continue;
      }

      // ========================================================
      // UPLOAD
      // ========================================================

      const result = await uploadToCloudinary(
        productImage.image
      );

      if (!result?.secure_url) {
        throw new Error(
          "Cloudinary upload succeeded but secure_url was not returned"
        );
      }

      console.log("");
      console.log("Cloudinary upload successful ✓");

      console.log(
        `Cloudinary URL: ${result.secure_url}`
      );

      // ========================================================
      // UPDATE DATABASE
      // ========================================================

      await prisma.productImage.update({
        where: {
          id: productImage.id,
        },

        data: {
          image: result.secure_url,
          updatedBy: "cloudinary-migration",
        },
      });

      console.log("Database updated ✓");

      // ========================================================
      // SUCCESS
      // ========================================================

      successful.push({
        productImageId: productImage.id,
        productId: productImage.productId,
        oldUrl: productImage.image,
        newUrl: result.secure_url,
      });

      console.log("");
      console.log("MIGRATION SUCCESS ✓");
    } catch (error) {
      // ========================================================
      // FAILED
      // ========================================================

      const errorMessage =
        error?.message ||
        String(error);

      console.log("");
      console.log("MIGRATION FAILED ✗");
      console.log("Error:", errorMessage);

      failed.push({
        productImageId: productImage.id,
        productId: productImage.productId,
        url: productImage.image,
        error: errorMessage,
      });
    }
  }

  // ==========================================================
  // FINAL REPORT
  // ==========================================================

  console.log("");
  console.log("");
  console.log("==============================================");
  console.log("MIGRATION COMPLETE");
  console.log("==============================================");

  console.log(
    `Total ProductImage records: ${productImages.length}`
  );

  console.log(
    `Total external images: ${externalImages.length}`
  );

  console.log(
    `Successfully migrated: ${successful.length}`
  );

  console.log(
    `Failed: ${failed.length}`
  );

  console.log(
    `Skipped: ${
      skipped.length + alreadyCloudinary.length
    }`
  );

  console.log("==============================================");

  // ==========================================================
  // SUCCESS LIST
  // ==========================================================

  if (successful.length > 0) {
    console.log("");
    console.log("==============================================");
    console.log("SUCCESSFULLY MIGRATED");
    console.log("==============================================");

    successful.forEach((item, index) => {
      console.log("");
      console.log(`${index + 1}. ProductImage:`);
      console.log(item.productImageId);

      console.log("Product:");
      console.log(item.productId);

      console.log("Old URL:");
      console.log(item.oldUrl);

      console.log("New Cloudinary URL:");
      console.log(item.newUrl);
    });
  }

  // ==========================================================
  // FAILED LIST
  // ==========================================================

  if (failed.length > 0) {
    console.log("");
    console.log("");
    console.log("==============================================");
    console.log("FAILED IMAGES");
    console.log("==============================================");

    failed.forEach((item, index) => {
      console.log("");
      console.log(`${index + 1}. ProductImage:`);
      console.log(item.productImageId);

      console.log("Product:");
      console.log(item.productId);

      console.log("URL:");
      console.log(item.url);

      console.log("Error:");
      console.log(item.error);
    });
  }

  // ==========================================================
  // SKIPPED LIST
  // ==========================================================

  if (skipped.length > 0) {
    console.log("");
    console.log("");
    console.log("==============================================");
    console.log("SKIPPED IMAGES");
    console.log("==============================================");

    skipped.forEach((item, index) => {
      console.log("");
      console.log(`${index + 1}. ProductImage:`);
      console.log(item.productImageId);

      console.log("Product:");
      console.log(item.productId);

      console.log("Reason:");
      console.log(item.reason);
    });
  }

  console.log("");
  console.log("==============================================");
  console.log("DONE");
  console.log("==============================================");
}

// ============================================================
// RUN
// ============================================================

(async () => {
  try {
    await migrateProductImages();
  } catch (error) {
    console.error("");
    console.error("==============================================");
    console.error("FATAL ERROR");
    console.error("==============================================");
    console.error(
      error?.message || error
    );
  } finally {
    await prisma.$disconnect();
  }
})();