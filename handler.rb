require 'aws-sdk-s3'
require 'rmagick'
require 'pry'

include Magick
Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

# Client class is necessary for downloading.
# Resource class is necessary for uploading the object.
s3_client = Aws::S3::Client.new
s3_resource = Aws::S3::Resource.new

downloaded_file_name = 'anarchy.jpg'

# This downloads an object to the specified path, or to memory (if no path specified).
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#get_object-instance_method
downloaded_file = s3_client.get_object(
  response_target: '/tmp/resized.jpg',
  bucket: 'source-image-bois',
  key: downloaded_file_name
  )

  original_image = Image.read('/tmp/resized.jpg').first
  # https://rmagick.github.io/comtasks.html#thumb
  processed_image = original_image.scale(125, 125)
  processed_image.write('/tmp/resized.jpg')

new_file_name = "resized_#{downloaded_file_name}"

# This is just a pointer. Fill this variable, and then call the upload method.
object_to_upload = s3_resource.bucket('edited-image-bucket').object(new_file_name)

object_to_upload.upload_file('/tmp/resized.jpg')
