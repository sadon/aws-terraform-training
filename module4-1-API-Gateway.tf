
resource "aws_api_gateway_rest_api" "wildRydes" {
  name = "WildRydes-tf"
}

resource "aws_api_gateway_authorizer" "WildRydes" {
  name = "WildRydes"
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  type = "COGNITO_USER_POOLS"

  # Step 2f Choose Cognito UserPool
  provider_arns = ["arn:aws:cognito-idp:${data.aws_region.current.name}:${data.aws_caller_identity.current_aws_account_id.id}:userpool/${aws_cognito_user_pool.rydes-user-pool.id}"]
}

#Step 4.3c
resource "aws_api_gateway_resource" "ride-resource" {
  parent_id = aws_api_gateway_rest_api.wildRydes.root_resource_id
  path_part = "ride"
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
}
