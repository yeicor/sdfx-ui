#!/bin/bash

# Test script for sdfx-ui examples
# This script verifies that all examples compile successfully

set -e

echo "Testing sdfx-ui examples..."

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname $(dirname "$SCRIPT_DIR"))"

# Test main library first
echo "Building main library..."
cd "$PROJECT_ROOT"
go build -v ./...

echo "Running tests..."
go test -v ./...

echo "Running go vet..."
go vet ./...

echo "Running go fmt check..."
if [ "$(gofmt -s -l . | grep -v vendor | wc -l)" -gt 0 ]; then
    echo "The following files are not formatted:"
    gofmt -s -l . | grep -v vendor
    exit 1
fi

# Test examples
echo "Testing examples..."

# Test spiral example
echo "Building spiral example..."
cd "$PROJECT_ROOT/examples/spiral"
go build -o /dev/null -v .
echo "✓ Spiral example builds successfully"

# Test cylinder_head example
echo "Building cylinder_head example..."
cd "$PROJECT_ROOT/examples/cylinder_head"
go build -o /dev/null -v .
echo "✓ Cylinder head example builds successfully"

echo "All tests passed! ✓"
