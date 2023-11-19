#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Device not specified"
    exit 1
fi

protopedal \
    --name "MOZA Racing HGP Shifter" \
    -v "346e" \
    -p "001e" \
    --grab \
    --no-auto-axes \
    -a X -a Y -a Z \
    --no-auto-buttons \
    -b BASE -s PINKIE \
    -b BASE2 -s BASE \
    -b BASE3 -s BASE2 \
    -b BASE4 -s BASE3 \
    -b BASE5 -s BASE4 \
    -b BASE6 -s BASE5 \
    -b BASE7 -s BASE6 \
    -b BASE8 -s TOP2 \
    "$1"
