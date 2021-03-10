resource "aws_api_gateway_method" "ride-method-request" {
  authorizer_id = aws_api_gateway_authorizer.WildRydes.id
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  resource_id = aws_api_gateway_resource.ride-resource.id
  http_method = "POST"
  #Learn: Use pool
  authorization = "COGNITO_USER_POOLS"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "ride-integration-request" {
  type = "AWS_PROXY"
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  resource_id = aws_api_gateway_resource.ride-resource.id
  http_method = aws_api_gateway_method.ride-method-request.http_method
  integration_http_method = aws_api_gateway_method.ride-method-request.http_method
  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.request_unicorn.arn}/invocations"
  request_templates = {
    "application/json": "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "ride-method-response" {
  depends_on = [aws_api_gateway_integration.ride-integration-request]

  http_method = aws_api_gateway_method.ride-method-request.http_method
  resource_id = aws_api_gateway_resource.ride-resource.id
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  status_code = "200"
  response_models = {
    "application/json": "Empty"
  }
  response_parameters = {}

}

resource "aws_api_gateway_integration_response" "ride-integration-response" {
  depends_on = [aws_api_gateway_method_response.ride-method-response]
  http_method = aws_api_gateway_method.ride-method-request.http_method
  resource_id = aws_api_gateway_resource.ride-resource.id
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  status_code = "200"

  response_parameters = {}
  selection_pattern = ""
  response_templates = {
    "application/json": ""
  }
}
