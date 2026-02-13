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
   ```bash
   terraform init
Deploy Infrastructure:

Bash
terraform apply -auto-approve
Verify:
Access the server at http://localhost:8080

🧠 Key Learnings
State Management: Handled local .tfstate files and implemented .gitignore best practices.

Provider Logic: Configured the kreuzwerker/docker provider for non-cloud environments.

Troubleshooting: Managed SELinux and DNF package conflicts specific to Oracle Linux 8.


---

### Why this README works:
1.  **Keywords:** Mentions "Oracle Linux 8," "RHEL-based," and "Orchestration"—things recruiters search for.
2.  **Structure:** It’s easy to scan.
3.  **The "Why":** It explains the *logic* behind the code, not just the code itself.

### How to push to GitHub:
If you haven't already, run these commands to share your work with the world:
1.  **Initialize Git:** `git init`
2.  **Add files:** `git add .`
3.  **Commit:** `git commit -m "Initial commit: terraformDockerLab on OL8"`
4.  **Push:** Create a repo on GitHub named `terraformDockerLab`, copy the URL, and run:
    * `git remote add origin YOUR_URL_HERE`
    * `git push -u origin main`

**Would you like me to help you add a "Scalability" feature to this project next—where you can spin up 5 servers with a single variable change—to show off even more Terraform skills?**


