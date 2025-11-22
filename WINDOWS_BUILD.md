# Building Adaptagrams on Windows

This guide explains how to build Adaptagrams on Windows using Conan for dependency management.

## Prerequisites

1. **CMake** (version 3.28 or higher)
   - Download from: https://cmake.org/download/
   - Or install via: `winget install Kitware.CMake`

2. **Python** (for Conan)
   - Download from: https://www.python.org/downloads/
   - Or install via: `winget install Python.Python.3`

3. **Visual Studio** (with C++ tools)
   - Visual Studio 2019 or later
   - Install "Desktop development with C++" workload

4. **Conan** (package manager)
   ```bash
   pip install conan
   ```

## Build Steps

### 1. Setup Conan Profile

First time only, detect and create a Conan profile:

```bash
conan profile detect --force
```

### 2. Install Dependencies

Install cairomm and other dependencies via Conan:

```bash
conan install . --output-folder=build --build=missing
```

This will:
- Download cairomm and its dependencies
- Build them if necessary (--build=missing)
- Generate CMake toolchain files in the `build/` directory

### 3. Configure CMake

Configure the build using the Conan-generated toolchain.

**PowerShell (recommended):**
```powershell
$toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DCMAKE_BUILD_TYPE=Release
```

**CMD (alternative):**
```cmd
cmake -B build -DCMAKE_TOOLCHAIN_FILE="%CD%\build\conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Release
```

**Git Bash (alternative):**
```bash
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$(pwd)/build/conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Release
```

Note: The `-B build` flag specifies the build directory. Using `Join-Path` or absolute paths ensures Windows properly resolves the toolchain file path.

### 4. Build

Build the libraries:

```bash
cmake --build build --config Release
```

## Build Options

### Building with Tests

**PowerShell:**
```powershell
conan install . --output-folder=build --build=missing
$toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
cd build
ctest -C Debug
```

### Building Python Bindings

Note: Python bindings require SWIG, which needs to be installed separately.

**PowerShell:**
```powershell
# Install SWIG (download from http://www.swig.org/ or use package manager)
conan install . --output-folder=build --build=missing
$toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DBUILD_SWIG_PYTHON=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

## Output

After a successful build, you'll find:
- Static libraries (`.lib` files) in `build/` directory
- Libraries: `avoid.lib`, `cola.lib`, `dialect.lib`, `topology.lib`, `vpsc.lib`

## Troubleshooting

### C++ Standard Compatibility Error

If you see an error like:
```
ERROR: cairomm/1.18.0: Invalid: Current cppstd (14) is lower than the required C++ standard (17).
```

This project uses C++11, so the `conanfile.txt` specifies `cairomm/1.14.5` which is compatible with C++11. If you need a newer cairomm version, you would need to upgrade the entire project to C++17.

### Conan Cannot Find Packages

If Conan cannot find packages, try:
```bash
conan profile detect --force
conan install . --output-folder=build --build=missing -s build_type=Release
```

### CMake Cannot Find Toolchain

If you see:
```
CMake Error: Could not find toolchain file: conan_toolchain.cmake
CMake Warning: Ignoring extra path from command line: ".cmake"
```

**Root Cause**: Windows PowerShell/CMD have different path handling than Unix shells. Forward slashes `/` in paths may not work correctly.

**Solution**: Use PowerShell's `Join-Path` to create the correct path:

**Correct (PowerShell):**
```powershell
$toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DCMAKE_BUILD_TYPE=Release
```

**Correct (CMD):**
```cmd
cmake -B build -DCMAKE_TOOLCHAIN_FILE="%CD%\build\conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Release
```

**Incorrect (won't work on Windows):**
```bash
cmake -B build -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake  # Forward slashes fail
```

To verify the toolchain file exists:
```powershell
dir build\conan_toolchain.cmake
```

### Build Errors Related to cairomm

If you encounter cairomm-related build errors:
1. Verify cairomm was installed: Check the conan install output
2. Try building cairomm from source: `conan install . --output-folder=build --build=cairomm/*`
3. Check that cairomm 1.14.5 is compatible with your compiler

## Alternative: Building Without Conan

If you prefer not to use Conan, you can build without cairomm support (some test features will be disabled):

```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

This builds the core libraries without optional dependencies.
