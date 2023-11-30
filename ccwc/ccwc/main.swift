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
            print("Unknown option: \(arguments[index])")
            return nil
        }

        switch option {
        case .byteCount:
            index += 1
            guard let argument = arguments[safe: index] else {
                print("Missing argument for -c [path]")
                return nil
            }
            return (.byteCount, argument)
        }
    }

    return nil
}

if let option = handleCommandLineArguments() {
    print(option)
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
