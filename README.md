# Terraform AWS Website Project

## Project Overview

This project automates the provisioning of a scalable, multi-environment cloud infrastructure using **Terraform** on **Amazon Web Services (AWS)**. It incorporates **Infrastructure as Code (IaC)** principles, ensuring that every environment — from development to production — is consistently managed, repeatable, and version-controlled.

Key features include:

* **Virtual Private Cloud (VPC)** - configured with both public and private subnets across **multiple availability zones**, ensuring high availability and fault tolerance.
* **Internet Gateway and NAT Gateway** - configurations that enable selective internet access based on security needs — public-facing resources (ALB) use IGW, and internal resources access the internet via NAT.
* **Application Load Balancer (ALB)** - is on public subnets and also distributes incoming traffic to healthy EC2 instances behind an Auto Scaling Group, supporting horizontal scaling and high reliability.
* **Auto Scaling Group (ASG)** - with Launch Templates that automatically adds/removes EC2 instances based on demand using metrics such as sCPU usage and CloudWatch alarms.
* **Reusable Terraform modules** - to simply and encapsulate core infrastructure components (e.g., VPC, ALB, ASG, EC2 instances).
* **Environment isolation** - via separate configuration directories for dev, staging, and prod — allowing independent deployments and changes.
* **CI/CD Pipelines with GitHub - Actions**, automating validation, planning, and application of Terraform changes whenever code is pushed.

---
## Project Infrastructure Diagram

![aws-proj drawio](https://github.com/user-attachments/assets/2d7da1cd-1c07-4132-a41a-f99acabfaa3b)

---
## Project Folder Structure

```bash
.
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│       └── main.tf, variables.tf, terraform.tfvars, versions.tf, master-key.pem
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── asg/
│   └── webservers/
├── .github/
│   └── workflows/
│       ├── terraform-dev.yml
│       ├── terraform-staging.yml
│       └── terraform-prod.yml
└── terraform.tfstate
```

---

## Modules

### `vpc/`

* Creates the **core network infrastructure**: custom VPC, public/private subnets, route tables, and gateway attachments.
* Handles routing logic for internet/NAT gateways depending on subnet type.

### `alb/`

* Defines **Application Load Balancer**, including listeners, target groups, security groups, and health checks.
* Configured to route HTTP traffic and support auto-scaling target groups.

### `asg/`

* Creates **Launch Templates** and **Auto Scaling Group**.
* Associates the ASG with CloudWatch alarms for dynamic scaling based on CPU usage.

### `webservers/`

* Provisions EC2 instances for your application layer.
* Defines **security groups**, **user data scripts** (e.g., install Nginx), and connects instances to ALB target group.

Each module contains:

* `<name>.tf`: Core logic and resource definitions
* `variables.tf`: Required and optional inputs for reuse and flexibility
* `output.tf`: Outputs like instance IDs, DNS names, or subnet IDs, shared with other modules or environments

---

## GitHub Actions CI/CD Workflows

CI/CD pipelines are defined under `.github/workflows/` and are environment-specific:

### What They Do:

* **Terraform Format Check**
  Ensures consistent formatting across your Terraform files using `terraform fmt -check`.

* **Terraform Init**
  Initializes the working directory and downloads the necessary plugins and provider configurations.

* **Terraform Validate**
  Performs syntax and schema validation for the configuration files.

* **Terraform Plan**
  Shows a detailed preview of what Terraform will do — additions, modifications, deletions.

* **Terraform Apply**
  Applies infrastructure changes automatically using `-auto-approve` (great for dev/staging, consider manual apply for prod).

---

## Security

* AWS credentials are **never hardcoded**.
* Instead, **GitHub Secrets** are used to securely inject:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
* `master-key.pem` should be rotated or deleted after testing and never committed if it contains real secrets.

---

## Future Improvements

Here are some improvements that are potentially going to be implemented for the phase 2 of the project

* **Remote State with S3 + DynamoDB**
  Use S3 as backend to store Terraform state files and DynamoDB for state locking to avoid race conditions during team collaboration.

* **Terratest Infrastructure Testing**
  Introduce Golang-based unit/integration tests to verify:

  * Instances are reachable
  * ALB health checks pass
  * VPC/subnets are correctly provisioned

* **CloudWatch Metrics and Alerts**
  Enhance observability by adding:

  * CPU alarms
  * Status checks
  * Auto scaling triggers
  * Logs for HTTP traffic or EC2 system messages

* **Parameter Store/Secrets Manager Integration**
  For securely managing secrets like AMIs, DB credentials, API tokens — enabling cleaner separation of secrets from infrastructure code.
