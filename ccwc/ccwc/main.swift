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
            return (.byteCount, arguments[safe: index])
        case .lineCount:
            index += 1
            return (.lineCount, arguments[safe: index])
        case .wordCount:
            index += 1
            return (.wordCount, arguments[safe: index])
        case .charCount:
            index += 1
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
        guard
            let string = readFile(at: option.1) ?? readLine(),
            let lineCount = lineCount(from: string)
        else {
            break
        }
        print("\t\(lineCount) \(option.1 ?? "")")
    case .wordCount:
        guard
            let string = readFile(at: option.1) ?? readLine(),
            let wordCount = wordCount(from: string)
        else {
            break
        }
        print("\t\(wordCount) \(option.1 ?? "")")
    case .charCount:
        guard
            let string = readFile(at: option.1) ?? readLine(),
            let charCount = charCount(from: string) else {
            break
        }
        print("\t\(charCount) \(option.1 ?? "")")
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
} else {
    guard
        let string = readLine(),
        let lineCount = lineCount(from: string),
        let wordCount = wordCount(from: string),
        let charCount = charCount(from: string)
    else {
        exit(1)
    }
    print("\t\(lineCount)\t\(wordCount)\t\(charCount)")
}

func readFile(at path: String?) -> String? {
    guard let path else { return nil }
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
