#!/bin/bash
# Script for grabbing all the relevant files after a Vivado design.

if [[ $# -ne 2 ]]; then
    echo "Usage: viv_collect PROJECT_DIR BITSTREAM_NAME"
    exit 1
fi

project_dir=$1
overlay_name=$2

hwh_file=$(find $project_dir | grep hwh$)
if [[ $? -ne 0 ]]; then echo "Missing hwh file."; exit 1; fi

bit_file=$(find $project_dir | grep bit$)
if [[ $? -ne 0 ]]; then echo "Missing bit file."; exit 1; fi

tmp_dir=/tmp/$overlay_name
mkdir -p $tmp_dir

echo "Moving $hwh_file, $bit_file to $tmp_dir and then putting that on the xilinx board."

# copy everything to common location
cp $hwh_file $tmp_dir/$overlay_name.hwh
cp $bit_file $tmp_dir/$overlay_name.bit

# scp folder recursively to xilinx@192.168.56.69:~/pynq/overlays/<overlay_name>
scp -o ConnectTimeout=3 -r $tmp_dir xilinx@192.168.56.69:~/overlays || echo "Failed to scp files."

