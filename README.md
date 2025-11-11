## Tyco Swift Binding

Swift Package that wraps the C API (`libtyco_c`) and exposes `Tyco.loadFile` / `Tyco.loadString`, returning native Swift structures decoded from JSON.

### Prerequisites

1. Build the shared C library:
   ```bash
   cd ../tyco-c
   cmake -S . -B build
   cmake --build build
   ```
2. Ensure `LD_LIBRARY_PATH` (or `DYLD_LIBRARY_PATH` on macOS) contains `../tyco-c/build` before running `swift test`.

### Build & Test

```bash
cd tyco-swift
swift test
```

### Usage

Add the package as a dependency and use:

```swift
import TycoSwift

let data = try Tyco.loadFile("../tyco-test-suite/inputs/simple1.tyco")
print(data)
```
