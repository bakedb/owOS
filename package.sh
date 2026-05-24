#!/bin/bash

mkdir -p package-temp
cp buildroot/output/images/bzImage package-temp/
cp buildroot/output/images/rootfs.ext2 package-temp/
cp run.sh package-temp/

date=$(date +%Y-%m-%d)
tar -czf "owos-build-$date.tar.gz" package-temp