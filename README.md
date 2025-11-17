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

let timezone = document["timezone"] as? String ?? ""
print("timezone=\(timezone)")

if let applications = document["Application"] as? [[String: Any]],
   let primary = applications.first {
    let service = primary["service"] as? String ?? ""
    let command = primary["command"] as? String ?? ""
    print("primary service -> \(service) (\(command))")
}

if let hosts = document["Host"] as? [[String: Any]], hosts.count > 1 {
    let backup = hosts[1]
    let hostname = backup["hostname"] as? String ?? ""
    let cores = backup["cores"] as? Int ?? 0
    print("host \(hostname) cores=\(cores)")
}
```

### Example Tyco File

```
tyco/example.tyco
```

```tyco
str timezone: UTC  # this is a global config setting

Application:       # schema defined first, followed by instance creation
  str service:
  str profile:
  str command: start_app {service}.{profile} -p {port.number}
  Host host:
  Port port: Port(http_web)  # reference to Port instance defined below
  - service: webserver, profile: primary, host: Host(prod-01-us)
  - service: webserver, profile: backup,  host: Host(prod-02-us)
  - service: database,  profile: mysql,   host: Host(prod-02-us), port: Port(http_mysql)

Host:
 *str hostname:  # star character (*) used as reference primary key
  int cores:
  bool hyperthreaded: true
  str os: Debian
  - prod-01-us, cores: 64, hyperthreaded: false
  - prod-02-us, cores: 32, os: Fedora

Port:
 *str name:
  int number:
  - http_web,   80  # can skip field keys when obvious
  - http_mysql, 3306
```
```
