# 🚀 DevOps Capstone II — Automated CI/CD Pipeline with Kubernetes

<div align="center">

![DevOps](https://img.shields.io/badge/DevOps-Lifecycle-blue?style=for-the-badge)
![Jenkins](https://img.shields.io/badge/Jenkins-Pipeline-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Configuration-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

**A fully automated DevOps lifecycle implementing CI/CD, container orchestration, configuration management, and Infrastructure as Code.**

</div>

---

## 🌐 Live Demo

**🔗 Live Application:**

Experience the deployed application built through our automated CI/CD pipeline!

[![Visit Live Demo](https://img.shields.io/badge/🌐_Visit-Live_Demo-success?style=for-the-badge)](https://himanshu2604.github.io/code-to-cluster/)

---

## 📋 Table of Contents

<details>
<summary>Click to expand</summary>

- [Project Overview](#-Project-Overview)
- [Architecture](#-Architecture)
- [Tech Stack](#-Tech-Stack)
- [Project Structure](#-Project-Structure)
- [Prerequisites](#-Prerequisites)
- [Implementation](#-Implementation)
  - [Step 1: Git Workflow](#Step-1-Git-Workflow)
  - [Step 2: Dockerfile](#Step-2-Dockerfile)
  - [Step 3: Jenkins Pipeline](#Step-3-Jenkins-Pipeline)
  - [Step 4: Kubernetes Deployment](#Step-4-Kubernetes-Deployment)
  - [Step 5: Ansible Configuration](#Step-5-Ansible-Configuration)
  - [Step 6: Terraform Infrastructure](#Step-6-Terraform-Infrastructure)
- [Pipeline Flow](#-Pipeline-Flow)
- [Key Features](#-Key-Features)
- [Outcomes & Learnings](#-Outcomes--Learnings)

</details>

---

## 📌 Project Overview

**Analytics Pvt Ltd** is a product-based organization that saw explosive growth after its initial launch. This project implements a complete **DevOps lifecycle** to handle that growth — automating deployment, enabling scaling, and eliminating manual operations.

| | Before | After |
|---|---|---|
| **Deployment** | Manual SSH + copy files | Fully automated via Jenkins |
| **Scaling** | Single server | 2+ Kubernetes replicas |
| **Consistency** | "Works on my machine" | Docker containers — identical everywhere |
| **Infrastructure** | Manually clicked in AWS | Terraform IaC — repeatable & versioned |
| **Server Config** | Manual SSH per server | Ansible — one command, all servers |

---

## 🏗 Architecture

<img width="3355" height="1740" alt="diagram-export-3-5-2026-11_54_31-AM" src="https://github.com/user-attachments/assets/7968ddac-cbe6-4856-a2ab-51422103cfa8" />


### Server Role Breakdown

| Machine | Role | Software |
|---|---|---|
| **Worker 1** | Jenkins Master / Controller | Jenkins, Java |
| **Worker 2** | Kubernetes Worker Node | Docker, Kubernetes |
| **Worker 3** | Kubernetes Master Node | Java, Docker, Kubernetes |
| **Worker 4** | Kubernetes Worker Node | Docker, Kubernetes |

---

## 🛠 Tech Stack

| Tool | Purpose | Version |
|---|---|---|
| **Git** | Version control & branching strategy | Latest |
| **Jenkins** | CI/CD automation & pipeline orchestration | LTS |
| **Docker** | Application containerization | Latest |
| **Docker Hub** | Container image registry | Cloud |
| **Kubernetes** | Container orchestration & scaling | Latest |
| **Ansible** | Configuration management | Latest |
| **Terraform** | Infrastructure as Code (AWS) | Latest |
| **AWS EC2** | Cloud compute instances | - |

---

## 📁 Project Structure

```
📦 code-to-cluster/
├── 📄 Dockerfile                    # Container image definition
├── 📄 Jenkinsfile                   # CI/CD pipeline script
├── 📄 index.html                    # Website source
│
├── 📂 k8s/
│   ├── 📄 k8s-deployment.yaml      # Kubernetes Deployment (2 replicas)
│   └── 📄 k8s-service.yaml         # NodePort Service (port 30008)
│
├── 📂 ansible/
│   ├── 📄 inventory.ini            # Server inventory
│   └── 📄 playbook.yml             # Configuration playbook
│
└── 📂 terraform/
    ├── 📄 main.tf                   # AWS resource definitions
    ├── 📄 variables.tf              # Input variables
    └── 📄 outputs.tf                # Output values (IPs etc.)
```

---

## ✅ Prerequisites

- Docker Desktop with Kubernetes enabled
- Jenkins (running locally or on server)
- WSL2 with Ubuntu (for Ansible on Windows)
- Terraform installed
- AWS CLI configured (`aws configure`)
- Docker Hub account
- Git

---

## 🔧 Implementation

### Step 1: Git Workflow

A **trunk-based branching strategy** with monthly releases:

```bash
# Clone the base project
git clone https://github.com/himanshu2604/code-to-cluster.git
cd website

# Create working branches
git checkout -b develop     # daily development
git checkout -b release     # staging — merged on the 25th
# master = production — triggers Jenkins on push
```

**Branch Strategy:**

```
develop ──(daily commits)──► release ──(25th of month)──► master
                                                              │
                                                    Jenkins pipeline triggers
```

---

### Step 2: Dockerfile

```dockerfile
FROM ubuntu
RUN apt-get update && apt-get install -y apache2
COPY . /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
```

```bash
# Build and test locally
docker build -t himanshunehete/website:latest .
docker run -d -p 8085:80 himanshunehete/website:latest
# Visit: http://localhost:8085
```

---

### Step 3: Jenkins Pipeline

The `Jenkinsfile` defines the full automation pipeline:

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "himanshunehete/code-to-cluster"
        DOCKER_TAG   = "latest"
        REGISTRY_CREDENTIALS = "dockerhub-credentials"
        KUBECONFIG = "C:\\ProgramData\\Jenkins\\.jenkins\\.kube\\config"

    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/himanshu2604/code-to-cluster.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', REGISTRY_CREDENTIALS) {
                        dockerImage.push("${DOCKER_TAG}")
                        dockerImage.push("build-${BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f k8s/k8s-deployment.yaml'
                bat 'kubectl apply -f k8s/k8s-service.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                bat 'kubectl rollout status deployment/website-deployment'
                bat 'kubectl get pods'
                bat 'kubectl get svc website-service'
            }
        }
    }

    post {
        success { echo '✅ Deployment Successful!' }
        failure { echo '❌ Pipeline Failed. Check logs.' }
    }
}
```

---

### Step 4: Kubernetes Deployment

**Deployment — 2 Replicas:**

```yaml
# k8s/k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: website-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: website
  template:
    metadata:
      labels:
        app: website
    spec:
      containers:
      - name: website
        image: himanshunehete/code-to-cluster:latest
        ports:
        - containerPort: 80
```

**LoadBalancer Service — Port 8085:**

```yaml
# k8s/k8s-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: website-service
spec:
  type: LoadBalancer
  selector:
    app: website
  ports:
  - protocol: TCP
    port: 8085
    targetPort: 80
    nodePort: 30008
```

```bash
# Apply and verify
kubectl apply -f k8s/k8s-deployment.yaml
kubectl apply -f k8s/k8s-service.yaml
kubectl get pods
kubectl get svc

# Access the website
# http://localhost:8085
```

---

### Step 5: Ansible Configuration

Automatically installs required software on all servers:

```yaml
# ansible/playbook.yml
---
- hosts: worker1          # Jenkins + Java
  become: yes
  tasks:
    - name: Install Java
      apt: { name: openjdk-11-jdk, state: present, update_cache: yes }

    - name: Add Jenkins repo & Install
      # ... (see full playbook in repo)

- hosts: worker2, worker4  # Docker + Kubernetes
  become: yes
  tasks:
    - name: Install Docker
      apt: { name: docker.io, state: present }

- hosts: worker3           # Java + Docker + Kubernetes (K8s Master)
  become: yes
  tasks:
    - name: Install Java + Docker + kubectl
      # ... (see full playbook in repo)
```

```bash
# Run from WSL2 Ubuntu
cd ansible/
ansible-playbook -i inventory.ini playbook.yml
```

---

### Step 6: Terraform Infrastructure

Provisions 4 EC2 instances on AWS with a single command:

```hcl
# terraform/main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "worker1" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  tags          = { Name = "Worker1-Jenkins" }
}

resource "aws_instance" "worker2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  tags          = { Name = "Worker2-K8s-Worker" }
}

# ... worker3 (K8s Master), worker4 (K8s Worker)

resource "aws_security_group" "devops_sg" {
  # Opens ports: 22 (SSH), 8080 (Jenkins), 30008 (NodePort)
}
```

```powershell
# Run in PowerShell
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve

# When done (avoid AWS charges)
terraform destroy
```

---

## 🔄 Pipeline Flow

```
1. 👨‍💻  Developer pushes code to master branch
          │
2. 🔔  GitHub webhook notifies Jenkins
          │
3. ⚙️   Jenkins pipeline starts automatically
          │
4. 📥  Stage: Clone — latest code pulled
          │
5. 🐳  Stage: Build — Docker image created from Dockerfile
          │
6. ☁️   Stage: Push — image uploaded to Docker Hub
          │
7. ☸️   Stage: Deploy — kubectl applies K8s manifests
          │
8. ✅  Stage: Verify — rollout status confirmed
          │
9. 🌐  Website live at http://server-ip:30008
         (2 replicas running, zero downtime)
```

---

## ⭐ Key Features

- **Zero-touch deployment** — push code, everything else is automatic
- **Zero downtime releases** — Kubernetes rolling updates with 2 replicas
- **Environment parity** — Docker ensures dev = test = production
- **Infrastructure as Code** — entire AWS setup recreatable in minutes
- **Idempotent configuration** — Ansible can be re-run safely anytime
- **Monthly release cadence** — Git branching enforces controlled releases
- **Build history** — every Docker image tagged with Jenkins build number

---

## 📚 Outcomes & Learnings

Through this project, the following was implemented end-to-end:

- Designed and implemented a **Git branching strategy** for a team with monthly release cycles
- Built a **Jenkins CI/CD pipeline** triggered automatically via GitHub webhooks
- Created a **custom Docker image** and managed it via Docker Hub registry
- Deployed a **Kubernetes cluster** with 2 replicas and a NodePort service
- Wrote an **Ansible playbook** to configure 4 servers with different software stacks
- Provisioned **AWS EC2 infrastructure** using Terraform from scratch
- Connected all tools into a **single automated DevOps lifecycle**

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Himanshu Nitin Nehete**
- GitHub: [Himasnhu2604](https://github.com/himanshu2604)
- LinkedIn: [Himanshu Nehete](www.linkedin.com/in/himanshu-nehete)
- Email: himanshunehete2025@gmail.com

---

<div align="center">

**Built as part of Intellipaat DevOps Certification Training — Capstone Project II**

⭐ Star this repo if you found it helpful!

**Built with ❤️ using DevOps best practices**

[Report Bug](https://github.com/himanshu2604/code-to-cluster/issues) • [Request Feature](https://github.com/himanshu2604/code-to-cluster/issues)

</div>
