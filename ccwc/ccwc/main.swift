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

func handleCommandLineArguments() -> Option? {
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
            return .byteCount
        }
    }

    return nil
}

if let option = handleCommandLineArguments() {
    print("Byte count")
}
