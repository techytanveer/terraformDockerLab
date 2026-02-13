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

## 📁 Project Structure

```
terraformDockerLab/
├── .gitignore          # Crucial! Ignore .terraform and tfstate
├── providers.tf        # Provider configuration
├── main.tf             # Resource definitions
├── variables.tf        # Input variables (Avoid hard-coding)
├── outputs.tf          # Useful info (IPs/Ports) after deployment
└── README.md           # Pitch
```

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

## 📄 The Menifest in phases

This project is more than just a script; it is a **simulation of modern DevOps workflows** performed entirely on a local hardware. By using Oracle Linux 8 (OL8), which is giving it a comfortable position with "Enterprise Linux," which is exactly what banks and large tech firms use.

Here is the step-by-step breakdown of the architectural journey.

**Phase 1: The Foundation (The OS Layer)**

Before Terraform can do anything, it needs a "host" to live on.

 * **Oracle Linux 8:** I chose this because it is stable and mirrors Red Hat Enterprise Linux (RHEL).
 * **The Conflict:** I removed `podman` because, while great, the Terraform community provides more robust support for the standard **Docker Engine**.
 * **The Socket:** When I installed Docker and ran `usermod`, I created a "bridge" (the Unix socket at `/var/run/docker.sock`). This is the door Terraform knocks on to give Docker instructions.

**Phase 2: The Logic (The Terraform Files)**

Terraform works by comparing **three things:** <ins>The Code</ins>, <ins>the Reality</ins> (the State file), and <ins>the Cloud</ins> (or in my case, the Docker Engine).

 1. `providers.tf` **(The Translator):** Terraform doesn't natively know how to talk to Docker. This file downloads a "plugin" (the provider) that translates Terraform's language into Docker's API language.
 2. `main.tf` **(The Blueprint):** This is the "Desired State." Instead of saying "Run this command," I am saying "I want a container named X to exist with Port Y." Terraform's job is to make that true.
 3. `variables.tf` **(The Controller):** This allow me to change the deployment without touching the core code. To move this to port 9090, no need to edit the logic; just change in the variable will work.

**Phase 3: The Lifecycle (The Execution)**

When you ran those commands, a specific sequence of events occurred:

 * `terraform init`: Terraform looked at the code, saw that I needed the Docker provider, and went to the internet to download that plugin into the `.terraform/` folder.
 * `terraform plan`: This is a "dry run." Terraform looked at your machine, realized there was no Nginx container, and calculated: *"I need to add 2 resources (Image + Container)."*
 * `terraform apply`: The actual execution. Terraform sent a request through the Unix socket to the Docker Daemon. Docker then pulled the image and started the container.

**Phase 4: The Result (Infrastructure as Code)**

The end result is an Immutable Infrastructure.

I didn't manually run `docker pull` or `docker run`. If the container is accidentaly deleted, you don't have to remember the settings to rebuild it—you just run `terraform apply` again, and Terraform restores it exactly as defined in the code. This is what "Infrastructure as Code" means.

---
## CHANGES

**1 - single-container-first-stable.tar**

**2 - change-3-containers-cluster.tar**

* **DRY Principle:** "Don't Repeat Yourself" (DRY). No need to copy-paste the code 5 times; use a loop.
* **Dynamic Logic:** Use math (`8080 + count.index`) to handle networking automatically.
* **Orchestration:** Its not just managing a container; it is managing a cluster.

 1. `terraform apply -auto-approve`
 2. `docker ps`
 3. `terraform apply -var="container_count=5" -auto-approve`

Verifying each docker/web server:

* `docker ps`
* `docker exec -it 3f067fdfdc08 /bin/bash`
* `curl -I http://localhost:8080`

**Verification:**

```
cat verification.sh
for port in 8080 8081 8082 8083 8084 8085; do
  echo "Testing Port $port..."
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:$port
done
[tanveer@localhost terraformDockerLab]$ sh verification.sh
Testing Port 8080...
200
Testing Port 8081...
200
Testing Port 8082...
200
Testing Port 8083...
200
Testing Port 8084...
200
Testing Port 8085...
000
```
**Possible Issues:**
```
**Firewall:** OL8 is very strict. You might need to open the ports:
sudo firewall-cmd --permanent --add-port=8080-8085/tcp
sudo firewall-cmd --reload

**SELinux:** If the container starts but traffic is blocked, temporarily test by setting SELinux to permissive:
sudo setenforce 0
```
---
