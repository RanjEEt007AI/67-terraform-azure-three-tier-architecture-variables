# 🚀 Terraform Azure Three-Tier Architecture Using Variables

<h1 align="center">☁️ Azure Three-Tier Architecture</h1>

<h3 align="center">Infrastructure as Code | Terraform | Microsoft Azure</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Cloud-Microsoft%20Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" />
  <img src="https://img.shields.io/badge/IaC-Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/OS-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-HCL-844FBA?style=for-the-badge" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-Three--Tier-success?style=flat-square" />
  <img src="https://img.shields.io/badge/Configuration-Variable%20Based-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Automation-100%25%20Terraform-orange?style=flat-square" />
</p>

---

## 📌 Project Overview

This project demonstrates how to design and deploy a **Three-Tier Architecture on Microsoft Azure using Terraform and variable-based configuration**.

The infrastructure is provisioned using Infrastructure as Code (IaC), making it repeatable, manageable, scalable and easier to maintain.

The architecture separates the infrastructure into three independent layers:

- 🌐 **Web Tier:** Handles incoming HTTP/HTTPS requests using Nginx.
- ⚙️ **Application Tier:** Runs a Python-based application.
- 🗄️ **Database Tier:** Hosts PostgreSQL database services.

Each tier is deployed in a separate subnet with dedicated Network Security Groups (NSGs).

## 🏗️ Architecture Diagram

```text
                       INTERNET
                           |
                           |
                     PUBLIC IP
                           |
                  +----------------+
                  |    WEB TIER    |
                  |                |
                  |  Ubuntu Linux  |
                  |     Nginx      |
                  |                |
                  | 10.0.1.0/24    |
                  +----------------+
                           |
                           |
                    TCP PORT 8080
                           |
                  +----------------+
                  |  APP TIER      |
                  |                |
                  |  Ubuntu Linux  |
                  | Python App     |
                  |                |
                  | 10.0.2.0/24    |
                  +----------------+
                           |
                           |
                    TCP PORT 5432
                           |
                  +----------------+
                  |  DATABASE TIER |
                  |                |
                  | Ubuntu Linux   |
                  | PostgreSQL     |
                  |                |
                  | 10.0.3.0/24    |
                  +----------------+

                  AZURE VIRTUAL NETWORK
                     10.0.0.0/16
```

## 🎯 Project Objectives

- Build a real-world Azure Three-Tier Architecture.
- Automate Azure infrastructure using Terraform.
- Use variables instead of hardcoded configurations.
- Implement Terraform `for_each`, `map`, `object` and `locals`.
- Configure subnet-level Network Security Groups.
- Deploy three Ubuntu Linux Virtual Machines.
- Automate software installation using Cloud-init scripts.
- Follow Infrastructure as Code best practices.

## 🛠️ Azure Resources Created

| Azure Resource | Quantity | Purpose |
|---|---:|---|
| Resource Group | 1 | Infrastructure management |
| Virtual Network | 1 | Private network |
| Subnets | 3 | Separate application tiers |
| Network Security Groups | 3 | Network security |
| Public IP | 1 | Web-tier access |
| Network Interfaces | 3 | VM connectivity |
| Linux Virtual Machines | 3 | Web, App and DB tiers |

## 🔐 Network Security Design

| Tier | Port | Source | Purpose |
|---|---|---|---|
| Web | 80 | Internet | HTTP |
| Web | 443 | Internet | HTTPS |
| Web | 22 | Admin IP | SSH |
| App | 8080 | Web subnet | Application traffic |
| Database | 5432 | App subnet | PostgreSQL traffic |

**Security highlights:**

- Only the Web VM receives a Public IP.
- App and Database VMs use private IP addresses.
- SSH access to the Web VM is restricted to the administrator's public IP.
- Application traffic is allowed only from the Web subnet.
- Database traffic is allowed only from the Application subnet.

Note: Azure NSG default outbound rules still apply. This demo does not implement complete production-grade egress restrictions.

## 📂 Repository Structure

```text
34-terraform-azure-three-tier-architecture/
│
├── cloud-init/
│   ├── web.sh
│   ├── app.sh
│   └── db.sh
│
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── terraform.tfvars.example
├── locals.tf
├── outputs.tf
├── .gitignore
└── README.md
```

### 📖 Terraform File Explanation

| File | Description |
|---|---|
| providers.tf | Terraform and Azure provider configuration |
| main.tf | Main Azure infrastructure resources |
| variables.tf | Input variables |
| terraform.tfvars | Actual project configuration |
| terraform.tfvars.example | Example configuration |
| locals.tf | Common names and tier definitions |
| outputs.tf | Deployment outputs |
| .gitignore | Ignore sensitive and temporary files |

### ☁️ Cloud-init Scripts

| File | Responsibility |
|---|---|
| cloud-init/web.sh | Installs and configures Nginx |
| cloud-init/app.sh | Installs and configures Python application |
| cloud-init/db.sh | Installs and starts PostgreSQL |

## 🧠 Terraform Concepts Used

| Terraform Concept | Implementation |
|---|---|
| Variables | Configurable infrastructure |
| Map | Tier configuration |
| Object | Structured subnet configuration |
| for_each | Multiple Azure resources |
| Locals | Common naming conventions |
| merge() | Resource tags |
| file() | Read SSH key and scripts |
| base64encode() | Cloud-init configuration |
| Outputs | Public and private IP addresses |
| Dependencies | Resource creation order |

## ⚙️ Prerequisites

Before deploying this project, install:

1. Microsoft Azure Subscription
2. Azure CLI
3. Terraform CLI (1.5+)
4. Git
5. SSH Key Pair
6. Windows PowerShell

## 🚀 Deployment Guide

### Step 1: Clone Repository

```powershell
git clone https://github.com/RanjEEt007AI/34-terraform-azure-three-tier-architecture.git

cd 34-terraform-azure-three-tier-architecture
```

### Step 2: Login to Azure

```powershell
az login

az account show --output table
```

Select your subscription:

```powershell
az account set --subscription "YOUR-SUBSCRIPTION-ID"
```

### Step 3: Generate SSH Key

```powershell
ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa"
```

### Step 4: Configure Variables

Copy the example file:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit the file:

```powershell
notepad terraform.tfvars
```

Update your:

- Azure Subscription ID
- Azure Region
- SSH Public Key Path
- Administrator Public IP CIDR
- VM Size

**Important:** Never upload your actual `terraform.tfvars` file to GitHub.

### Step 5: Initialize Terraform

```powershell
terraform init
```

### Step 6: Format Terraform Files

```powershell
terraform fmt -recursive
```

### Step 7: Validate Configuration

```powershell
terraform validate
```

### Step 8: Review Execution Plan

```powershell
terraform plan -out main.tfplan
```

### Step 9: Deploy Azure Infrastructure

```powershell
terraform apply main.tfplan
```

### Step 10: Check Deployment Outputs

```powershell
terraform output
```

Get Web VM Public IP:

```powershell
terraform output -raw web_public_ip
```

Open the IP address in your browser:

```text
http://YOUR-WEB-PUBLIC-IP
```

## 📊 Expected Terraform Outputs

Example output:

```hcl
resource_group_name = "rg-three-tier-dev"

web_public_ip = "20.xx.xx.xx"

vm_names = {
  app = "three-tier-dev-vm-app"
  db  = "three-tier-dev-vm-db"
  web = "three-tier-dev-vm-web"
}

vm_private_ips = {
  app = "10.0.2.x"
  db  = "10.0.3.x"
  web = "10.0.1.x"
}
```

Actual IP addresses will be assigned by Azure during deployment.

## 🧪 Verification

Connect to Web VM:

```powershell
ssh azureuser@YOUR-WEB-PUBLIC-IP
```

Check Nginx:

```bash
sudo systemctl status nginx
```

Check Python Application:

```bash
sudo systemctl status three-tier-app
```

Check PostgreSQL:

```bash
sudo systemctl status postgresql
```

For private VMs, use an approved private administration path such as Azure Bastion or VPN. This project does not yet configure that access path.

## 🧹 Destroy Infrastructure

After completing your testing, remove the resources:

```powershell
terraform destroy
```

Review the deletion plan before confirming.

## 🔒 Security Best Practices

- Never commit Terraform state files.
- Never commit SSH private keys.
- Keep `terraform.tfvars` out of GitHub.
- Restrict SSH access using trusted IP addresses.
- Use Azure Key Vault for secrets management.
- Use a secured remote Terraform backend for team environments.
- Implement monitoring, backup and disaster recovery.
- Use Azure Bastion or VPN for private VM administration.

## ⚠️ Project Scope

This is a practical learning implementation, not a fully production-ready three-tier application.

Currently:
- Nginx serves a static Web Tier page.
- Python runs a standalone application service on port 8080.
- PostgreSQL is installed and running.
- The Python application is not yet connected to PostgreSQL.
- Nginx reverse proxy and production TLS are not configured.

These can be implemented as future enhancements.

## 🚀 Future Enhancements

- [ ] Create reusable Terraform modules.
- [ ] Configure Azure Application Gateway.
- [ ] Implement Nginx reverse proxy.
- [ ] Connect Python application with PostgreSQL.
- [ ] Configure Azure Bastion.
- [ ] Integrate Azure Key Vault.
- [ ] Configure Azure Monitor and Log Analytics.
- [ ] Implement Terraform Remote Backend.
- [ ] Integrate Azure DevOps CI/CD pipeline.
- [ ] Implement autoscaling and high availability.

## 🎓 What I Learned

Through this project, I practiced:

- Designing Azure network architecture.
- Implementing Three-Tier infrastructure.
- Writing reusable Terraform configurations.
- Using variable-based resource provisioning.
- Managing Azure NSGs and subnet associations.
- Automating Linux VM configuration with Cloud-init.
- Understanding secure communication between application tiers.

## 👨‍💻 Author

**Ranjeet Kumar**

🚀 DevOps Engineer | Microsoft Azure | Terraform | CI/CD | Cloud Automation

<p align="left">
  <a href="https://github.com/RanjEEt007AI">
    <img src="https://img.shields.io/badge/GitHub-RanjEEt007AI-181717?style=for-the-badge&logo=github" />
  </a>
</p>

⭐ If you find this project useful, please give it a Star!

---

<p align="center">
  <b>Building | Automating | Deploying | Learning</b>
  <br/>
  <i>Infrastructure as Code is the foundation of modern DevOps.</i>
</p>
