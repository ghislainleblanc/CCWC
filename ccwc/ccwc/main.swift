//
//  main.swift
//  ccwc
//
//  Created by Ghislain Leblanc on 2023-11-30.
//

import Foundation

enum Option: String {
    case byteCount = "-c"
    case lineCount = "-l"
    case wordCount = "-w"
    case charCount = "-m"
}

func handleCommandLineArguments() -> (Option?, String?)? {
    let arguments = CommandLine.arguments

    var index = 1
    while index < arguments.count {
        guard let option = Option(rawValue: arguments[index]) else {
            return (nil, arguments[safe: index])
        }

        switch option {
        case .byteCount:
            index += 1
            guard arguments[safe: index] != nil else {
                FileHandle.standardError.write("Missing argument for -c [path]\n".data(using: .utf8)!)
                return nil
            }
            return (.byteCount, arguments[safe: index])
        case .lineCount:
            index += 1
            guard arguments[safe: index] != nil else {
                FileHandle.standardError.write("Missing argument for -l [path]\n".data(using: .utf8)!)
                return nil
            }
            return (.lineCount, arguments[safe: index])
        case .wordCount:
            index += 1
            guard arguments[safe: index] != nil else {
                FileHandle.standardError.write("Missing argument for -w [path]\n".data(using: .utf8)!)
                return nil
            }
            return (.wordCount, arguments[safe: index])
        case .charCount:
            index += 1
            guard arguments[safe: index] != nil else {
                FileHandle.standardError.write("Missing argument for -m [path]\n".data(using: .utf8)!)
                return nil
            }
            return (.charCount, arguments[safe: index])
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
        print("\t\(fileSize) \(path)")
    case .lineCount:
        guard let path = option.1, let string = readFile(at: path), let lineCount = lineCount(from: string) else {
            break
        }
        print("\t\(lineCount) \(path)")
    case .wordCount:
        guard let path = option.1, let string = readFile(at: path), let wordCount = wordCount(from: string) else {
            break
        }
        print("\t\(wordCount) \(path)")
    case .charCount:
        guard let path = option.1, let string = readFile(at: path), let charCount = charCount(from: string) else {
            break
        }
        print("\t\(charCount) \(path)")
    case .none:
        guard
            let path = option.1,
            let fileSize = fileSize(at: path),
            let string = readFile(at: path),
            let lineCount = lineCount(from: string),
            let wordCount = wordCount(from: string)
        else {
            break
        }
        print("\t\(lineCount)\t\(wordCount)\t\(fileSize) \(path)")
    }
}

func readFile(at path: String) -> String? {
    do {
        let fileURL = URL(fileURLWithPath: path)
        let stringFileContent = try String(contentsOf: fileURL, encoding: .utf8)

        return stringFileContent
    } catch {
        FileHandle.standardError.write("Error: \(error)\n".data(using: .utf8)!)
        return nil
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

func lineCount(from string: String) -> Int? {
    string.filter { $0 == "\r\n" }.count
}

func wordCount(from string: String) -> Int? {
    string.split { $0.isWhitespace }.count
}

func charCount(from string: String) -> Int? {
    string.unicodeScalars.count
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
