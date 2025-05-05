# DockerNinja - Debugging Docker Image

A lightweight Docker image containing essential debugging and troubleshooting tools, based on Alpine Linux.

## Project Structure

```
DockerNinja/
├── Dockerfile          # Main Dockerfile for the debug image
└── README.md          # This documentation file
```

## Features

- Minimal base image (Alpine Linux 3.19)
- Comprehensive set of debugging tools
- Optimized for size and performance
- Ready for Kubernetes ephemeral containers

## Included Tools

### Basic Tools
- `bash` - Interactive shell
- `curl` - HTTP client
- `wget` - File download utility
- `vim`/`nano` - Text editors

### Network Tools
- `net-tools` - Network utilities (netstat, ifconfig)
- `iputils` - Network testing tools (ping, traceroute)
- `tcpdump` - Packet capture
- `nmap` - Network scanning

### Process Monitoring
- `procps` - Process utilities (ps, top)
- `htop` - Interactive process viewer

### System Tools
- `strace` - System call tracer
- `lsof` - List open files
- `gdb` - Debugger

### Development Tools
- `git` - Version control
- `make`, `gcc`, `musl-dev` - Compilation tools

### Container Tools
- `docker-cli` - Docker command-line interface

### Security Tools
- `openssl` - SSL/TLS tools
- `ca-certificates` - SSL certificates

## Optional Additions

The Dockerfile includes commented sections for additional environments:

```dockerfile
# Optional: Uncomment to add a Python 3 environment
# RUN apk --no-cache add python3 py3-pip

# Optional: Uncomment to add Node.js (includes npm)
# RUN apk --no-cache add nodejs npm
```

## Build and Usage

### Building the Image
```bash
# Navigate to the project directory
cd DockerNinja

# Build the image
docker build -t dockerninja .
```

### Running the Container
```bash
docker run -it --rm dockerninja
```

## Kubernetes Integration

### Using as Ephemeral Container
```bash
kubectl debug -it <pod> --image=dockerninja --target=<app-container>
```

### Node Debugging
```bash
kubectl debug node/<node> -it --image=dockerninja
```

## Best Practices

### Image Optimization
- Single layer for package installation
- No-cache flag to reduce image size
- Alphabetically sorted packages for maintainability

### Security Considerations
- Runs as root by default for full inspection rights
- Network sniffing (tcpdump) and strace require additional capabilities
- In Kubernetes, use `privileged: true` or add specific capabilities

### Kubernetes Tips
- Enable `shareProcessNamespace` for process inspection
- Ephemeral containers are temporary and won't persist state
- Use appropriate privileges for network tracing and system inspection

## Package Management

All packages are installed from Alpine's default repositories (main). The image is kept lean by:
- Using `--no-cache` flag to prevent APK index caching
- Installing only necessary packages
- Combining commands to minimize layers

## Multi-stage Builds

For complex debugging scenarios, consider using multi-stage builds:
1. Build stage for compilation
2. Final stage with only necessary artifacts

## Troubleshooting

Common debugging commands available:
- Network: `ip`, `ifconfig`, `nc`, `ping`
- Process: `ps`, `top`, `htop`
- System: `strace`, `lsof`
- Network analysis: `tcpdump`, `nmap`

## Notes

- Ephemeral containers are temporary and won't restart
- Changes made in ephemeral containers are discarded with the pod
- Consider security implications when using privileged containers 