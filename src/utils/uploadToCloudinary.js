import { v2 as cloudinary } from "cloudinary";
import { extname } from "path";
import sharp from "sharp";
import { Readable } from "stream";

const uploadToCLoudinary = async (files, folder, callBack) => {
  try {
    let filesLength = 1;
    let images = "";

    if (Array.isArray(files)) {
      images = [];
      filesLength = files.length;
    } else {
      images = "";
    }

    if (filesLength > 3) {
      console.log("You cannot upload more than 3 pictures");
      return false;
    }

    for (let i = 0; i < filesLength; i++) {
      let file;

      if (Array.isArray(files)) {
        file = files[i];
      } else {
        file = files;
      }

      if (file === undefined) {
        return false;
      }

      const filename = file.originalname;
      const file_extension = extname(filename);

      if (
        file_extension.toLowerCase() === ".jpg" ||
        file_extension.toLowerCase() === ".png" ||
        file_extension.toLowerCase() === ".jpeg" ||
        file_extension.toLowerCase() === ".webp"
      ) {
        const bufferToStream = (buffer) => {
          const readable = new Readable({
            read() {
              this.push(buffer);
              this.push(null);
            },
          });

          return readable;
        };

        const data = await sharp(file.buffer)
          .webp({ quality: 80 })
          .toBuffer();

        const stream = cloudinary.uploader.upload_stream(
          { folder },
          callBack
        );

        bufferToStream(data).pipe(stream);
      } else {
        console.log("Please select jpg/jpeg/png/webp image");
        return false;
      }
    }
  } catch (error) {
    console.log(error);
    return false;
  }
};

// =====================================================
// UPLOAD EXTERNAL IMAGE URL TO CLOUDINARY
// =====================================================
export const uploadUrlToCloudinary = async (
  imageUrl,
  folder = "product"
) => {
  try {
    if (
      !imageUrl ||
      typeof imageUrl !== "string"
    ) {
      throw new Error(
        "Valid image URL is required"
      );
    }

    const url = imageUrl.trim();

    // ==========================================
    // URL VALIDATION
    // ==========================================

    let parsedUrl;

    try {
      parsedUrl = new URL(url);
    } catch {
      throw new Error(
        "Invalid image URL"
      );
    }

    if (
      !["http:", "https:"].includes(
        parsedUrl.protocol
      )
    ) {
      throw new Error(
        "Only HTTP and HTTPS image URLs are allowed"
      );
    }

    console.log(
      "Downloading external image:",
      url
    );

    // ==========================================
    // DOWNLOAD IMAGE
    // ==========================================

    const response = await axios.get(
      url,
      {
        responseType: "arraybuffer",

        timeout: 30000,

        maxContentLength:
          15 * 1024 * 1024,

        maxBodyLength:
          15 * 1024 * 1024,

        headers: {
          "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/151.0.0.0 Safari/537.36",

          Accept:
            "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",

          "Accept-Language":
            "en-US,en;q=0.9",

          Referer:
            `${parsedUrl.protocol}//${parsedUrl.host}/`,

          Connection: "keep-alive",
        },

        validateStatus: (status) =>
          status >= 200 &&
          status < 300,
      }
    );

    // ==========================================
    // CONTENT TYPE
    // ==========================================

    const contentType =
      response.headers[
        "content-type"
      ] || "";

    console.log(
      "External image content-type:",
      contentType
    );

    if (
      !contentType.startsWith("image/")
    ) {
      throw new Error(
        `URL did not return an image. Content-Type: ${contentType}`
      );
    }

    // ==========================================
    // BUFFER
    // ==========================================

    const imageBuffer =
      Buffer.from(response.data);

    if (!imageBuffer.length) {
      throw new Error(
        "Downloaded image is empty"
      );
    }

    console.log(
      "Downloaded image size:",
      imageBuffer.length,
      "bytes"
    );

    // ==========================================
    // CLOUDINARY UPLOAD
    // ==========================================

    const result =
      await new Promise(
        (resolve, reject) => {
          const uploadStream =
            cloudinary.uploader.upload_stream(
              {
                folder,
                resource_type: "image",

                // Let Cloudinary automatically
                // detect the format
                use_filename: false,

                unique_filename: true,

                overwrite: false,
              },

              (error, result) => {
                if (error) {
                  console.error(
                    "Cloudinary upload error:",
                    error
                  );

                  return reject(error);
                }

                resolve(result);
              }
            );

          uploadStream.end(
            imageBuffer
          );
        }
      );

    // ==========================================
    // RESULT
    // ==========================================

    if (!result?.secure_url) {
      throw new Error(
        "Cloudinary did not return secure_url"
      );
    }

    console.log(
      "Cloudinary upload successful:",
      result.secure_url
    );

    return result;
  } catch (error) {
    console.error(
      "uploadUrlToCloudinary error:",
      error?.response?.status ||
        error?.status ||
        ""
    );

    console.error(
      "URL:",
      imageUrl
    );

    console.error(
      "Message:",
      error?.message
    );

    throw new Error(
      error?.message ||
        "Failed to upload external image to Cloudinary"
    );
  }
};
export default uploadToCLoudinary;