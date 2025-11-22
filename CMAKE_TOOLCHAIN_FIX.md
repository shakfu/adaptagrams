# CMake Toolchain Path Fix

## Problem

When running the Windows build workflow, CMake failed to find the Conan toolchain file:

```
CMake Error at CMakeDetermineSystem.cmake:152 (message):
  Could not find toolchain file: conan_toolchain.cmake
```

## Root Cause

The original workflow attempted to use a relative path while in the `build/` directory:

```bash
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake  # WRONG
```

This doesn't work because:
1. CMake looks for `conan_toolchain.cmake` relative to the **source directory** (`..`), not the current directory
2. The file is actually in the `build/` directory where we're running the command

## Solution

Use CMake's `-B` flag with **PowerShell's `Join-Path`** to create a Windows-compatible path:

```powershell
# Correct approach for Windows
$toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

### Why This Works

- `-B build`: Tells CMake to use `build/` as the build directory
- `Join-Path $PWD "build" "conan_toolchain.cmake"`: Creates a proper Windows path with backslashes
- PowerShell automatically converts the path to the correct format for CMake
- No need to `cd` into the build directory

### The Windows Path Problem

Windows PowerShell doesn't handle forward slashes `/` in paths the same way Unix shells do:
- `build/conan_toolchain.cmake` → PowerShell may split this incorrectly
- `build\conan_toolchain.cmake` → Better, but YAML escaping can be tricky
- `Join-Path $PWD "build" "conan_toolchain.cmake"` → **Best**, always correct

## Updated Workflow

### Before (Incorrect)
```yaml
- name: build using cmake
  run: |
    cd build
    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
    cmake --build . --config Release
```

### After (Correct)
```yaml
- name: configure cmake
  run: |
    $toolchain = Join-Path $PWD "build" "conan_toolchain.cmake"
    cmake -B build -DCMAKE_TOOLCHAIN_FILE="$toolchain" -DCMAKE_BUILD_TYPE=Release

- name: build
  run: cmake --build build --config Release
```

## Benefits of This Approach

1. **Clearer**: Explicit about where the build directory is
2. **Standard**: Follows modern CMake best practices
3. **Cross-platform**: Works consistently on Windows, Linux, and macOS
4. **Less error-prone**: No directory changes needed

## Files Updated

1. `.github/workflows/build-windows.yml` - Fixed workflow
2. `WINDOWS_BUILD.md` - Updated all examples with correct syntax
3. `CLAUDE.md` - Updated Windows build command

## Verification

To verify the toolchain file exists:

**Windows PowerShell:**
```powershell
dir build\conan_toolchain.cmake
```

**Windows CMD:**
```cmd
dir build\conan_toolchain.cmake
```

**Git Bash/Unix-like:**
```bash
ls build/conan_toolchain.cmake
```
