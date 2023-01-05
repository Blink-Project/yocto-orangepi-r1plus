#!/bin/bash

docker run \
    -it \
    --network host \
    -v "${PWD}:${PWD}" \
    -w "${PWD}" \
    crops/poky:ubuntu-20.04 \
    bash -c 'source layers/poky/oe-init-build-env && bash'
