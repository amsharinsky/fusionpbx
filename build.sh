#!/bin/sh
set -e
# Settings
DEBIAN_TAG=11
DEBIAN_DIGEST=sha256:749383b0a6d17fb745d397b108d2ea38b5832226586b25c9f5cf7fcde24458ab
# Build
docker build \
--build-arg DEBIAN_TAG=${DEBIAN_TAG} \
--tag fusionpbx:latest \
  FusionPBX
