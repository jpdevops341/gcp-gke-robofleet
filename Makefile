REGISTRY ?= gcr.io/$(shell gcloud config get-value project 2>/dev/null)
TAG ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo dev)

build:
	docker build -t $(REGISTRY)/robofleet/ingestor:$(TAG) apps/ingestor
	docker build -t $(REGISTRY)/robofleet/control-api:$(TAG) apps/control-api

push:
	docker push $(REGISTRY)/robofleet/ingestor:$(TAG)
	docker push $(REGISTRY)/robofleet/control-api:$(TAG)

publish: build push

smoke:
	kubectl -n robofleet port-forward svc/ingestor 8080:80 & sleep 2 && curl -s localhost:8080/health || true
	kubectl -n robofleet port-forward svc/control-api 8081:80 & sleep 2 && curl -s localhost:8081/health || true

tf-plan:
	cd infra/terraform/envs/dev && terraform plan -var-file=terraform.tfvars

tf-apply:
	cd infra/terraform/envs/dev && terraform apply -auto-approve -var-file=terraform.tfvars
