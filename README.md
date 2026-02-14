# sample-nodejs-app

This is a production-ready Node.js application featuring built-in Prometheus instrumentation and a fully automated CI/CD lifecycle.

## Project Ecosystem

This project is part of a **3-repository GitOps architecture** designed to separate application logic, infrastructure, and deployment configurations:

1.  **Application Repo (This one)**: Source code, Dockerfile, and GitHub Actions CI workflow.
2.  **[GitOps Repo (node-js-sample-k8s)](https://github.com/liormilliger/node-js-sample-k8s.git)**: Helm charts (ArgoCD), ServiceMonitors, and Grafana Dashboard-as-Code.
3.  **Infrastructure Repo**: Terraform code for EKS, VPC, and AWS resource provisioning.

### System Architecture
![System Architecture](./system-architecture.png)

---

# DevOps Sample Node.js App

## Overview

A lightweight Node.js application. It features basic web endpoints, Prometheus metrics integration, and is designed for Kubernetes deployment and CI/CD pipeline demonstrations.

## Features

- Express.js web server
- Prometheus metrics integration
- Readiness and liveness probe endpoints
- Customizable port via environment variable

## Prerequisites

- Node.js (v22.1.0)

---

## CI/CD Workflow

The CI/CD pipeline, defined in `.github/workflows/ci.yaml`, automates the entire "Commit to Cluster" flow:

### 1. Build & Versioning
* **Dynamic Tagging**: Extracts the version from `package.json` and appends the GitHub Run Number (e.g., `1.0.0-build-5`).
* **Multi-Tagging**: Builds and pushes images to **Amazon ECR** with both the unique build tag and the `latest` tag.

### 2. Security & Quality Gates
* **SAST**: Runs `npm audit` to catch high-level vulnerabilities in dependencies.
* **Container Scanning**: Uses **Trivy** to scan the final Docker image for OS-level vulnerabilities.
* **Enforcement**: The pipeline fails if `CRITICAL` or `HIGH` vulnerabilities are found.

### 3. GitOps Integration (The "Write-Back")
* **Automated Sync**: Upon a successful push to ECR, the workflow clones the **GitOps Repo** using a `K8S_REPO_PAT`.
* **Manifest Update**: Uses `sed` to update the `image.tag` inside `my-app-chart/values.yaml` with the new versioned tag.
* **ArgoCD Trigger**: This commit triggers **ArgoCD** to automatically detect the change and perform a rolling update on the EKS cluster.

---

## Observability & Metrics

The application exposes a `/metrics` endpoint on port `8080` for Prometheus scraping.

* **Custom Metrics**: `root_access_total` tracks total hits to the application.
* **Runtime Metrics**: Full visibility into Node.js event loop lag, heap memory usage, and garbage collection duration.
* **Grafana**: Dashboards are automatically provisioned via ConfigMaps in the GitOps repository using the Grafana Sidecar pattern.

