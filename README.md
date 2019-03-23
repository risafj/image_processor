# Image Processor

This image processor can be used for resizing images to be used as thumbnails etc.
The code cannot be run as-is, because it's meant to be used in an AWS lambda instead of being run locally.

Gem dependencies:
- **AWS-SDK-S3** for downloading from and uploading to AWS S3 buckets

- **Rmagick Version 2.16.0** for image manipulation. A newer version of Rmagick has been released, but I had to specify the version as this one because the newer version of Rmagick requires ImageMagick 6.8.9, which is not available to AWS Linux (the version that AWS Linux has is 6.7.8).