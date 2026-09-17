# 🚀 DevOps & Infrastructure as Code (IaC) Hands-On Lab

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.15+-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Vault](https://img.shields.io/badge/HashiCorp_Vault-Secrets_Mgmt-00C48C?style=for-the-badge&logo=vault&logoColor=white)](https://www.vaultproject.io/)
[![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

A comprehensive, production-grade DevOps repository showcasing hands-on experience with **Infrastructure as Code (IaC)** using **Terraform**, **Configuration Management & Automation** using **Ansible**, custom **VPC Network Architecture**, multi-environment infrastructure isolation (**Terraform Workspaces**), automated web application deployment, and **Enterprise Secrets Management** via **HashiCorp Vault**.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Repository Architecture](#-repository-architecture)
- [Terraform Deep-Dive](#-terraform-deep-dive)
  - [Day 1-2: Basic EC2 Provisioning](#day-1-2-basic-ec2-provisioning)
  - [Day 3: Modularization \& Reusable Modules](#day-3-modularization--reusable-modules)
  - [Day 4: Remote State Management \& S3 Backend](#day-4-remote-state-management--s3-backend)
  - [Day 5: Custom VPC Network \& Automated Flask Deployment](#day-5-custom-vpc-network--automated-flask-deployment)
  - [Day 6: Terraform Workspaces \& Multi-Environment Configuration](#day-6-terraform-workspaces--multi-environment-configuration)
  - [Day 7: HashiCorp Vault Integration for Dynamic Secrets](#day-7-hashicorp-vault-integration-for-dynamic-secrets)
- [Ansible Automation](#-ansible-automation)
  - [Error Handling \& Docker Provisioning Playbook](#error-handling--docker-provisioning-playbook)
- [Project Screenshots \& Verification](#-project-screenshots--verification)
- [Security Audits \& Safe GitHub Publishing](#-security-audits--safe-github-publishing)
- [Getting Started](#-getting-started)
- [License](#-license)

---

## 🔍 Overview

This project serves as a step-by-step reference implementation for modern cloud engineering and DevOps workflows:

1. **Declarative Cloud Provisioning**: Automating AWS EC2, Security Groups, VPCs, Subnets, and Gateways using Terraform modules.
2. **State & Remote Backend**: Locking state and configuring S3 remote backends to prevent concurrent drift and enable team collaboration.
3. **Multi-Environment Orchestration**: Utilizing Terraform Workspaces (`dev`, `stage`, `prod`) to map dynamic compute capacities seamlessly.
4. **Provisioners & Application Bootstrapping**: Deploying live web applications (Flask microservices) onto provisioned EC2 nodes automatically via SSH connection provisioners.
5. **Zero-Trust Security & Dynamic Secrets**: Integrating HashiCorp Vault AppRole authentication to dynamically fetch secrets at apply-time rather than storing them in plain text.
6. **Ansible Configuration Management**: Writing idempotent playbooks equipped with error handling (`ignore_errors`), system package verification (`openssh`, `openssl`), and conditional container execution (`docker`).

---

## 🏗️ Repository Architecture

```directory
Devops/
├── Ansible/
│   └── error_handling/
│       ├── main.yaml              # Ansible playbook for package maintenance & Docker install
│       └── inventory.ini          # Target host inventory configuration
├── Terraform/
│   ├── main.tf                    # Root starter configuration for basic EC2
│   ├── day_3/                     # Modularization Lab
│   │   ├── main.tf                # Module consumer declaration
│   │   └── modules/
│   │       └── ec2_instance/      # Reusable EC2 module (main.tf, variables.tf, output.tf)
│   ├── day_4/                     # Remote Backend Lab
│   │   ├── main.tf                # S3 Bucket & EC2 Instance resource definitions
│   │   └── backend.tf             # Terraform S3 backend state locking setup
│   ├── day_5/                     # Custom VPC & Flask Deployment Lab
│   │   ├── main.tf                # Custom VPC, Subnet, IGW, Route Table, Security Group & EC2
│   │   └── app.py                 # Lightweight Flask web app deployed automatically
│   ├── day_6/                     # Workspaces Lab
│   │   ├── main.tf                # Workspace lookup for dynamic sizing (dev, stage, prod)
│   │   ├── terraform.tfvars       # Environment variable definitions
│   │   └── modules/
│   │       └── ec2_instance/      # EC2 module implementation
│   └── day_7/                     # HashiCorp Vault Secrets Lab
│       └── main.tf                # Vault provider, AppRole authentication & KV secret lookup
├── Devops project ss/             # Architecture verification screenshots & output logs
├── .gitignore                     # Git exclusion rules for secrets, PEM keys & state files
└── README.md                      # Comprehensive repository documentation
```

---

## 🛠️ Terraform Deep-Dive

### Day 1-2: Basic EC2 Provisioning
- **Location**: [`Terraform/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/main.tf)
- Basic AWS provider setup initializing an EC2 instance (`t2.micro`) using Ubuntu AMI in `us-east-1`.

### Day 3: Modularization & Reusable Modules
- **Location**: [`Terraform/day_3/`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_3/main.tf)
- Created a modular architecture separating resource logic (`modules/ec2_instance`) from parameter inputs (`ami_value`, `instance_type_value`).
- Promotes code reuse and adherence to **DRY (Don't Repeat Yourself)** principles.

### Day 4: Remote State Management & S3 Backend
- **Location**: [`Terraform/day_4/`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_4/backend.tf)
- Configured a remote S3 backend (`<YOUR_S3_BUCKET_NAME>`) for storing `terraform.tfstate`.
- Solves local state lock collisions and facilitates secure collaboration across team members.

### Day 5: Custom VPC Network & Automated Flask Deployment
- **Location**: [`Terraform/day_5/`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_5/main.tf)
- **Networking Stack**: Custom VPC (`10.0.0.0/16`), Public Subnet (`10.0.1.0/24`), Internet Gateway (IGW), Route Table association (`0.0.0.0/0`), and custom Security Group (ports 22, 80, 5000).
- **Automated Bootstrapping**: Uses Terraform SSH provisioners to copy [`app.py`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_5/app.py), set up a Python virtual environment, install Flask, and launch a background web server running on port 80.

### Day 6: Terraform Workspaces & Multi-Environment Configuration
- **Location**: [`Terraform/day_6/`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_6/main.tf)
- Demonstrates dynamic instance scaling based on active Terraform workspace (`dev`, `stage`, `prod`):
  ```hcl
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  ```
  - `dev` $\rightarrow$ `t2.micro`
  - `stage` $\rightarrow$ `t2.medium`
  - `prod` $\rightarrow$ `t2.xlarge`

### Day 7: HashiCorp Vault Integration for Dynamic Secrets
- **Location**: [`Terraform/day_7/`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_7/main.tf)
- Integrates the **HashiCorp Vault Provider** using **AppRole Authentication**.
- Dynamically queries Vault KV secrets engine (`test-secret`) at runtime to tag AWS resources securely without hardcoding credentials in repository files.

---

## ⚙️ Ansible Automation

### Error Handling & Docker Provisioning Playbook
- **Location**: [`Ansible/error_handling/main.yaml`](file:///Users/shlokbam/Desktop/Devops/Ansible/error_handling/main.yaml)
- **Key Features**:
  - **Package Upgrade**: Ensures critical security packages (`openssh`, `openssl`) are upgraded using Ansible's `apt` module with fault tolerance (`ignore_errors: yes`).
  - **Condition Enforcement**: Checks Docker installation state via command execution (`docker --version`).
  - **Automated Installation**: Installs `docker.io` automatically if the command check fails (`when: output.failed`).

---

## 🖼️ Project Screenshots & Verification

The [`Devops project ss/`](file:///Users/shlokbam/Desktop/Devops/Devops%20project%20ss) directory contains architectural diagrams and deployment verifications:

- **Infrastructure Provisioning Logs**: Terraform plan and apply execution outputs.
- **VPC & EC2 Validation**: AWS Console verification of subnets, route tables, and security groups.
- **Flask Web Server Response**: Live web browser response (`Server is working 🚀`).

---

## 🔐 Security Best Practices & Placeholder Guide

> [!IMPORTANT]
> **SECURITY & GITHUB PUBLISHING AUDIT**
> 
> To prevent leaking sensitive credentials, private keys, or infrastructure IP addresses on GitHub, all sensitive values across this repository have been sanitized and replaced with standardized **`<YOUR_...>`** placeholders. 
> 
> Before executing any Terraform code locally or in CI/CD pipelines, ensure you replace these placeholders with your actual environment configuration.

### 📋 Placeholder Reference & Environment Setup

| Component | File Path | Sanitized Placeholder | Description & Action Required |
| :--- | :--- | :--- | :--- |
| **Vault Server** | [`Terraform/day_7/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_7/main.tf) | `<YOUR_VAULT_SERVER_IP>` | Replace with your HashiCorp Vault server IP / domain URL. |
| **Vault AppRole** | [`Terraform/day_7/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_7/main.tf) | `<YOUR_VAULT_ROLE_ID>` | Replace with your Vault AppRole Role ID. |
| **Vault Secret** | [`Terraform/day_7/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_7/main.tf) | `<YOUR_VAULT_SECRET_ID>` | Replace with your Vault AppRole Secret ID (or set via `VAULT_SECRET_ID` env var). |
| **AWS Key Pair** | [`Terraform/day_5/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_5/main.tf) | `<YOUR_KEY_PAIR_NAME>` | Replace with the name of your registered AWS EC2 Key Pair. |
| **SSH Private Key** | [`Terraform/day_5/shlok-terraform.pem`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_5/shlok-terraform.pem) | `<YOUR_PRIVATE_KEY_CONTENT_HERE>` | Replaced with placeholder. Replace with your actual RSA private key. |
| **S3 Remote Bucket** | [`Terraform/day_4/main.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_4/main.tf) & [`backend.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_4/backend.tf) | `<YOUR_S3_BUCKET_NAME>` | Replace with your globally unique AWS S3 bucket name. |
| **S3 Key Path** | [`Terraform/day_4/backend.tf`](file:///Users/shlokbam/Desktop/Devops/Terraform/day_4/backend.tf) | `<YOUR_KEY_PATH>` | Replace with your designated state storage path prefix. |

### 🛡️ Repository Git Hygiene (`.gitignore`)

The following sensitive and auto-generated files are strictly excluded from version control via [`.gitignore`](file:///Users/shlokbam/Desktop/Devops/.gitignore):
- **Private SSH Keys** (`*.pem`, `*.key`) — Prevents exposing SSH credentials.
- **Terraform State Files** (`*.tfstate`, `*.tfstate.backup`, `terraform.tfstate.d/`) — Prevents committing unencrypted IP addresses, resource IDs, and secrets.
- **Terraform Cache** (`.terraform/`, `.terraform.lock.hcl`) — Excludes local provider binaries.
- **OS & IDE Metadata** (`.DS_Store`, `.vscode/`) — Keeps the repository clean and platform-agnostic.

---

## 🚀 Getting Started

### Prerequisites
- [AWS CLI](https://aws.amazon.com/cli/) configured with proper IAM credentials (`aws configure`)
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) ($\ge v1.5.0$)
- [Ansible Core](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) ($\ge v2.15$)
- [Python 3.x](https://www.python.org/downloads/)

### Running Terraform Labs
1. Navigate to the desired lab directory (e.g., Day 5):
   ```bash
   cd Terraform/day_5
   ```
2. Initialize Terraform modules & backend:
   ```bash
   terraform init
   ```
3. Preview planned changes:
   ```bash
   terraform plan
   ```
4. Apply the infrastructure:
   ```bash
   terraform apply -auto-approve
   ```

### Running Ansible Playbooks
1. Update target IPs in `Ansible/error_handling/inventory.ini`.
2. Execute the playbook:
   ```bash
   ansible-playbook -i Ansible/error_handling/inventory.ini Ansible/error_handling/main.yaml
   ```

---

## 📄 License

This repository is distributed under the **MIT License**. Feel free to use, modify, and distribute for educational and commercial purposes.
