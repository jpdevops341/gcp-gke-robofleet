# gcp-gke-robofleet

RoboFleet Data Platform — a portfolio project that shows how a fleet of delivery robots could stream telemetry into a data platform on Google Cloud.  

This repo is my way of pulling together skills in **GCP, Kubernetes, Terraform, Argo CD, GitOps, CI/CD, and observability** into something robotics-flavored (similar to what Serve Robotics actually works on).

---

## Problem

Robotics and IoT systems don’t send data in neat, predictable bursts. They’re messy:
- sometimes you get floods of telemetry (GPS, battery, status),
- sometimes nothing,
- and the data still needs to be collected, validated, and stored quickly.

The key challenges:
- **Reliability** → no data drops, handle backpressure/replay.  
- **Real-time** → process as events come in.  
- **Analytics** → store hot and cold paths for later analysis.  
- **Scale & security** → needs to run safely across lots of robots.  

---

## Solution

Here’s how I tackled it:

- **Robots (simulated)** → Python script that pretends to be 1000 robots, publishing JSON (GPS, battery, status).  
- **Ingestor (FastAPI on GKE)** → pulls messages off Pub/Sub, validates them, writes into **BigQuery** (hot) and **GCS** (cold).  
- **Control API (FastAPI)** → simple service that lets you send “pause/resume” commands to the fleet.  
- **Infra as Code** → Terraform modules for VPC, GKE, Pub/Sub, BigQuery, Secret Manager.  
- **CI/CD & GitOps** → GitHub Actions builds + scans images, Argo CD deploys Helm charts (app-of-apps).  
- **Observability** → Prometheus + Grafana dashboards, with SLOs (p95 ingest latency <5s, error rate <0.5%).  
- **Resilience** → Argo Rollouts handles canaries, auto-rollback if error budget is blown.  
- **Security** → Workload Identity, Secret Manager CSI, non-root containers, NetworkPolicies.  

---

## Outcome

- Telemetry successfully ingested from **1,000 simulated robots** (~5 events/sec).  
- **p95 ingest latency under 5s** while scaling horizontally.  
- **Zero plaintext secrets** — everything lives in Secret Manager via CSI + WI.  
- Canary rollout **auto-rolled back** when error rate >0.5%.  
- Grafana dashboards show ingest rates, Pub/Sub backlog, and BigQuery latency.  

Basically: the kind of reliability + scalability problems you’d expect when running a real robot fleet, but on a smaller scale.

---

## Architecture

```text
Robots (simulator) 
   ↓ 
Google Pub/Sub (topic, subscription) 
   ↓ 
Ingestor (FastAPI on GKE) 
   ↓ 
BigQuery (analytics) + GCS (cold storage)

Platform Layer
- Terraform → provisions infra (GKE, Pub/Sub, BigQuery, Secret Manager)
- GitHub Actions → CI/CD builds + security scans
- Argo CD → GitOps deploys Helm charts
- Prometheus/Grafana → observability, SLOs, alerts

##  Quickstart

# 1. Provision infra with Terraform
cd infra/terraform/envs/dev
cp terraform.tfvars.example terraform.tfvars   # set your project + region
terraform init
terraform apply -var-file="terraform.tfvars"

# 2. Build and push container images
make build push
# (by default pushes to gcr.io/<your-project>, adjust if needed)

# 3. Deploy workloads with Argo CD
kubectl apply -n argocd -f charts/app-of-apps/argo-apps.yaml

# 4. Run the robot simulator (1000 robots, 5 events/sec)
pip install -r simulators/robot/requirements.txt
python simulators/robot/publisher.py \
  --project <your-gcp-project> \
  --topic robofleet-telemetry \
  --robots 1000 \
  --rate 5

# 5. Check the system
# - Grafana dashboards: ingest rate, Pub/Sub backlog, BigQuery latency
# - Prometheus alerts: error rate >0.5%, ack age >30s
# - Argo Rollouts: canary rollout + auto-rollback if SLOs are missed
