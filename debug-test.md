---
layout: debug
title: Debug Test Rendering
---

## Problem Statement

A program `/home/admin/kihei` fails to run due to insufficient disk space.

### Code Block Test

```bash
df -h
/dev/nvme0n1p1    7.7G  6.6G  703M  91%
```

### Inline Code Test

The path is `/home/admin/data/newdatafile` and needs 1.5GB.

### Pre Tag Test

```
NAME     MAJ:MIN RM
nvme1n1  259:0   0
nvme0n1  259:1   0
```

### Raw HTML Test

<pre><code>sudo pvcreate /dev/nvme1n1
sudo pvcreate /dev/nvme2n1</code></pre>

### Manual Code Test

<code>/home/admin/datafile</code> should be formatted properly.