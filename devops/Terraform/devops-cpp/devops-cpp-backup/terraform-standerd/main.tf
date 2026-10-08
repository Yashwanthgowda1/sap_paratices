module "s3_bucket" {
  source = "./module/s3"

  s3_bucket_name         = var.s3_bucket_name
  s3_object_ownership    = var.s3_object_ownership
  s3_block_public_access = var.s3_block_public_access
  s3_versioning_enabled  = var.s3_versioning_enabled
  environment            = var.environment
}
