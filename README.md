# AWS Complete Infrastructure Setup

A production-grade AWS infrastructure setup using Terraform with separate modules for each service.

---

## Architecture

    Internet
       |
      ALB (public subnets)
       |
      ASG - App Servers (private subnets)
       |              |
      RDS          S3 Bucket
    (private)

    Bastion Host (public subnet) --> SSH into private instances
    NAT Gateway --> private instances can reach internet

---

## Project Structure

    aws-infra-setup/
    |-- vpc/
    |   |-- main.tf        # VPC, Subnets, IGW, NAT, Route Tables
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- ec2/
    |   |-- main.tf        # Bastion Host + Security Group
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- alb/
    |   |-- main.tf        # ALB, Target Group, Listener
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- asg/
    |   |-- main.tf        # Launch Template, ASG, Scaling Policies
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- rds/
    |   |-- main.tf        # MySQL RDS, Subnet Group, Security Group
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- s3/
    |   |-- main.tf        # S3 Bucket, Versioning, Encryption
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- iam/
    |   |-- main.tf        # IAM Role, Policies, Instance Profile
    |   |-- variables.tf
    |   |-- outputs.tf
    |-- terraform.tfvars   # Fill before apply (gitignored)
    |-- README.md

---

## Pre-requisites

- AWS CLI installed and configured (aws configure)
- Terraform installed (>= 1.0)
- AWS account with sufficient permissions
- EC2 Key Pair created in AWS

---

## Deployment Order

Each module is independent. Deploy in this order:

### Step 1 - VPC

    cd vpc
    terraform init
    terraform apply

Note outputs: vpc_id, subnet IDs

### Step 2 - IAM

    cd ../iam
    terraform init
    terraform apply

Note outputs: ec2_instance_profile_name

### Step 3 - EC2 Bastion

    cd ../ec2
    terraform init
    terraform apply

Fill variables.tf with vpc_id, public_subnet_1_id from VPC output.

### Step 4 - ALB

    cd ../alb
    terraform init
    terraform apply

Fill variables.tf with vpc_id, public subnet IDs from VPC output.

### Step 5 - ASG

    cd ../asg
    terraform init
    terraform apply

Fill variables.tf with:
  - vpc_id, private subnet IDs (from VPC)
  - alb_sg_id, target_group_arn (from ALB)
  - bastion_sg_id (from EC2)
  - ec2_instance_profile_name (from IAM)

### Step 6 - RDS

    cd ../rds
    terraform init
    terraform apply

Fill variables.tf with:
  - vpc_id, private subnet IDs (from VPC)
  - app_sg_id (from ASG)
  - db_username, db_password

### Step 7 - S3

    cd ../s3
    terraform init
    terraform apply

---

## What Each Module Creates

| Module | Resources |
|--------|-----------|
| vpc    | VPC, 2 public + 2 private subnets, IGW, NAT Gateway, Route Tables |
| ec2    | Bastion Host, Security Group |
| alb    | Application Load Balancer, Target Group, HTTP Listener |
| asg    | Launch Template, Auto Scaling Group, Scale Up/Down Policies |
| rds    | MySQL 8.0 RDS, DB Subnet Group, Security Group |
| s3     | S3 Bucket, Versioning, AES256 Encryption, Public Access Block |
| iam    | EC2 IAM Role, S3/SSM/CloudWatch Policies, Instance Profile |

---

## Security Highlights

- RDS in private subnet - not publicly accessible
- App servers in private subnet - only ALB can reach port 80
- Bastion host is only SSH entry point
- S3 bucket fully private with encryption enabled
- NAT Gateway for outbound internet from private subnets

---

## Cleanup

    cd vpc && terraform destroy
    cd ../ec2 && terraform destroy
    cd ../alb && terraform destroy
    cd ../asg && terraform destroy
    cd ../rds && terraform destroy
    cd ../s3 && terraform destroy
    cd ../iam && terraform destroy

Destroy in reverse order: s3 -> rds -> asg -> alb -> ec2 -> iam -> vpc

---

## Author

Anuj - DevOps and SRE Engineer
Working with AWS, Kubernetes, Terraform, and Observability stacks in production.

GitHub: https://github.com/anuj-devops-sre
