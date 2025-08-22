---
layout: post
title: "KodeKloud Storage"
date: 2025-02-08 17:17:31 -0500
categories: technical
tags: kodekloud linux-administration storage
---

# Block storage

It's called because data is read and written in blocks, or chunks of space.

They can be found under directory:

```
/dev
```

"A piece of hardware that can store data" (Block storage)

commands to run:

```bash
lsblk
```

```bash
ls -l /dev/ | grep "^b"
```

<a href="{{ site.baseurl }}/assets/img/lsldev.png" target="_blank">
  <img src="{{ site.baseurl }}/assets/img/lsblk.png" alt="lsblk">
</a>

- Partitions offers greater flexibility

# lsblk

# fdisk

``bash
sudo fdisk -l /dev/sda

```
MBR = master boot record
```

gdisk /dev/sdb

creating partition^

its like fdisk, but more fancy.

check satus of partition:

```bash
sudo fdisk -1 /dev/sdb
```

<a href="{{ site.baseurl }}/assets/img/gdisk.png" target="_blank">
  <img src="{{ site.baseurl }}/assets/img/gdisk.png" alt="gdisk Partition Tool">
</a>

<a href="{{ site.baseurl }}/assets/img/guid-partition.png" target="_blank">
  <img src="{{ site.baseurl }}/assets/img/guid-partition.png" alt="GUID Partition Table (GPT)">
</a>

<a href="{{ site.baseurl }}/assets/img/masterboot.png" target="_blank">
  <img src="{{ site.baseurl }}/assets/img/masterboot.png" alt="Master Boot Record (MBR)">
</a>

# Create new partition with gdisk

```bash
Run: sudo gdisk /dev/vdb

In the interactive prompt, enter n

Select parition number = 1 (for vdd1)

Select default first sector = 2048

Select +500M when asked for last sector

Use default hex code = 8300

Finally type w to write to the partition table
```

# Filesystem
