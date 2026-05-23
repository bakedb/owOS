#!/bin/bash
mkdir -p $1/manual_image_workspace
mkdir -p $1/output_img
sudo cp -r buildroot/manual_image_workspace $1/manual_image_workspace
sudo cp -r buildroot/output_img $1