//
//  JMDict.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

enum JMDictError: LocalizedError {
    case unclosedEntry(lineNumber: Int)
    
    var errorDescription: String? {
        switch self {
        case .unclosedEntry(let n):
            return "Entry #\(n) wasn't closed"
        }
    }
}

class JMDict {
    let wordCount: Int
    
    init(fileUrl: URL) throws {
        // https://stackoverflow.com/a/62112007/1765629
        guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileUrl.path,"r") else {
            preconditionFailure("Could not open file at \(fileUrl.absoluteString)")
        }
        // a pointer to a null-terminated, UTF-8 encoded sequence of bytes
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        // see the official Swift documentation for more information on the `defer` statement
        // https://docs.swift.org/swift-book/ReferenceManual/Statements.html#grammar_defer-statement
        defer {
            // remember to close the file when done
            fclose(filePointer)
            // The buffer should be freed by even if getline() failed.
            lineByteArrayPointer?.deallocate()
        }
        // the smallest multiple of 16 that will fit the byte array for this line
        var lineCap: Int = 0
        // initial iteration
        var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        
        var inEntry = false
        var currentEntry = 0
        while (bytesRead > 0) {
            // note: this translates the sequence of bytes to a string using UTF-8 interpretation
            let line = String.init(cString:lineByteArrayPointer!)
            
            if line.starts(with: "<entry>") {
                if inEntry {
                    throw JMDictError.unclosedEntry(lineNumber: currentEntry)
                }
            } else if line.starts(with: "</entry>") {
                inEntry = false
                currentEntry += 1
            }
            // updates number of bytes read, for the next iteration
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
        wordCount = currentEntry
    }
    
    func printStats() {
        print("wordCount: \(wordCount)")
    }
}
