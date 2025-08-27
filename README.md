# gcp-gke-robofleet
RoboFleet Data Platform - real-time robotic telemetry ingestion using Terraform, GKE, Argo CD, Pub/Sub, BigQuery, and Prometheus/Grafana.
#  RoboFleet Data Platform

A portfolio-grade DevOps/Platform Engineer project simulating a **fleet of delivery robots** streaming telemetry into a **cloud-native data platform** on Google Cloud.  
Built to demonstrate **GCP, Kubernetes, Terraform, Argo CD, GitOps, CI/CD, observability, and SRE practices** at scale.

---

## Problem
Robotics and IoT systems generate **bursty, high-volume telemetry** that must be:
- Collected reliably (with backpressure & replay),
- Processed in near real-time,
- Stored for analytics,
- Deployed and operated securely at scale.

---

## Solution
I designed and implemented the **RoboFleet Data Platform**:

- **Robots (simulated)** → Python-based telemetry simulator emits JSON events (GPS, battery, status).  
- **Ingestor (FastAPI on GKE)** → consumes from **Pub/Sub**, validates data, writes to **BigQuery** (hot) and **GCS** (cold).  
- **Control API (FastAPI on GKE)** → manages robot commands (pause/resume).  
- **Infrastructure as Code** → Terraform modules for VPC, GKE, Pub/Sub, BigQuery, Secret Manager.  
- **CI/CD & GitOps** → GitHub Actions (build + Trivy scan + push) + Argo CD (Helm charts, app-of-apps).  
- **Observability & SRE** → Prometheus metrics, Grafana dashboards, SLOs (p95 latency <5s, error rate <0.5%), canary rollouts with auto-rollback.  
- **Security** → Workload Identity, Secret Manager CSI, non-root containers, NetworkPolicies.

---

## Outcome
- Ingested telemetry from **1,000 simulated robots @ ~5 events/sec**.  
- Maintained **p95 ingest latency <5s** with horizontal scaling.  
- Achieved **zero plaintext secrets** — all credentials managed via GCP Secret Manager CSI + Workload Identity.  
- Canary rollout triggered an **automatic rollback** when error rate >0.5%.  
- Produced Grafana dashboards with live ingest rates, Pub/Sub backlog, BigQuery latency.

This mirrors the type of **real-world reliability and scalability challenges** 

---

## 🏗️ Architecture

Robots (simulator)
↓
Google Pub/Sub (topic, subscription)
↓
Ingestor Service (FastAPI on GKE)
↓
BigQuery (analytics) + GCS (cold storage)

**Platform Layer**
- Terraform → provisions infra (GKE, Pub/Sub, BigQuery, Secret Manager)  
- GitHub Actions → CI/CD builds + scans containers  
- Argo CD → GitOps deployment of Helm charts  
- Prometheus/Grafana → observability, SLOs, alerts  

