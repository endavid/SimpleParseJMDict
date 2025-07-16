//
//  main.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

func saveJSON(codable: Codable, outURL: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let jsonData = try encoder.encode(codable)
    try jsonData.write(to: outURL, options: .atomic)
}

func saveArchive(obj: NSObject, outURL: URL) throws {
    let data = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
    try data.write(to: outURL)
}

func saveLines(_ lines: [String], outURL: URL) throws {
    let s = lines.joined(separator: "\n")
    try s.write(to: outURL, atomically: true, encoding: .utf8)
}

func main() {
    do {
        let (jmDict, outPrefix) = try parseCLI()
        if let outPrefix {
            try saveJSON(codable: jmDict, outURL: URL(fileURLWithPath: "\(outPrefix).json"))
            try saveArchive(obj: jmDict, outURL: URL(fileURLWithPath: "\(outPrefix).archive"))
            try saveLines(jmDict.sortedKeys(), outURL: URL(fileURLWithPath: "\(outPrefix)-keysAll.txt"))
            try saveLines(jmDict.flattenDictionary(), outURL: URL(fileURLWithPath: "\(outPrefix)-dictAll.txt"))
            try saveLines(jmDict.flattenDictionary(senseFilter: {$0.misc.contains(.vulg)}), outURL: URL(fileURLWithPath: "\(outPrefix)-vulgar.txt"))
            let goodDict = jmDict.dictionaryWithoutUselessWords()
            let keys = goodDict.sortedKeys()
            try saveLines(keys, outURL: URL(fileURLWithPath: "\(outPrefix)-keys.txt"))
            try saveLines(goodDict.flattenDictionary(), outURL: URL(fileURLWithPath: "\(outPrefix)-dict.txt"))
            let keysMin3 = keys.filter { $0.count >= 3 && $0.count <= 12 }
            try saveLines(keysMin3, outURL: URL(fileURLWithPath: "\(outPrefix)-keys3.txt"))
        }
        jmDict.printStats()
    } catch {
        print(error)
    }
}

main()

