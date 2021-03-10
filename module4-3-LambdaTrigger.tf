#Add trigger step 3i-3m

resource "aws_api_gateway_integration" "request_unicorn" {
  http_method = "POST"
  resource_id = aws_api_gateway_resource.ride-resource.id
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.request_unicorn.invoke_arn
}

resource "aws_lambda_permission" "Lambda_API_Gateway_permission" {
  statement_id  = "AllowAPIgatewayInvocation"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_unicorn.function_name
  principal = "apigateway.amazonaws.com"
  # * - any stage
  source_arn = "${aws_api_gateway_rest_api.wildRydes.execution_arn}/*/POST/ride"
  #source_arn = "arn:aws:execute-api:eu-central-1:${data.aws_caller_identity.current_aws_account_id}:w0pr615pu0/*/POST/ride"
}