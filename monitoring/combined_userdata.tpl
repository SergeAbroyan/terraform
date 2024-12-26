#!/bin/bash
set -e
set -x

# Run Prometheus setup
${prometheus_userdata}

# Run Grafana setup
${grafana_userdata}

echo "Setup completed successfully!"
