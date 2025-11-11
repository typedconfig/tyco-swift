import Foundation
import CTyco

public enum TycoError: Error {
    case failure(String)
}

public enum Tyco {
    public static func loadFile(_ path: String) throws -> Any {
        var result = tyco_parse_file_json(path)
        defer { tyco_json_result_free(&result) }
        guard result.status == TYCO_OK, let jsonCString = result.json else {
            let message = result.error.map { String(cString: $0) } ?? "Unknown error"
            throw TycoError.failure(message)
        }
        let jsonString = String(cString: jsonCString)
        return try parse(jsonString: jsonString)
    }

    public static func loadString(_ content: String, name: String = "<string>") throws -> Any {
        var result = tyco_parse_string_json(content, name)
        defer { tyco_json_result_free(&result) }
        guard result.status == TYCO_OK, let jsonCString = result.json else {
            let message = result.error.map { String(cString: $0) } ?? "Unknown error"
            throw TycoError.failure(message)
        }
        let jsonString = String(cString: jsonCString)
        return try parse(jsonString: jsonString)
    }

    private static func parse(jsonString: String) throws -> Any {
        let data = Data(jsonString.utf8)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
}
