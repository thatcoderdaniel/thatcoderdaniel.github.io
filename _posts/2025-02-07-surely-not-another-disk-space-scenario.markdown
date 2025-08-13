---
layout: post
title: "SadServers: Disk Space Management with LVM"
date: 2025-02-08 17:17:31 -0500
categories: technical
tags: sadservers disk volumes lvm logical-volume-management linux-administration
---

## Problem Statement

A program `/home/admin/kihei` fails to run due to insufficient disk space. The program attempts to create a 1.5GB file at `/home/admin/data/newdatafile`, but the system lacks adequate storage.

**Constraint**: Cannot delete the existing `/home/admin/datafile` file.

## Initial Analysis

### Disk Usage Investigation

```bash
df -h
```

```
Filesystem       Size  Used Avail Use% Mounted on
/dev/nvme0n1p1   7.7G  6.6G  703M  91% /
```

The root filesystem is 91% full with only 703M available, insufficient for the required 1.5GB file.

### Available Storage Discovery

```bash
lsblk -l
```

```
NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme1n1    259:0    0    1G  0 disk
nvme0n1    259:1    0    8G  0 disk
nvme2n1    259:2    0    1G  0 disk
nvme0n1p1  259:3    0  7.9G  0 part /
nvme0n1p14 259:4    0    3M  0 part
nvme0n1p15 259:5    0  124M  0 part /boot/efi
```

**Key finding**: Two unused 1GB disks (`nvme1n1` and `nvme2n1`) are available, totaling 2GB of storage.

## Solution: Logical Volume Management (LVM)

### Step 1: Create Physical Volumes

Initialize both disks as LVM physical volumes:

```bash
sudo pvcreate /dev/nvme1n1
sudo pvcreate /dev/nvme2n1
```

**Output**:

```
Physical volume "/dev/nvme1n1" successfully created.
Physical volume "/dev/nvme2n1" successfully created.
```

### Step 2: Create Volume Group

Combine both physical volumes into a single volume group:

```bash
sudo vgcreate my_volume_group /dev/nvme1n1 /dev/nvme2n1
```

**Output**:

```
Volume group "my_volume_group" successfully created
```

### Step 3: Create Logical Volume

Initial attempt with exact 2GB fails due to metadata overhead:

```bash
sudo lvcreate -L 2G -n my_logical_volume my_volume_group
```

**Error**:

```
Volume group "my_volume_group" has insufficient free space (510 extents): 512 required.
```

**Solution**: Use all available free space:

```bash
sudo lvcreate -l 100%FREE -n my_logical_volume my_volume_group
```

**Output**:

```
Logical volume "my_logical_volume" created.
```

### Step 4: Create Filesystem

Format the logical volume with ext4 filesystem:

```bash
sudo mkfs.ext4 /dev/my_volume_group/my_logical_volume
```

### Step 5: Mount at Target Location

The application expects to write to `/home/admin/data/`, so mount the logical volume there:

```bash
sudo mkdir -p /home/admin/data
sudo mount /dev/my_volume_group/my_logical_volume /home/admin/data
```

### Step 6: Set Proper Ownership

Change ownership to the admin user:

```bash
sudo chown -R admin: /home/admin/data
```

## Verification

### Check Mount Status

```bash
df -h /home/admin/data
```

**Output**:

```
Filesystem                                     Size  Used Avail Use% Mounted on
/dev/mapper/my_volume_group-my_logical_volume  2.0G   24K  1.9G   1% /home/admin/data
```

### Verify LVM Configuration

```bash
sudo vgdisplay my_volume_group
```

**Key metrics**:

- VG Size: 1.99 GiB
- Total PE: 510
- All extents allocated (Free PE: 0)

### Test Application

```bash
./kihei -v
```

**Success output**:

```
Deleting file /home/admin/data/newdatafile...
Creating file /home/admin/data/newdatafile with size 1.5GB...
Done.
```

## Key Learning Points

### LVM Metadata Overhead

- LVM reserves space for metadata, reducing usable capacity
- Two 1GB disks provide ~1.99GB usable space, not 2GB
- Use `-l 100%FREE` instead of specifying exact sizes

### Mount Point Strategy

- Applications expect specific paths for data storage
- Mount logical volumes at application-expected locations
- Always verify ownership and permissions after mounting

### Problem-Solving Approach

1. Identify the root cause (insufficient disk space)
2. Inventory available resources (unused disks)
3. Implement appropriate technology (LVM for spanning disks)
4. Test the solution thoroughly

### Alternative Approach (from hints)

The more concise command sequence:

```bash
pvcreate /dev/nvme1n1 /dev/nvme2n1
vgcreate vg /dev/nvme1n1 /dev/nvme2n1
lvcreate -n lv -l 100%FREE vg
mkfs.ext4 /dev/vg/lv
mount /dev/vg/lv /home/admin/data
chown -R admin: /home/admin/data
```
