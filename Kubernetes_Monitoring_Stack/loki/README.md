# Loki Setup

This directory contains the configuration for deploying Loki in your Kubernetes cluster.

## Installation

1. Install Loki using Helm:
```bash
helm install loki grafana/loki-stack \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml
```

## Configuration

The `values.yaml` file contains the following configurations:
- Loki server settings
- Storage configuration
- Resource limits and requests
- Security settings
- Retention policies

## Architecture

Loki is deployed with the following components:
- Loki: Log aggregation system
- Promtail: Log collection agent
- Grafana: Visualization (optional, can use existing Grafana)

## Accessing Loki

Loki is accessible within the cluster at:
- HTTP API: http://loki:3100
- gRPC: loki:9096

## Storage

Loki data is stored in a PersistentVolume. The default storage size is 10Gi.

## Log Retention

Default retention periods:
- Logs: 7 days
- Metrics: 24 hours

## Maintenance

### Upgrading

To upgrade Loki:
```bash
helm upgrade loki grafana/loki-stack \
  --namespace monitoring \
  -f values.yaml
```

### Backup and Restore

1. Backup Loki data:
```bash
kubectl exec -n monitoring deploy/loki -- tar czf /tmp/backup.tar.gz /loki
kubectl cp monitoring/loki:/tmp/backup.tar.gz ./loki-backup.tar.gz
```

2. Restore Loki data:
```bash
kubectl cp ./loki-backup.tar.gz monitoring/loki:/tmp/backup.tar.gz
kubectl exec -n monitoring deploy/loki -- tar xzf /tmp/backup.tar.gz -C /
```

## Log Queries

Example LogQL queries:

1. All logs from a specific namespace:
```
{namespace="monitoring"}
```

2. Error logs from a specific pod:
```
{namespace="monitoring", pod="loki-0"} |= "error"
```

3. Logs with specific label:
```
{job="kubernetes-pods"} |= "error" | json
```

## Troubleshooting

Common issues and solutions:

1. Loki pods not starting:
   - Check PVC status
   - Verify resource limits
   - Check logs: `kubectl logs -n monitoring deploy/loki`

2. Logs not being collected:
   - Verify Promtail configuration
   - Check network policies
   - Verify service endpoints

3. High memory usage:
   - Adjust retention period
   - Modify chunk size
   - Increase resource limits

## Integration with Grafana

Loki is automatically configured as a data source in Grafana. You can access logs through:
1. Explore view
2. Logs panel in dashboards
3. LogQL queries 