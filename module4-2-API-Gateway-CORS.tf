module "api-gateway-enable-cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.1"
  api_id          = aws_api_gateway_rest_api.wildRydes.id
  api_resource_id = aws_api_gateway_resource.ride-resource.id
}
