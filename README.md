Markdown
# terraformDockerLab 🚀

A professional demonstration of **Infrastructure-as-Code (IaC)** using **Terraform** to orchestrate containerized environments on **Oracle Linux 8**.

## 🎯 Overview
This project automates the deployment of a localized web server cluster. Instead of manual Docker commands, this lab uses Terraform to manage the lifecycle of the infrastructure, ensuring consistency and scalability.

## 🛠️ Tech Stack
* **OS:** Oracle Linux 8 (RHEL-based)
* **IaC Tool:** Terraform v1.x
* **Provider:** Docker Engine
* **Service:** Nginx (Web Server)

## 🏗️ Architecture
The Terraform configuration performs the following:
1.  **Provider Setup:** Communicates with the local Docker Unix socket (`/var/run/docker.sock`).
2.  **Image Management:** Pulls the latest enterprise-grade Nginx image.
3.  **Container Orchestration:** Provisions a container with specific port mappings (`8080:80`) and resource naming conventions.

## 🚀 Quick Start
1. **Initialize Terraform:**

   `terraform init`

3. **Deploy Infrastructure:**

   `terraform apply -auto-approve`

3. **Verify:**

   `Access the server at http://localhost:8080`

## 🧠 Key Learnings

**State Management:** Handled local `.tfstate` files and implemented `.gitignore` best practices.

**Provider Logic:** Configured the `kreuzwerker/docker provider` for non-cloud environments.

**Troubleshooting:** Managed `SELinux` and DNF package conflicts specific to Oracle Linux 8.


---


