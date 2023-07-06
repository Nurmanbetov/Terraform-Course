# Check if that respective Instance Type is supported in that Specific Region in list of availability Zones
# Get the List of Availability Zones in a Particular region where that respective Instance Type is supported
# Datasource

data "aws_ec2_instance_type_offerings" "my_ins_type2" {
  for_each = toset(["eu-west-3a","eu-west-3b","eu-west-3c","eu-west-3d"])
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location" 
    values = [each.key]
  }
  location_type = "availability-zone"
}


# Output
output "output_v2_1" {
#  value = data.aws_ec2_instance_type_offerings.my_ins_type1.instance_types
  value = toset([for t in data.aws_ec2_instance_type_offerings.my_ins_type2: t.instance_types])
}

output "output_v2_2" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type2: az => details.instance_types
  }
}