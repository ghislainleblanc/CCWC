//
//  main.swift
//  ccwc
//
//  Created by Ghislain Leblanc on 2023-11-30.
//

import Foundation

enum Option: String {
    case byteCount = "-c"
}

func handleCommandLineArguments() -> (Option?, String?)? {
    let arguments = CommandLine.arguments

    var index = 1
    while index < arguments.count {
        guard let option = Option(rawValue: arguments[index]) else {
            FileHandle.standardError.write("Unknown option: \(arguments[index])\n".data(using: .utf8)!)
            return nil
        }

        switch option {
        case .byteCount:
            index += 1
            guard arguments[safe: index] != nil else {
                FileHandle.standardError.write("Missing argument for -c [path]\n".data(using: .utf8)!)
                return nil
            }
            return (.byteCount, arguments[safe: index])
        }
    }

    return nil
}

if let option = handleCommandLineArguments() {
    switch option.0 {
    case .byteCount:
        guard let path = option.1, let fileSize = fileSize(at: path) else {
            break
        }
        print("\(fileSize) \(path)")
    case .none:
        break
    }
}

func fileSize(at path: String) -> UInt64? {
    do {
        let attributes = try FileManager.default.attributesOfItem(atPath: path)
        if let fileSize = attributes[FileAttributeKey.size] as? UInt64 {
            return fileSize
        } else {
            FileHandle.standardError.write("Failed to retrieve file size.\n".data(using: .utf8)!)
            return nil
        }
    } catch {
        FileHandle.standardError.write("Error: \(error)\n".data(using: .utf8)!)
        return nil
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
