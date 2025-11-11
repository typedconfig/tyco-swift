import XCTest
@testable import TycoSwift

final class TycoSwiftTests: XCTestCase {
    func testGoldenSuite() throws {
        let fileURL = URL(fileURLWithPath: #filePath)
        let packageRoot = fileURL
            .deletingLastPathComponent() // TycoSwiftTests.swift
            .deletingLastPathComponent() // TycoSwiftTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // tyco-swift
        let suiteRoot = packageRoot.appendingPathComponent("tyco-test-suite")
        let inputs = suiteRoot.appendingPathComponent("inputs")
        let expected = suiteRoot.appendingPathComponent("expected")

        let fileManager = FileManager.default
        let entries = try fileManager.contentsOfDirectory(at: inputs, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "tyco" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }

        for input in entries {
            let expectedFile = expected.appendingPathComponent(input.deletingPathExtension().lastPathComponent + ".json")
            guard fileManager.fileExists(atPath: expectedFile.path) else {
                continue
            }
            let actual = try Tyco.loadFile(input.path)
            let expectedData = try Data(contentsOf: expectedFile)
            let expectedJson = try JSONSerialization.jsonObject(with: expectedData, options: [])
            XCTAssertTrue(jsonEquals(actual, expectedJson), "Mismatch for \(input.lastPathComponent)")
        }
    }

    private func jsonEquals(_ lhs: Any, _ rhs: Any) -> Bool {
        guard let leftData = canonicalData(lhs), let rightData = canonicalData(rhs) else {
            return false
        }
        return leftData == rightData
    }

    private func canonicalData(_ value: Any) -> Data? {
        guard JSONSerialization.isValidJSONObject(value) else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: value, options: [.sortedKeys])
    }
}
