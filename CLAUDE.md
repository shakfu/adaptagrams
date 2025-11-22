# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Adaptagrams is a library of tools for adaptive diagramming applications. The repository contains five C++ libraries for constraint-based layout, connector routing, and diagram visualization.

## Build Commands

### Standard Build (Unix/macOS)
```bash
make              # Build libraries (Release)
make test         # Build with tests (Debug) and run tests
make python       # Build with Python bindings
make clean        # Remove build directory
```

### Direct CMake Usage (Unix/macOS/Windows)
```bash
# Basic build
mkdir -p build && cd build && cmake .. && cmake --build . --config Release

# Build with tests
mkdir -p build && cd build && cmake .. -DBUILD_TESTS=ON && cmake --build . --config Debug

# Build with Python SWIG bindings
mkdir -p build && cd build && cmake .. -DBUILD_SWIG_PYTHON=ON && cmake --build . --config Release

# Run tests
cd build && ctest
```

### Windows Build with Conan
For Windows, use Conan for dependency management (see `WINDOWS_BUILD.md` for details):
```bash
# Install dependencies
conan install . --output-folder=build --build=missing

# Configure and build
cmake -B build -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

### Testing Individual Libraries
Tests are built when `-DBUILD_TESTS=ON` is specified. Each library has its own test suite:
- Tests are located in `cola/lib*/tests/`
- Individual test executables are built in `build/cola/lib*/tests/`
- Run specific test: `./build/cola/libavoid/tests/<test_name>`

## Library Architecture

### Core Libraries (in dependency order)

1. **libvpsc** (foundation)
   - Variable Placement with Separation Constraints solver
   - Quadratic programming for layout optimization
   - No dependencies

2. **libcola**
   - Constraint graph layout using stress-majorization
   - Force-directed layout with separation constraints
   - Depends on: libvpsc

3. **libavoid**
   - Object-avoiding polyline and orthogonal connector routing
   - High-quality connector routing for diagram editors
   - No dependencies

4. **libtopology**
   - Topology-preserving constraint-based layout
   - Depends on: libavoid, libcola, libvpsc

5. **libdialect**
   - Human-like orthogonal network layouts (DiAlEcT algorithm)
   - Depends on: libavoid, libcola, libvpsc

### Library Locations
All library code is in the `cola/` directory:
- `cola/libvpsc/` - Variable placement solver
- `cola/libcola/` - Constraint layout
- `cola/libavoid/` - Connector routing
- `cola/libtopology/` - Topology preservation
- `cola/libdialect/` - Orthogonal layouts
- `cola/libproject/` - Projection utilities

### SWIG Bindings
- Interface file: `cola/adaptagrams.i`
- Generates bindings for Python and Java
- All five libraries are exposed through a unified interface
- Build with: `make python` or `cmake -DBUILD_SWIG_PYTHON=ON`

## Build System Details

### CMake Configuration
- Root: `CMakeLists.txt` - Top-level configuration
- Libraries: `cola/CMakeLists.txt` - Common compile definitions
- Individual: `cola/lib*/CMakeLists.txt` - Per-library build

### Optional Dependencies
- **Cairo/Cairomm**: Optional dependency for SVG debug output in tests
  - Not required for library functionality
  - **Unix/macOS**: Detected via pkg-config
    - Install: `brew install cairomm` (macOS) or `apt install libcairomm-1.16-dev` (Linux)
  - **Windows**: Provided via Conan (see `conanfile.txt`)
    - Uses cairomm 1.14.5 (compatible with C++11)
    - Automatically handled by `conan install` command
    - Note: Newer cairomm versions (1.16+) require C++17

### Dependency Management
The build system supports multiple methods for finding cairomm:
1. **Conan** (preferred for Windows): Uses `find_package(cairomm CONFIG)`
2. **pkg-config** (Unix/macOS fallback): Uses `pkg_check_modules()`

The CMake configuration tries Conan first, then falls back to pkg-config if not found.

### Build Options
- `BUILD_TESTS=ON` - Enable test suite compilation
- `BUILD_SWIG_PYTHON=ON` - Enable Python bindings
- `ENABLE_CCACHE=ON` - Use ccache if available (default)
- `CMAKE_TOOLCHAIN_FILE` - Specify Conan toolchain (required for Conan builds)

## Code Organization Principles

### Library Dependencies
When modifying code, respect dependency hierarchy:
- libvpsc is foundational (no dependencies)
- libcola and libavoid are independent mid-level libraries
- libtopology and libdialect depend on multiple libraries

### Test Structure
Each library follows the pattern:
- `lib*/tests/` contains test source files
- `lib*/tests/CMakeLists.txt` defines test build rules
- Tests use custom CMake functions: `add_cola_test()`, `add_avoid_test()`, etc.
- Tests output to `build/cola/lib*/tests/output/` directory

### Header Organization
- Public headers are declared in CMakeLists.txt `LIB_HEADERS`
- Headers are installed to `include/lib*/` via `FILE_SET`
- All libraries use `POSITION_INDEPENDENT_CODE ON` for shared library compatibility
