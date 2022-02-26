# Encrypted Image Mounter

Type `./mounter.sh` for help

## Setup

Create image if not created yet:

```bash
dd if=/dev/zero of=documents.img bs=2G count=4
losetup -f documents.img
losetup # extract X from this comand
cryptsetup luksFormat -v /dev/loopX
cryptsetup luksOpen /dev/loopX mapperPoint
mkfs.ext4 /dev/mapper/mapperPoint
```

will create 8G image file. You need to do this only once for storage creation
