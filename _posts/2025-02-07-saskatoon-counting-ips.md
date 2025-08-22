---
layout: post
title: "SadServers Saskatoon: Log Processing and I/O Monitoring"
date: 2025-02-08 17:17:31 -0500
categories: technical
tags: sadservers linux-administration performance-monitoring
---

## Problem Statement

Find the IP address that appears most frequently in `access.log` and save it to `/home/admin/highestip.txt`

## Solution Breakdown

### Step 1: Understanding the Log Format

First, examine the log structure to identify the IP address field:

```bash
head -1 access.log
# Output: 83.149.9.216 - - [17/May/2015:10:05:03 +0000] "GET /presentations/ HTTP/1.1" 200 3525 "-" "Mozilla/5.0..."
```

The IP address is the first field in each log entry.

### Step 2: Extract IP Addresses

Two methods to extract the first field:

**Method 1: Using awk**

```bash
awk '{print $1}' access.log | head -5
```

**Method 2: Using cut**

```bash
cat access.log | cut -d' ' -f1 | head -5
```

### Step 3: Count Unique IPs

Count occurrences of each IP address:

```bash
awk '{print $1}' access.log | sort | uniq -c
```

<a href="{{ site.baseurl }}/assets/img/sortme.png" target="_blank">
  <img src="{{ site.baseurl }}/assets/img/sortme.png" alt="IP Count Distribution">
</a>

### Step 4: Find the Most Frequent IP

Sort by count (descending) and get the top result:

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -1
# Output: 482 66.249.73.135
```

### Step 5: Extract and Save the IP

Final solution:

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -1 | awk '{print $2}' > /home/admin/highestip.txt
```

Verify:

```bash
cat /home/admin/highestip.txt
# Output: 66.249.73.135
```

## Performance Monitoring During Log Processing

### Monitoring I/O Impact

While processing large log files, monitor system performance:

**1. Check I/O Wait**

```bash
top
# Look for %wa in the CPU line - high values indicate I/O bottleneck
```

**2. Monitor Disk Metrics**

```bash
iostat -x 1
# Key metrics:
# %util   - Disk utilization (100% = saturated)
# await   - Average I/O wait time (>20ms = potential issue)
# avgqu-sz - Queue depth (>1 = requests backing up)
```

**3. Identify I/O-Heavy Processes**

```bash
iotop -b -n 1
# Shows which processes are consuming the most I/O
```

### Performance Observations

During log processing on this 87MB file:

- **Read throughput**: ~50-100 MB/s during sort operations
- **I/O wait**: Peaks at 10-15% during sorting phase
- **Disk utilization**: Reaches 60-80% during `sort`

## Key Takeaways for TAM Role

### When Customer Reports "Slow Log Processing"

1. **Check I/O wait**: `top` - look for %wa > 10%
2. **Identify bottleneck**: `iostat -x 1` - check %util and await
3. **Find culprit process**: `iotop` - see which process causes I/O
4. **Analyze pattern**: Is it reads or writes? Sequential or random?

### Common Solutions

- **High I/O wait**: Consider SSD storage or increase IOPS
- **Large log files**: Implement log rotation
- **Frequent processing**: Use dedicated log aggregation tools
- **Memory pressure**: Sort operations may spill to disk

## Alternative One-Liner Solutions

```bash
# Using awk for everything
awk '{print $1}' access.log | awk '{count[$1]++} END {for (ip in count) print count[ip], ip}' | sort -rn | head -1 | awk '{print $2}'

# Using grep with perl regex (if IPs are at line start)
grep -oP '^\d+\.\d+\.\d+\.\d+' access.log | sort | uniq -c | sort -rn | head -1 | awk '{print $2}'
```
