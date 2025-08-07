#!/usr/bin/env bash
set -Eeuo pipefail

sudo snap install restic --classic

echo "this is a test" > /home/lima.linux/test.txt

cd /tmp
mkdir restic
export RESTIC_PASSWORD="password"
restic init --repo /tmp/restic
