resource "aws_api_gateway_deployment" "prod-deployment-tf" {
  #Learn: Creation queue
  depends_on = [
    aws_api_gateway_method.ride-method-request,
    aws_api_gateway_integration_response.ride-integration-response
  ]
  rest_api_id = aws_api_gateway_rest_api.wildRydes.id
  stage_name = "prod-tf"
}

output "invoke_url" {
  #Goto module 4-4
  value = aws_api_gateway_deployment.prod-deployment-tf.invoke_url
}

#Step5:
# Ensure of clearing cache
