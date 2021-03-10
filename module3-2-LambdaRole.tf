#Step 2g Create Lambda role
resource "aws_iam_role" "wildrydes-lambda" {
  name = "WildRydesLambda-tf"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

# Step 2d
# Learn: Attach simple roles
resource "aws_iam_role_policy_attachment" "wild-lambda-binding" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.wildrydes-lambda.name
}

# Step 2k
# Learn: Attach inline policy
resource "aws_iam_role_policy_attachment" "wild-cloudwatch-binding" {
  policy_arn = aws_iam_policy.DynamoDBWriteAccess.arn
  role = aws_iam_role.wildrydes-lambda.name
}

# Learn: work with data providers
data "aws_caller_identity" "current_aws_account_id" {}

resource "aws_iam_policy" "DynamoDBWriteAccess" {
  name = "DynamoDBWriteAccess-tf"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "dynamodb:PutItem",
        "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current_aws_account_id.id}:table/Rides-tf"
      }
    ]
  })
}
