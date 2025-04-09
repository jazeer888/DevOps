# Grafana Setup

This directory contains the configuration for deploying Grafana in your Kubernetes cluster.

## Installation

1. Install Grafana using Helm:
```bash
helm install grafana grafana/grafana \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml
```

## Configuration

The `values.yaml` file contains the following configurations:
- Grafana server settings
- Data source configurations (Prometheus and Loki)
- Dashboard configurations
- Resource limits and requests
- Storage configuration
- Security settings

## Accessing Grafana

1. Get the admin password:
```bash
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

2. Port-forward the Grafana service:
```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

3. Access the Grafana UI at http://localhost:3000
   - Username: admin
   - Password: (from step 1)

## Default Dashboards

The following dashboards are included by default:
- Kubernetes Cluster Overview
- Node Exporter
- Kubernetes Pod Monitoring
- Loki Logs

## Data Sources

The following data sources are pre-configured:
- Prometheus (http://prometheus-server:9090)
- Loki (http://loki:3100)

## Storage

Grafana data is stored in a PersistentVolume. The default storage size is 5Gi.

## Maintenance

### Upgrading

To upgrade Grafana:
```bash
helm upgrade grafana grafana/grafana \
  --namespace monitoring \
  -f values.yaml
```

### Backup and Restore

1. Backup Grafana data:
```bash
kubectl exec -n monitoring deploy/grafana -- tar czf /tmp/backup.tar.gz /var/lib/grafana
kubectl cp monitoring/grafana:/tmp/backup.tar.gz ./grafana-backup.tar.gz
```

2. Restore Grafana data:
```bash
kubectl cp ./grafana-backup.tar.gz monitoring/grafana:/tmp/backup.tar.gz
kubectl exec -n monitoring deploy/grafana -- tar xzf /tmp/backup.tar.gz -C /
```

## Troubleshooting

Common issues and solutions:

1. Grafana pods not starting:
   - Check PVC status
   - Verify resource limits
   - Check logs: `kubectl logs -n monitoring deploy/grafana`

2. Data sources not connecting:
   - Verify service names and ports
   - Check network policies
   - Verify credentials

3. Dashboards not loading:
   - Check Prometheus/Loki connectivity
   - Verify dashboard JSON
   - Check permissions 