#!/bin/bash
# Test script to verify Conan build integration works

set -e

echo "Testing Conan build integration for Adaptagrams"
echo "================================================"

# Clean up any previous build
echo "Cleaning previous build..."
rm -rf build_test

# Install dependencies via Conan
echo "Installing dependencies via Conan..."
conan install . --output-folder=build_test --build=missing

# Build with Conan toolchain
echo "Building with CMake using Conan toolchain..."
cd build_test
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release

echo ""
echo "Build successful!"
echo "Checking if cairomm was found..."
if grep -q "cairomm_FOUND:BOOL=1" CMakeCache.txt; then
    echo "SUCCESS: cairomm found via Conan"
elif grep -q "HAVE_CAIROMM:BOOL=1" CMakeCache.txt; then
    echo "SUCCESS: cairomm found via pkg-config (fallback)"
else
    echo "WARNING: cairomm not found (this is OK if not needed)"
fi

cd ..
echo ""
echo "Test completed successfully!"
