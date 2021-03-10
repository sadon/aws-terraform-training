# Step1:
# install aws-cli

# Step 2: run
# aws s3 cp s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website ./ --recursive

# Learn: Custom data
resource "random_string" "bucket-suffix" {
  length = 5
  special = false
  upper = false
}
# Learn: Static bucket
resource "aws_s3_bucket" "wildrydes" {
  bucket = "wildrydes.luxoft-${random_string.bucket-suffix.result}"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Step3:
# Learn: external modules
module "folder_files" {
  source = "hashicorp/dir/template"
  base_dir = "./web-site"
}

# Step 4: File Upload
# Learn foreach
resource "aws_s3_bucket_object" "website-files" {
  #depends_on = [aws_s3_bucket_object.config_js] See module 2 config.js example
  bucket = aws_s3_bucket.wildrydes.id
  for_each = module.folder_files.files
  key = each.key
  content_type = each.value.content_type
  source = each.value.source_path
  content = each.value.content
}


# Learn: Outputs
# if fails use incognito mode
output "web-site-address" {
  value = "http://${aws_s3_bucket.wildrydes.website_endpoint}"
}

# Step 5: Add Read access
resource "aws_s3_bucket_policy" "read-access" {
  bucket = aws_s3_bucket.wildrydes.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "READ_BUCKETPOLICY"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.wildrydes.arn,
          "${aws_s3_bucket.wildrydes.arn}/*",
#          "${aws_s3_bucket.wildrydes.arn}/js/*",
#          "${aws_s3_bucket.wildrydes.arn}/js/vendor/*",
        ]
      },
    ]
  })
}