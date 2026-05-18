#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- CONFIGURATION ---
WORKSPACE_DIR="./manual_image_workspace"
OUTPUT_DIR="./output_img"
IMAGES_SRC="output/images" # Adjust this path to your buildroot output/images directory

ROOTFS_TAR="${IMAGES_SRC}/rootfs.tar"
KERNEL_IMAGE="${IMAGES_SRC}/bzImage"
GENIMAGE_CFG="${WORKSPACE_DIR}/genimage.cfg"

# --- SANITY CHECKS ---
if [ ! -f "$ROOTFS_TAR" ]; then
    echo "Error: $ROOTFS_TAR not found. Please verify your buildroot output images path."
    exit 1
fi

if [ ! -f "$KERNEL_IMAGE" ]; then
    echo "Error: $KERNEL_IMAGE not found. Please verify your buildroot output images path."
    exit 1
fi

# Ensure genimage tool is available on the host machine
if ! command -v genimage &> /dev/null; then
    echo "Error: 'genimage' utility is required but not installed."
    exit 1
fi

echo "==> Cleaning and initializing local workspace..."
sudo rm -rf "$WORKSPACE_DIR" "$OUTPUT_DIR"
mkdir -p "${WORKSPACE_DIR}/rootfs"
mkdir -p "${WORKSPACE_DIR}/boot"
mkdir -p "$OUTPUT_DIR"

# --- STEP 1: EXTRACT TARGET FILESYSTEM ---
echo "==> Extracting rootfs archive (requires sudo to preserve file permissions)..."
sudo tar -xf "$ROOTFS_TAR" -C "${WORKSPACE_DIR}/rootfs/"

# --- STEP 2: SETUP KERNEL BITS & DIRECTORY HOOKS ---
echo "==> Staging kernel image..."
cp "$KERNEL_IMAGE" "${WORKSPACE_DIR}/vmlinuz"

echo "==> Verifying placeholder nodes for dynamic devtmpfs mounting..."
sudo mkdir -p "${WORKSPACE_DIR}/rootfs/dev"
sudo mkdir -p "${WORKSPACE_DIR}/rootfs/proc"
sudo mkdir -p "${WORKSPACE_DIR}/rootfs/sys"

# --- STEP 3: CREATE DYNAMIC GENIMAGE CONFIGURATION ---
echo "==> Generating genimage.cfg structural file..."
cat << EOF > "$GENIMAGE_CFG"
image boot.vfat {
    vfat {
        files = {
            "vmlinuz"
        }
    }
    size = 64M
}

image sdcard.img {
    hdimage {
        gpt = true
    }

    partition boot {
        partition-type-uuid = "U"
        image = "boot.vfat"
        bootable = true
    }

    partition rootfs {
        partition-type-uuid = "L"
        image = "rootfs.ext4"
    }
}
EOF

# --- STEP 4: COMPUTE RAW FILESYSTEM PARTITIONS ---
echo "==> Building standalone ext4 rootfs image block..."
# Compiles rootfs directory into a raw 512MB ext4 block file
sudo mke2fs -d "${WORKSPACE_DIR}/rootfs" -t ext4 "${WORKSPACE_DIR}/rootfs.ext4" 512M

echo "==> Building standalone vfat boot image block..."
# Creates an empty 64M vfat partition image file
dd if=/dev/zero of="${WORKSPACE_DIR}/boot.vfat" bs=1M count=64 status=none
mkfs.vfat "${WORKSPACE_DIR}/boot.vfat" > /dev/null
# Use mcopy to manually inject the kernel image into the raw vfat file
mcopy -i "${WORKSPACE_DIR}/boot.vfat" "${WORKSPACE_DIR}/vmlinuz" ::vmlinuz

# --- STEP 5: ARRANGE IMAGE WITH GENIMAGE ---
echo "==> Stitching image layout elements together using genimage..."

# Direct genimage execution with sudo to access rootfs permissions safely
sudo genimage \
    --config "$GENIMAGE_CFG" \
    --inputpath "$WORKSPACE_DIR" \
    --outputpath "$OUTPUT_DIR" \
    --rootpath "${WORKSPACE_DIR}/rootfs"

echo "========================================================"
echo " SUCCESS: Hardware-ready image generated successfully! "
echo " Target Location: ${OUTPUT_DIR}/sdcard.img"
echo "========================================================"
echo "To flash onto flash media, you can use:"
echo "  sudo dd if=${OUTPUT_DIR}/sdcard.img of=/dev/sdX bs=4M status=progress conv=fsync"
echo "========================================================"