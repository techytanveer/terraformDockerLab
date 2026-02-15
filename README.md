# terraformDockerLab 🚀

A professional demonstration of **Infrastructure-as-Code (IaC)** using **Terraform** to orchestrate containerized environments on **Oracle Linux 8**.

## 🎯 Overview
This project automates the deployment of a localized <span style="color:green">web server cluster</span>. Instead of manual Docker commands, this lab uses Terraform to manage the lifecycle of the infrastructure, ensuring consistency and scalability.

It showcases:

* **Infrastructure as Code (IaC):** Full lifecycle management of Docker resources.
* **Scalability:** Using Terraform `count` to scale backend services instantly.
* **Networking:** Custom Docker bridge networks for service isolation.


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

## 🐳 Working with Dockers

```
docker ps -aq >>> listing running docker containers

docker exec -it 9edcf967fa9d /bin/bash >>> connecting console via container ID

docker exec -it server-1 /bin/bash >>> connecting console via container name

docker stop 9edcf967fa9d >>> stopping via container ID

docker rm 9edcf967fa9d >>> removing via container ID
```
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
## 🔃 Change Management

**1 - single-container-first-stable.tar**

The original code.

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
>>> Firewall: OL8 is very strict. You might need to open the ports:
sudo firewall-cmd --permanent --add-port=8080-8085/tcp
sudo firewall-cmd --reload

>>> SELinux: If the container starts but traffic is blocked, temporarily test by setting SELinux to permissive:
sudo setenforce 0
```
**3 - change-surviving-env.tar**

* `terraform apply -auto-approve`
* `sudo systemctl restart docker`
* `docker ps`

**4 - on-the-fly-for_each-method.tar**

In Terraform, `count` creates an ordered list. If we change something that shifts the "index" or how the list is calculated, Terraform often recreates the whole set to keep the list in order. The problem before this change was that the terraform keeps the `count` logic inside its "memory" (the .tfstate file), we call that **Basic Automation**. When we try to add a new container, terraform destroys all the existing Docker containers and do **replace** to match the count index. 

To get the "surgical" precision we want — where we add one container and the others don't even blink — we must switch from `count` to `for_each`.

With `for_each`, Terraform treats each container as a **unique ID**, not just a number in a list. If we add "Container-6," Terraform sees it as a brand new independent item and doesn't touch Containers 1 through 5.

Also, we need to tell Terraform to expect (and accept) the `bridge` network mode so it stops trying to "null" it out, to stop the replacements.

**One-Time Cleanup - Manually stop containers**
```
docker stop $(docker ps -q)
docker rm $(docker ps -aq)

rm terraform.tfstate terraform.tfstate.backup
```
**Apply the change**
```
terraform apply -auto-approve

docker ps

Add next server '"server-5" = { port = 8084 }' in variable.tf

terraform plan >>> Verify the config 'Plan: 1 to add, 0 to change, 0 to destroy'

terraform apply -target='docker_container.web_server["server-5"]'

docker ps

terraform destroy -target='docker_container.web_server["server-5"]'
```
---
