# Prometheus Setup

This directory contains the configuration for deploying Prometheus in your Kubernetes cluster.

## Installation

1. Create a namespace for Prometheus:
```bash
kubectl create namespace monitoring
```

2. Install Prometheus using Helm:
```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml
```

## Configuration

The `values.yaml` file contains the following configurations:

- Prometheus server settings
- AlertManager configuration
- ServiceMonitor configurations
- Resource limits and requests
- Storage configuration
- Security settings

## Accessing Prometheus

1. Port-forward the Prometheus service:
```bash
kubectl port-forward -n monitoring svc/prometheus-server 9090:9090
```

2. Access the Prometheus UI at http://localhost:9090

## Default Dashboards

The following dashboards are included by default:
- Kubernetes Cluster Monitoring
- Node Exporter
- Kubernetes Pod Monitoring
- Kubernetes Resource Usage

## Alerting Rules

Default alerting rules are configured for:
- High CPU Usage
- High Memory Usage
- Pod Restarts
- Node Status
- Disk Space Usage

## Storage

Prometheus data is stored in a PersistentVolume. The default storage size is 8Gi.

## Maintenance

### Upgrading

To upgrade Prometheus:
```bash
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values.yaml
```

### Backup and Restore

1. Backup Prometheus data:
```bash
kubectl exec -n monitoring deploy/prometheus-server -- tar czf /tmp/backup.tar.gz /prometheus
kubectl cp monitoring/prometheus-server:/tmp/backup.tar.gz ./prometheus-backup.tar.gz
```

2. Restore Prometheus data:
```bash
kubectl cp ./prometheus-backup.tar.gz monitoring/prometheus-server:/tmp/backup.tar.gz
kubectl exec -n monitoring deploy/prometheus-server -- tar xzf /tmp/backup.tar.gz -C /
```

## Troubleshooting

Common issues and solutions:

1. Prometheus pods not starting:
   - Check PVC status
   - Verify resource limits
   - Check logs: `kubectl logs -n monitoring deploy/prometheus-server`

2. Targets not being scraped:
   - Verify ServiceMonitor configurations
   - Check network policies
   - Verify service endpoints

3. High memory usage:
   - Adjust retention period
   - Modify scrape intervals
   - Increase resource limits 