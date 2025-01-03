Secure Erase

```
diskutil secureErase 0 /dev/diskX
```

Usage: diskutil secureErase freespace level MountPoint|DiskIdentifier|DeviceNode
Securely erases either a whole disk or a volume's freespace.
Level should be one of the following:

0 - Single-pass zeros.
1 - Single-pass random numbers.
2 - US DoD 7-pass secure erase.
3 - Gutmann algorithm 35-pass secure erase.
4 - US DoE 3-pass secure erase.

Ownership of the affected disk is required.
Note: Level 2, 3, or 4 secure erases can take an extremely long time.

Format Erase

```shell
diskutil eraseDisk FILE_SYSTEM DISK_NAME DISK_IDENTIFIER
```

Example

```shell
diskutil eraseDisk JHFS+ DiskName /dev/disk6s2
```

Delete APFS Volume

```shell
diskutil apfs deleteContainer disk2s3
```
