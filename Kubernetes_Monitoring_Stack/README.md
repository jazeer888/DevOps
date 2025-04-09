# Kubernetes Monitoring Stack

This repository contains the configuration and setup instructions for a complete monitoring stack in Kubernetes, including:

- Prometheus for metrics collection
- Grafana for visualization
- Loki for log aggregation
- Promtail for log collection

## Directory Structure

```
.
├── prometheus/          # Prometheus configuration and deployment
├── grafana/            # Grafana configuration and deployment
├── loki/               # Loki configuration and deployment
└── promtail/           # Promtail configuration and deployment
```

## Prerequisites

- Kubernetes cluster (1.16+)
- Helm 3.x
- kubectl configured to communicate with your cluster
- Storage class for persistent volumes

## Quick Start

1. Add the required Helm repositories:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
```

2. Update Helm repositories:
```bash
helm repo update
```

3. Follow the installation instructions in each component's directory:
- [Prometheus Setup](prometheus/README.md)
- [Grafana Setup](grafana/README.md)
- [Loki Setup](loki/README.md)
- [Promtail Setup](promtail/README.md)

## Architecture

The monitoring stack consists of the following components:

- **Prometheus**: Collects and stores metrics from various sources
- **Grafana**: Provides visualization and dashboarding capabilities
- **Loki**: Log aggregation system
- **Promtail**: Log collection agent that sends logs to Loki

## Accessing the Services

After installation, you can access the services through:

- Grafana: http://localhost:3000 (after port-forwarding)
- Prometheus: http://localhost:9090 (after port-forwarding)

## Maintenance

For maintenance instructions and troubleshooting, please refer to the README files in each component's directory.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 