# 🎯 Monitoring Quick Reference Card

## 📌 Access URLs

```
Frontend:         http://localhost:80
API:              http://localhost:5000
Prometheus:       http://localhost:9090
Grafana:          http://localhost:3000 (admin/admin123)
Node Exporter:    http://localhost:9100/metrics
MongoDB Exporter: http://localhost:9216/metrics
```

## 🚀 Quick Commands

### Start Monitoring Stack
```bash
docker compose up -d
```

### Check Service Status
```bash
docker compose ps
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f prometheus
docker compose logs -f grafana
```

### Restart Services
```bash
docker compose restart prometheus grafana
```

### Stop Everything
```bash
docker compose down
```

## 📊 Grafana Quick Start

1. **Login**: http://localhost:3000 (admin/admin123)
2. **Add Panel**: + → Dashboard → Add new panel
3. **Select Prometheus** as datasource
4. **Enter query** (see examples below)
5. **Save Dashboard**

### Essential Queries

```promql
# API is up?
up{job="gigshub-api"}

# Request rate (per second)
rate(http_requests_total[5m])

# Average response time
rate(http_request_duration_ms_sum[5m]) / rate(http_request_duration_ms_count[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# CPU usage (%)
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory available
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100
```

## 🔍 Prometheus Quick Checks

### Check Targets
1. Go to: http://localhost:9090/targets
2. All should be **UP** ✅

### Test Query
1. Go to: http://localhost:9090/graph
2. Enter: `up`
3. Click **Execute**
4. Should show 1 for all services

## 🛠️ Troubleshooting

### Problem: Grafana shows "No data"
**Solution**: 
```bash
# Check Prometheus is running
docker compose ps prometheus

# Check datasource in Grafana
curl -u admin:admin123 http://localhost:3000/api/datasources
```

### Problem: Prometheus target is down
**Solution**:
```bash
# Check if service is running
docker compose ps

# Check service logs
docker compose logs [service-name]

# Restart the service
docker compose restart [service-name]
```

### Problem: Can't access Grafana
**Solution**:
```bash
# Check Grafana is running
docker compose ps grafana

# Restart Grafana
docker compose restart grafana

# Check logs
docker compose logs grafana
```

## 📈 Dashboard Templates

### Import Pre-built Dashboards
1. Click **+** → **Import**
2. Enter Dashboard ID:
   - **1860** - Node Exporter Full
   - **2583** - MongoDB
   - **3662** - Prometheus 2.0 Overview
3. Click **Load** and **Import**

## 🔔 Setting Up Alerts (Grafana)

1. Go to **Alerting** → **Alert rules**
2. Click **New alert rule**
3. Set conditions (e.g., CPU > 80%)
4. Configure notification channel
5. Save rule

## 📝 Best Practices

✅ Check dashboards daily  
✅ Monitor error rates  
✅ Set up alerts for critical metrics  
✅ Review slow queries/endpoints  
✅ Track resource trends over time  

## 🎓 Learning Resources

- [PromQL Tutorial](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Dashboard Guide](https://grafana.com/docs/grafana/latest/dashboards/)
- [Monitoring Best Practices](https://prometheus.io/docs/practices/)

---

**Need help?** See [MONITORING_SETUP.md](./MONITORING_SETUP.md) for detailed guide!
