resource "aws_s3_bucket" "s3_bucket_cretaion" {
    bucket = var.s3_bucket_name
    tags = {
    Name        = "${var.environment}-bucket"
    Environment = var.environment
    }
    
  
}
resource "aws_s3_bucket_ownership_controls" "ownership_control" {
    bucket = aws_s3_bucket.s3_bucket_cretaion.id
    rule {
        object_ownership = var.s3_object_ownership
    }
   
}
resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = aws_s3_bucket.s3_bucket_cretaion.id
    block_public_acls       = var.s3_block_public_access
    block_public_policy     = var.s3_block_public_access
    ignore_public_acls      = var.s3_block_public_access
    restrict_public_buckets = var.s3_block_public_access
  
}