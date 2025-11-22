# Conan Windows Setup - Technical Details

## Problem Solved

When building Adaptagrams on Windows with Conan, we encountered a C++ standard compatibility issue:

```
ERROR: cairomm/1.18.0: Invalid: Current cppstd (14) is lower than the required C++ standard (17).
libsigcpp/3.0.7: Invalid: Current cppstd (14) is lower than the required C++ standard (17).
```

## Root Cause

- **Adaptagrams** is built with C++11 (see `CMakeLists.txt`: `set(CMAKE_CXX_STANDARD 11)`)
- **cairomm 1.18.0** and its dependency **libsigcpp 3.0.7** require C++17
- Conan was trying to install incompatible package versions

## Solution

Changed `conanfile.txt` to use cairomm 1.14.5, which is compatible with C++11:

```ini
[requires]
cairomm/1.14.5

[generators]
CMakeDeps
CMakeToolchain

[layout]
cmake_layout

[options]
cairomm*:shared=False
```

## Version Compatibility Matrix

| cairomm Version | C++ Standard Required | Compatible with Adaptagrams |
|-----------------|----------------------|----------------------------|
| 1.14.x          | C++11                | Yes ✓                      |
| 1.16.x          | C++17                | No (requires C++17)        |
| 1.18.x          | C++17                | No (requires C++17)        |

## Why Not Upgrade to C++17?

Upgrading Adaptagrams to C++17 would:
1. Require testing all existing code for compatibility
2. Potentially break existing users who rely on C++11
3. Add an unnecessary dependency for a library that aims for broad compatibility

Since cairomm is only used for **optional** SVG debug output in tests (not core functionality), using the older but stable 1.14.5 version is the pragmatic choice.

## Alternatives Considered

### Option 1: Upgrade Project to C++17 (Not Chosen)
- **Pros**: Access to newer cairomm features
- **Cons**: Breaking change, requires code audit, reduces compatibility

### Option 2: Use cairomm 1.14.5 (CHOSEN)
- **Pros**: Maintains C++11 compatibility, minimal changes
- **Cons**: Older cairomm version (but stable and sufficient)

### Option 3: Make cairomm Optional on Windows
- **Pros**: No version constraints
- **Cons**: Loses SVG debug output capability on Windows

## Implementation Details

The CMake configuration now supports three dependency resolution paths:

1. **Conan (Windows)**:
   ```cmake
   find_package(cairomm QUIET CONFIG)  # Finds Conan-provided cairomm 1.14.5
   ```

2. **pkg-config (Unix/macOS)**:
   ```cmake
   pkg_check_modules(CAIROMM cairomm-1.16)  # Uses system cairomm
   ```

3. **No cairomm**:
   ```cmake
   set(HAVE_CAIROMM 0)  # Builds without optional SVG support
   ```

## Testing

Verified on:
- ✓ macOS with pkg-config (cairomm 1.18.0 from Homebrew)
- ✓ Local build without Conan
- ⏳ Windows with Conan (ready for CI testing)

## Future Considerations

If Adaptagrams is upgraded to C++17 in the future, update `conanfile.txt`:

```ini
[requires]
cairomm/[>=1.16.0]  # Use newer versions when C++17 is available
```

And update `CMakeLists.txt`:

```cmake
set(CMAKE_CXX_STANDARD 17)
```
