require 'aws-sdk-s3'
require 'rmagick'

include Magick

# The AWS config data should not be necessary in the actual lambda.
# Aws.config.update({
#   region: 'ap-northeast-1',
#   credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
#   })
def lambda_handler(event:, context:)
  # Client is necessary for downloading. Resource is for uploading.
  s3_client = Aws::S3::Client.new
  s3_resource = Aws::S3::Resource.new

  download_bucket_name = 'source-image-bois'
  download_file_name = 'anarchy.jpg'

  # This downloads an object to the specified path, or to memory (if no path specified).
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html#get_object-instance_method
  downloaded_file = s3_client.get_object(
    response_target: '/tmp/resized.jpg',
    bucket: download_bucket_name,
    key: download_file_name
    )

    # .first is because response is an array of images and we only want the conetnts of the first one.
    original_image = Image.read('/tmp/resized.jpg').first
    # https://rmagick.github.io/comtasks.html#thumb
    processed_image = original_image.scale(125, 125)
    processed_image.write('/tmp/resized.jpg')

  # Fill this variable, and then call the upload method on the actual image in tmp.
  upload_file_name = s3_resource.bucket('edited-image-bucket').object("resized_#{download_file_name}")
  upload_file_name.upload_file('/tmp/resized.jpg')

end
