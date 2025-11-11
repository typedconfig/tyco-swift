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

Every binding bundles the canonical configuration under `tyco/example.tyco`
([view on GitHub](https://github.com/typedconfig/tyco-swift/blob/main/tyco/example.tyco)).
Load it to mirror the Python README example:

```swift
import TycoSwift

let document = try Tyco.loadFile("tyco/example.tyco") as! [String: Any]

let environment = document["environment"] as? String ?? ""
let debug = document["debug"] as? Bool ?? false
let timeout = document["timeout"] as? Int ?? 0
print("env=\(environment) debug=\(debug) timeout=\(timeout)")

if let databases = document["Database"] as? [[String: Any]],
   let primary = databases.first,
   let host = primary["host"] as? String,
   let port = primary["port"] as? Int {
    print("primary database -> \(host):\(port)")
}
```

### Example Tyco File

```
tyco/example.tyco
```

```tyco
# Global configuration with type annotations
str environment: production
bool debug: false
int timeout: 30

# Database configuration struct
Database:
 *str name:           # Primary key field (*)
  str host:
  int port:
  str connection_string:
  # Instances
  - primary, localhost,    5432, "postgresql://localhost:5432/myapp"
  - replica, replica-host, 5432, "postgresql://replica-host:5432/myapp"

# Server configuration struct  
Server:
 *str name:           # Primary key for referencing
  int port:
  str host:
  ?str description:   # Nullable field (?) - can be null
  # Server instances
  - web1,    8080, web1.example.com,    description: "Primary web server"
  - api1,    3000, api1.example.com,    description: null
  - worker1, 9000, worker1.example.com, description: "Worker number 1"

# Feature flags array
str[] features: [auth, analytics, caching]
```
```
