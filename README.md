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

## Quick Start

This package includes a ready-to-use example Tyco file at:

   example.tyco

([View on GitHub](https://github.com/typedconfig/tyco-swift/blob/main/example.tyco))

You can load and parse this file using the Swift Tyco API. Example usage:

```swift
import TycoSwift

// Parse the bundled example.tyco file
let context = try Tyco.loadFile("example.tyco")

// Access global configuration values
let globals = context["globals"] as? [String: Any]
let environment = globals?["environment"]
let debug = globals?["debug"]
let timeout = globals?["timeout"]
print("env=\(environment ?? "") debug=\(debug ?? false) timeout=\(timeout ?? 0)")
// ... access objects, etc ...
```

See the [example.tyco](https://github.com/typedconfig/tyco-swift/blob/main/example.tyco) file for the full configuration example.
let servers = objects?["Server"] as? [[String: Any]]

// Access individual instance fields
if let primaryDb = databases?.first {
   let dbHost = primaryDb["host"]
   let dbPort = primaryDb["port"]
}
```
