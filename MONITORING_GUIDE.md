# 📊 Prometheus & Grafana Monitoring Setup Guide

## What You Just Set Up

✅ **Prometheus**: Collects metrics from your API every 10-15 seconds
✅ **Grafana**: Beautiful dashboards to visualize your metrics
✅ **Node Exporter**: System-level metrics (CPU, memory, disk)
✅ **MongoDB Exporter**: Database performance metrics
✅ **Custom API Metrics**: Request rates, response times, errors

---

## 🚀 Step-by-Step Guide to Run

### Step 1: Install Dependencies
```bash
cd api
npm install
cd ..
```

### Step 2: Start All Services
```bash
docker-compose up -d
```

This starts:
- MongoDB (port 27017)
- API (port 5000)
- Client (port 80)
- **Prometheus** (port 9090)
- **Grafana** (port 3000)
- Node Exporter (port 9100)
- MongoDB Exporter (port 9216)

### Step 3: Access Prometheus
1. Open browser: `http://localhost:9090`
2. Go to **Status → Targets** to verify all services are being scraped
3. Try a query in the search bar: `http_requests_total`
4. Click "Execute" to see your API request metrics

### Step 4: Access Grafana
1. Open browser: `http://localhost:3000`
2. Login credentials:
   - Username: `admin`
   - Password: `admin123`
3. You'll see the pre-configured dashboard "GigsHub API Monitoring"

---

## 📈 What Metrics You'll See

### In Grafana Dashboard:
1. **HTTP Requests per Second**: Real-time API traffic
2. **Response Time**: How fast your API responds (in milliseconds)
3. **Memory Usage**: Heap memory used by Node.js
4. **CPU Usage**: Server CPU consumption
5. **Total Requests**: Counter of all requests
6. **Error Rate**: Percentage of 5xx errors
7. **Active Connections**: Current active connections

### Example Prometheus Queries:
```promql
# Total requests
http_requests_total

# Request rate (per second)
rate(http_requests_total[1m])

# Average response time
rate(http_request_duration_ms_sum[1m]) / rate(http_request_duration_ms_count[1m])

# Memory usage in MB
nodejs_heap_size_used_bytes / 1024 / 1024

# Error rate percentage
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100
```

---

## 🔧 Testing Your Setup

### Generate Some Traffic:
```bash
# Make requests to your API to generate metrics
curl http://localhost:5000/health
curl http://localhost:5000/api/gigs
curl http://localhost:5000/metrics
```

### View Metrics:
1. Check raw metrics: `http://localhost:5000/metrics`
2. View in Prometheus: `http://localhost:9090`
3. Visualize in Grafana: `http://localhost:3000`

---

## 🎨 Customizing Grafana

### Add More Dashboards:
1. Click "+" → Dashboard
2. Add Panel → Choose visualization (Graph, Gauge, Stat, etc.)
3. Enter Prometheus query
4. Save dashboard

### Import Community Dashboards:
1. Go to Dashboards → Import
2. Enter dashboard ID:
   - **Node.js Application**: `11159`
   - **MongoDB**: `2583`
   - **Docker Containers**: `193`
3. Select Prometheus datasource → Import

### Modify Existing Dashboard:
1. Click dashboard title → Edit
2. Modify panels, add new queries
3. Click "Save dashboard"

---

## 🔔 Setting Up Alerts (Optional)

### In Grafana:
1. Go to Alerting → Alert rules
2. Create new alert rule
3. Example: Alert when error rate > 5%
   ```promql
   sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100 > 5
   ```
4. Add notification channel (Email, Slack, Discord)

---

## 📝 Useful Commands

```bash
# View all running containers
docker-compose ps

# View Grafana logs
docker-compose logs grafana

# View Prometheus logs
docker-compose logs prometheus

# Restart monitoring stack
docker-compose restart prometheus grafana

# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v
```

---

## 🎯 What to Monitor

### Performance:
- Response time should be < 200ms for most requests
- Memory usage should remain stable (no memory leaks)
- CPU usage spikes during high traffic

### Errors:
- Error rate should be < 1%
- Monitor 5xx errors (server errors)
- Track 4xx errors (client errors)

### Resources:
- Memory: Should not continuously grow
- CPU: Should not stay at 100%
- Database connections: Monitor MongoDB metrics

---

## 🔗 Access URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://localhost:3000 | admin / admin123 |
| Prometheus | http://localhost:9090 | - |
| API Metrics | http://localhost:5000/metrics | - |
| API Health | http://localhost:5000/health | - |
| Node Exporter | http://localhost:9100/metrics | - |
| MongoDB Exporter | http://localhost:9216/metrics | - |

---

## 🎓 Next Steps

1. **Generate traffic** to your API to populate metrics
2. **Explore Grafana** - customize dashboards
3. **Set up alerts** for critical metrics
4. **Import community dashboards** for more insights
5. **Monitor in production** - adjust thresholds based on real traffic

---

## 💡 Pro Tips

- **Refresh Interval**: In Grafana, set auto-refresh to 5s for real-time monitoring
- **Time Range**: Use "Last 5 minutes" for immediate feedback
- **Annotations**: Add annotations in Grafana for deployments or incidents
- **Retention**: Prometheus keeps data for 15 days by default
- **Scaling**: For production, use Prometheus AlertManager and Thanos for long-term storage

---

Happy Monitoring! 📊🚀
