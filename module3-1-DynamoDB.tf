#Step 1 Create DynamboDB Table
resource "aws_dynamodb_table" "Rides" {
  hash_key = "RideId"
  name = "Rides-tf" #Chreck Lambda function
  attribute {
    name = "RideId"
    type = "S"

  }
  read_capacity = 5
  write_capacity = 5
}
