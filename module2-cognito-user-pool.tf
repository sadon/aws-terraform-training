# Step 1: Create User Pool
resource "aws_cognito_user_pool" "rydes-user-pool" {
  name = "WildRydes-terraform"
}

# Step 2: Add web-app as a client
resource "aws_cognito_user_pool_client" "wild-client" {
  name = "WildRydesWebApp"
  user_pool_id = aws_cognito_user_pool.rydes-user-pool.id
  generate_secret = false
}
# Step 3: Read output variables
output "user_pool_id" {
  value = aws_cognito_user_pool.rydes-user-pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.wild-client.id
}

# Step 4: Learn to work with data providers
data "aws_region" "current" {}

# Step 5: Work with templates
data "template_file" "config_js" {
  template = file("${path.module}/config.js.tpl")
  vars = {
    user_pool_id = aws_cognito_user_pool.rydes-user-pool.id
    user_pool_client_id = aws_cognito_user_pool_client.wild-client.id
    region = data.aws_region.current.name

    # For Module 4-4
    #invoke_url = ""
    invoke_url = aws_api_gateway_deployment.prod-deployment-tf.invoke_url
  }
}


resource "aws_s3_bucket_object" "config_js" {
  # Learn: Order in TF
  depends_on = [aws_s3_bucket_object.website-files]
  # Learn
  # terraform taint aws_s3_bucket_object.website-files[\"js/config.js\"] #MacOS
  # terraform taint aws_s3_bucket_object.config_js
  # terrafrom apply

  bucket = aws_s3_bucket.wildrydes.id
  key = "js/config.js"
  content = data.template_file.config_js.rendered
  content_type = "application/javascript"
}

# Sign up and confirm your user in the your web-app