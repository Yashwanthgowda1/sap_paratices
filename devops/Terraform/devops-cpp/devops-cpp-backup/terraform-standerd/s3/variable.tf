variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_object_ownership" {
  description = "Object ownership setting for S3 bucket"
  type        = string
}

variable "s3_block_public_access" {
  description = "Block public access settings for S3 bucket"
  type        = bool
}

variable "s3_versioning_enabled" {
  description = "Enable versioning for S3 bucket"
  type        = bool
}

variable "environment" {
  description = "Environment name"
  type        = string
}