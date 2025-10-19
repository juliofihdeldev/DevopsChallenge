# **Senior Backend Developer Challenge**

**Tech Stack:** Node.js + TypeScript + ORM (Prisma or Sequelize) + PostgreSQL

**Bonus:** Docker, Kubernetes, Monitoring

---

## **🎯 Objective**

Design, implement, and document a **Team Expense Tracker API** that demonstrates your ability to build a scalable, well-structured backend system — from data modeling to deployment.

You will:

-   Design relational data models
-   Implement business logic using Node.js
-   Use an ORM for database interaction
-   Containerize the app (Docker)
-   Prepare a deployment plan for Kubernetes
-   Optionally add observability and CI/CD

## **🏗️ Requirements**

### **1. Core Features**

### **👤 Authentication**

-   User registration and login using JWT or session tokens.
-   Secure password storage (hashing).

### **👥 Team Management**

-   Create a team.
-   Add or remove members from a team.
-   A user can belong to multiple teams.

### **💸 Expense Tracking**

-   Add an expense (amount, payer, participants, description).
-   Retrieve all expenses for a team.
-   Calculate each member’s **balance** within a team.

---

### **2. Database**

-   Use PostgreSQL.
-   Use Prisma, Sequelize, or TypeORM for ORM.
-   Implement migration scripts.
-   Include seed data (optional but preferred).

---

### **3. API Design**

-   REST or GraphQL (your choice).
-   Clear and consistent endpoints.
-   Input validation and proper error handling.
-   Pagination on list endpoints.
-   Follow clean code architecture (e.g., controllers → services → repositories).

---

### **4. DevOps Requirements**

### **🐳 Docker**

-   Provide a Dockerfile and docker-compose.yml that can start:
    -   The API service
    -   The PostgreSQL service
-   App should run with one command:

```
docker-compose up --build
```

### **☸️ Kubernetes (Deployment Plan)**

-   Provide YAML files under /k8s:
    -   deployment.yaml for the API
    -   service.yaml for the API
    -   postgres-deployment.yaml for the DB
    -   configmap.yaml and secret.yaml for environment configs
-   Document how to deploy to a local cluster (minikube, kind, or similar).

### **📊 Monitoring (Bonus)**

-   Describe or implement:
    -   Prometheus metrics endpoint (/metrics)
    -   Log collection strategy (e.g., Winston, pino, or structured logs)
    -   Optional: dashboard setup with Grafana or OpenTelemetry

### **🚀 CI/CD (Bonus)**

-   Add a GitHub Actions workflow to:
    -   Run tests
    -   Build Docker image
    -   Lint code

---

### **5.Documentation**

Include a README.md with:

-   Tech stack used
-   Setup instructions (local & Docker)
-   API endpoint list
-   Environment variables required
-   Deployment guide (Kubernetes)
-   Bonus explanation (if implemented)
