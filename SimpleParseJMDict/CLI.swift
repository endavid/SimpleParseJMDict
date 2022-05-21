//
//  CLI.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

enum CLIError: LocalizedError {
    case noInputFile
    case fileDoesNotExist(name: String)
    
    var errorDescription: String? {
        switch self {
        case .noInputFile:
            return "No input file"
        case .fileDoesNotExist(let f):
            return "\(f) does not exist"
        }
    }
}

func parseCLI() throws -> JMDict {
    if CommandLine.arguments.count == 1 {
        throw CLIError.noInputFile
    }
    let filename = CommandLine.arguments[1]
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: filename) {
        throw CLIError.fileDoesNotExist(name: filename)
    }
    let fileUrl = URL(fileURLWithPath: filename)
    return try JMDict(fileUrl: fileUrl)
}
