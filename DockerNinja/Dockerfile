FROM alpine:3.19

# Install essential debugging and troubleshooting tools
RUN apk add --no-cache \
    # Basic tools
    bash \
    curl \
    wget \
    vim \
    nano \
    # Network tools
    net-tools \
    iputils \
    tcpdump \
    nmap \
    # Process monitoring
    procps \
    htop \
    # System tools
    strace \
    lsof \
    # Development tools
    git \
    make \
    gcc \
    musl-dev \
    # Container tools
    docker-cli \
    # Debugging tools
    gdb \
    # Logging tools
    logrotate \
    # Security tools
    openssl \
    ca-certificates

# Optional: Uncomment to add a Python 3 environment
# RUN apk --no-cache add python3 py3-pip

# Optional: Uncomment to add Node.js (includes npm)
# RUN apk --no-cache add nodejs npm

# Set working directory
WORKDIR /app

# Default command
CMD ["/bin/bash"] 