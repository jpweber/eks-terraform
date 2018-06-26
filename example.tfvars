ami_id = "ami-31394949" #amazon linux 2 us-west-2

ssh_public_key_name = "bastion-key"

ssh_public_key_file = "/Users/jdoe/.ssh/aws.pub"

vpc_cidr_block = "10.0.0.0/16"

num_public_subnets = 3

public_subnet_blocks = [
  "10.0.0.0/24",
  "10.0.1.0/24",
  "10.0.2.0/24",
]

num_private_subnets = 3

private_subnet_blocks = [
  "10.0.10.0/24",
  "10.0.11.0/24",
  "10.0.12.0/24",
]
