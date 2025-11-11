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

// Parse a Tyco configuration file
let context = try Tyco.loadFile("config.tyco")

// Access global configuration values
let globals = context["globals"] as? [String: Any]
let environment = globals?["environment"]
let debug = globals?["debug"]
let timeout = globals?["timeout"]

// Get all instances as arrays
let objects = context["objects"] as? [String: Any]
let databases = objects?["Database"] as? [[String: Any]]
let servers = objects?["Server"] as? [[String: Any]]

// Access individual instance fields
if let primaryDb = databases?.first {
   let dbHost = primaryDb["host"]
   let dbPort = primaryDb["port"]
}
```
