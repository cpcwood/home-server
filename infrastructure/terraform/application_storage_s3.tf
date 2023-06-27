resource "random_id" "application_storage_s3" {
  byte_length = 6
}

resource "aws_s3_bucket" "application_storage_s3" {
  bucket = "${var.application_storage_s3_bucket_name}-${var.environment}-${random_id.application_storage_s3.hex}"
}
