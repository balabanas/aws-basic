data "aws_ssm_parameter" "s3_ug_access_key_id" {
  name = "BPB_S3_UG_ACCESS_KEY_ID"
}

data "aws_ssm_parameter" "s3_ug_secret_access_key" {
  name = "BPB_S3_UG_SECRET_ACCESS_KEY"
}
