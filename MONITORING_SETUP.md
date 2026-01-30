# 📊 Monitoring with Prometheus & Grafana - Quick Start Guide

## 🎯 Overview

Your GigsHub application is now equipped with a complete monitoring stack using Prometheus and Grafana. This guide will help you access and use the monitoring features.

## 🚀 Quick Start

### 1. Deploy the Application with Monitoring

The GitHub Actions workflow automatically deploys everything when you push to the `main` or `devops` branch:

```bash
git push origin main
```

Or manually trigger the workflow from GitHub Actions UI.

### 2. Access the Services

Once deployed, access the following services:

| Service | URL | Credentials |
|---------|-----|-------------|
| **Frontend** | http://localhost:80 | - |
| **API** | http://localhost:5000 | - |
| **Prometheus** | http://localhost:9090 | - |
| **Grafana** | http://localhost:3000 | admin / admin123 |
| **Node Exporter** | http://localhost:9100/metrics | - |
| **MongoDB Exporter** | http://localhost:9216/metrics | - |

## 📈 Using Grafana

### First Time Setup

1. **Open Grafana**: Navigate to http://localhost:3000
2. **Login**: 
   - Username: `admin`
   - Password: `admin123`
3. **Explore Dashboards**: 
   - Click on the "Dashboards" icon (four squares)
   - Select "GigsHub Dashboard" (if provisioned)

### Creating Your First Dashboard

1. Click the **"+"** icon in the left sidebar
2. Select **"Dashboard"**
3. Click **"Add new panel"**
4. In the query editor, select **"Prometheus"** as the data source
5. Enter a PromQL query (examples below)
6. Click **"Apply"** to save the panel

### Useful PromQL Queries

#### System Metrics
```promql
# CPU Usage
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Disk Usage
100 - ((node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100)
```

#### Application Metrics
```promql
# HTTP Request Rate
rate(http_requests_total[5m])

# HTTP Request Duration (95th percentile)
histogram_quantile(0.95, rate(http_request_duration_ms_bucket[5m]))

# Total HTTP Requests by Status Code
sum by (status) (http_requests_total)

# API Uptime
up{job="gigshub-api"}
```

#### MongoDB Metrics
```promql
# MongoDB Connections
mongodb_connections{state="current"}

# MongoDB Operations per Second
rate(mongodb_op_counters_total[5m])

# MongoDB Network Bytes In/Out
rate(mongodb_network_bytes_total[5m])
```

### Dashboard Examples

#### Quick Dashboard Setup

1. **API Health Dashboard**
   - Panel 1: API Uptime → `up{job="gigshub-api"}`
   - Panel 2: Request Rate → `rate(http_requests_total[5m])`
   - Panel 3: Response Time → `histogram_quantile(0.95, rate(http_request_duration_ms_bucket[5m]))`
   - Panel 4: Error Rate → `rate(http_requests_total{status=~"5.."}[5m])`

2. **System Resources Dashboard**
   - Panel 1: CPU Usage (query above)
   - Panel 2: Memory Usage (query above)
   - Panel 3: Disk Usage (query above)
   - Panel 4: Network Traffic → `rate(node_network_receive_bytes_total[5m])`

## 🔍 Using Prometheus

### Exploring Metrics

1. **Open Prometheus**: Navigate to http://localhost:9090
2. **Query Metrics**: 
   - Click **"Graph"** tab
   - Enter a PromQL query in the expression browser
   - Click **"Execute"**
   - Switch between "Graph" and "Table" views

### Checking Target Status

1. Click **"Status"** → **"Targets"**
2. Verify all targets are **UP**:
   - ✅ prometheus (localhost:9090)
   - ✅ gigshub-api (api:5000)
   - ✅ node-exporter (node-exporter:9100)
   - ✅ mongodb (mongodb-exporter:9216)

### Viewing Available Metrics

1. Click **"Graph"** tab
2. Click the **"Metrics"** dropdown
3. Browse all available metrics
4. Select a metric to see its current values

## 🛠️ Troubleshooting

### Services Not Accessible

```bash
# Check if all containers are running
docker compose ps

# View logs for specific service
docker compose logs prometheus
docker compose logs grafana

# Restart services
docker compose restart prometheus grafana
```

### Prometheus Targets Down

```bash
# Check Prometheus logs
docker compose logs prometheus

# Verify network connectivity
docker exec gigshub-prometheus wget -O- http://api:5000/metrics
docker exec gigshub-prometheus wget -O- http://node-exporter:9100/metrics
```

### Grafana Can't Connect to Prometheus

```bash
# Check Grafana logs
docker compose logs grafana

# Verify Prometheus is accessible from Grafana
docker exec gigshub-grafana wget -O- http://prometheus:9090/api/v1/status/config
```

### Missing Metrics

```bash
# Check if API metrics endpoint is working
curl http://localhost:5000/metrics

# Verify Prometheus is scraping the API
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.job=="gigshub-api")'
```

## 📊 Monitoring Best Practices

### 1. Set Up Alerts

Create alert rules in Prometheus for:
- High error rates (>5% 5xx responses)
- Slow response times (p95 > 1s)
- Service downtime
- High resource usage (CPU > 80%, Memory > 90%)

### 2. Dashboard Organization

- **Overview Dashboard**: High-level metrics (uptime, request rate, errors)
- **API Dashboard**: API-specific metrics (endpoints, response times)
- **Infrastructure Dashboard**: System resources (CPU, memory, disk)
- **Database Dashboard**: MongoDB metrics

### 3. Regular Monitoring

Check these daily:
- Service uptime status
- Error rates and types
- Response time trends
- Resource utilization

## 🔄 GitHub Actions Integration

The workflow automatically:
1. ✅ Deploys all services with Docker Compose
2. ✅ Validates Prometheus configuration
3. ✅ Checks Grafana provisioning
4. ✅ Verifies all service health
5. ✅ Tests Prometheus target connectivity
6. ✅ Validates Grafana datasources
7. ✅ Generates monitoring health report
8. ✅ Provides service endpoint summary

### Workflow Artifacts

After each run, download the **monitoring-report** artifact to see:
- Prometheus configuration status
- Active target count
- Grafana health status
- Detailed system metrics

## 📚 Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Dashboard Best Practices](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/best-practices/)

## 🎓 Next Steps

1. **Import Pre-built Dashboards**:
   - Visit [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
   - Search for "Node Exporter" and "MongoDB"
   - Import dashboards using their IDs

2. **Set Up Alerting**:
   - Configure Prometheus alert rules
   - Set up notification channels in Grafana (Slack, Email, etc.)

3. **Customize Metrics**:
   - Add custom business metrics to your API
   - Create application-specific dashboards

4. **Enable Authentication**:
   - Change default Grafana password
   - Set up user roles and permissions

---

**Questions or Issues?** Check the logs or create an issue in the repository!
