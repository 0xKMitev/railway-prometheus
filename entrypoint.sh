#!/bin/sh

# Generate prometheus.yml from environment variables
cat > /etc/prometheus/prometheus.yml << EOF
global:
  scrape_interval: 15s

remote_write:
  - url: "${BETTERSTACK_PROMETHEUS_URL}"
    authorization:
      type: Bearer
      credentials: "${BETTERSTACK_TOKEN}"
    queue_config:
      max_samples_per_send: 1000
      batch_send_deadline: 5s

scrape_configs:
  - job_name: 'spring-boot-app'
    static_configs:
      - targets: ['${APP_TARGET}']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s
EOF

# Start Prometheus with your original parameters
exec /bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --storage.tsdb.retention.time=365d \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles \
  --web.external-url=http://localhost:9090 \
  --log.level=info