# Promtail Setup

This directory contains the configuration for deploying Promtail in your Kubernetes cluster.

## Installation

Promtail is typically installed as part of the Loki stack, but it can also be installed separately:

```bash
helm install promtail grafana/promtail \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml
```

## Configuration

The `values.yaml` file contains the following configurations:
- Promtail server settings
- Log collection settings
- Resource limits and requests
- Kubernetes service discovery
- Log parsing rules

## Architecture

Promtail is deployed as a DaemonSet to ensure it runs on every node in the cluster. It:
- Discovers logs from all pods
- Adds Kubernetes metadata
- Parses and transforms logs
- Sends logs to Loki

## Log Collection

Promtail collects logs from:
- Container logs
- Node logs
- System logs
- Application logs

## Log Processing

Default log processing includes:
- Adding Kubernetes labels
- Parsing JSON logs
- Adding timestamp
- Adding log level
- Adding source information

## Maintenance

### Upgrading

To upgrade Promtail:
```bash
helm upgrade promtail grafana/promtail \
  --namespace monitoring \
  -f values.yaml
```

### Configuration Reload

Promtail automatically reloads configuration when:
- ConfigMap changes
- Pod restarts
- Manual reload via API

## Troubleshooting

Common issues and solutions:

1. Promtail pods not starting:
   - Check resource limits
   - Verify permissions
   - Check logs: `kubectl logs -n monitoring -l app.kubernetes.io/name=promtail`

2. Logs not being collected:
   - Verify pod discovery
   - Check network policies
   - Verify Loki connectivity

3. High resource usage:
   - Adjust scrape intervals
   - Modify batch size
   - Increase resource limits

## LogQL Examples

Example queries using Promtail-collected logs:

1. All logs from a specific container:
```
{container="nginx"}
```

2. Error logs from a specific namespace:
```
{namespace="production"} |= "error"
```

3. Logs with specific label and content:
```
{app="web"} |~ "GET /api/.*"
```

## Integration with Loki

Promtail automatically:
- Discovers pods using Kubernetes API
- Adds Kubernetes metadata
- Sends logs to Loki
- Handles log rotation
- Manages log file positions 