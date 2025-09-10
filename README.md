# Self Hosting Kafka using Terraform scripts.

## How to run? 
First 
`terraform init` to initialize terraform
Second
`terraform validate` to test validate syntax
Third
`terraform apply` to apply everything into your AWS account. 

Make sure to create terraform.tfvars file before you init

### Syntax for terraform.tfvars file - 

```
vpc_id     = "....."  VPC ID
subnet_ids_broker = [".....", "....."]  broker subnet ID's
subnet_ids_consumer = "....." consumer subnet ID
key_names   = "..." this is the keypair name
```

### How to install Kafka in your instance? 
Run 
`kafka_installation_script.sh`
It can also be added as part of the Terraform script so it installs in each system but I suggest running them seperately to ensure correct versions are installed and for debugging in case of any issues.