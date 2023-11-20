#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Device not specified"
    exit 1
fi

protopedal "$1"