FROM prom/prometheus

# Install envsubst for environment variable substitution
USER root
RUN apk add --no-cache gettext

# Copy template file instead of final config
COPY prometheus.yml.template /etc/prometheus/prometheus.yml.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the Prometheus server port
EXPOSE 9090

# Use custom entrypoint that processes template
ENTRYPOINT ["/entrypoint.sh"]