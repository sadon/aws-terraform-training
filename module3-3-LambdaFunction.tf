#Learn: work with Lambda
#Learn work with zip archives
data "archive_file" "lambda_zip" {
  type        = "zip"
  #source_file = "./requestUnicorn.js"
  source_content = file("./requestUnicorn.js")
  source_content_filename = "index.js"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "request_unicorn" {
  function_name = "RequestUnicorn-tf"
  handler = "index.handler"
  #Learn: understand terraform compare logic
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role = aws_iam_role.wildrydes-lambda.arn # Step f
  runtime = "nodejs12.x"
  filename = "${path.module}/lambda.zip"
}