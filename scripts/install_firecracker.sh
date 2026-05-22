#!/bin/bash
set -uo pipefail

VERSION="${1:-latest}"
OUT_DIR="${2:-tools/firecracker}"
ARCH="$(uname -m)"

release_url="https://github.com/firecracker-microvm/firecracker/releases"

if [ "$VERSION" = "latest" ]; then
  latest=$(basename "$(curl -fsSLI -o /dev/null -w %{url_effective} ${release_url}/latest)")
  VERSION=$latest
fi

mkdir -p "$OUT_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl -L "${release_url}/download/${VERSION}/firecracker-${VERSION}-${ARCH}.tgz" \
  | tar -xz -C "$tmp_dir"

SRC_DIR="${tmp_dir}/release-${VERSION}-${ARCH}"

cp "${SRC_DIR}/firecracker-${VERSION}-${ARCH}" "${OUT_DIR}/firecracker"
cp "${SRC_DIR}/jailer-${VERSION}-${ARCH}" "${OUT_DIR}/jailer"

echo "Installed Firecracker ${VERSION} to ${OUT_DIR}"
