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

struct JMDictEntry {
    let readings: [String]
    let kanji: [String]
    let definitions: [String]
}

struct DictWord: CustomStringConvertible {
    var description: String {
        get {
            let kanjis = kanji.joined(separator: "、")
            let defs = definitions.joined(separator: "; ")
            return "\(reading) \(kanjis)： \(defs)"
        }
    }
    let reading: String
    let kanji: [String]
    let definitions: [String]
}

class JMDict {
    let words: [String: [DictWord]]
    
    init(fileUrl: URL, minWordLength: Int) throws {
        // https://stackoverflow.com/a/62112007/1765629
        guard let filePointer:UnsafeMutablePointer<FILE> = fopen(fileUrl.path,"r") else {
            preconditionFailure("Could not open file at \(fileUrl.absoluteString)")
        }
        
        // Not using the XMLParser because then I have to create a structure for all
        // the fields and I'm only interested in a few ones
        // let parser = XMLParser(contentsOf: fileUrl)
        
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
        var skipped = 0
        var currentEntry = 0
        var currentEntryLines = ""
        var words: [String: [DictWord]] = [:]
        var symbols: Set<Character> = []
        while (bytesRead > 0) {
            // note: this translates the sequence of bytes to a string using UTF-8 interpretation
            let line = String.init(cString:lineByteArrayPointer!)
            
            if line.starts(with: "<entry>") {
                if inEntry {
                    throw JMDictError.unclosedEntry(lineNumber: currentEntry)
                }
                inEntry = true
                currentEntryLines = ""
            } else if line.starts(with: "</entry>") {
                // instead of keeping all the file in memory, we parse a few lines at a time,
                // the <entry>...</entry> block
                let entry = try JMDict.readEntry(xml: currentEntryLines)
                for reading in entry.readings {
                    if reading.count < minWordLength {
                        skipped += 1
                        continue
                    }
                    let hiraganed = reading.hiragana!
                    if hiraganed.contains("ゐ") || hiraganed.contains("ゑ") || hiraganed.contains("〜") || hiraganed.contains("ー") {
                        // ignore very minor symbols. They only appear in these words:
                        // ウヰスキー whisky
                        // スヰーデン 瑞典 Sweden (not in the latest JMDict file)
                        // ゑびす 恵比寿 Ebisu
                        // モワァ〜ン whoosh
                        // あぼ〜ん deleted
                        // んー what? https://twitter.com/endavid/status/1530241999886069761?s=20&t=mQD5FqfbAeI6x7uGhOo1VQ
                        print("ignoring \(reading)...")
                        continue
                    }
                    // small kana to big kana, and remove dot
                    let oomojied = hiraganed.oomoji
                    for char in oomojied {
                        symbols.insert(char)
                    }
                    // if already exists, append kanji and definitions (they should be paired)
                    words[oomojied, default: []].append(DictWord(reading: reading, kanji: entry.kanji, definitions: entry.definitions))
                }
                inEntry = false
                currentEntry += 1
            } else if inEntry {
                currentEntryLines.append(line)
            }
            // updates number of bytes read, for the next iteration
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
        print("Skipped \(skipped) readings")
        print("Symbols: ")
        print(symbols.sorted())
        self.words = words
    }
    
    static func readEntry(xml: String) throws -> JMDictEntry {
        var readings: [String] = []
        let eles = try captureXMLRecords(tag: "r_ele", in: xml)
        for readingElement in eles {
            if readingElement.contains("re_nokanji") {
                // not the true reading of the kanji; skip
                continue
            }
            let rebs = try captureXMLRecords(tag: "reb", in: readingElement)
            readings.append(contentsOf: rebs)
        }
        var definitions: [String] = []
        let senses = try captureXMLRecords(tag: "sense", in: xml)
        for sense in senses {
            let glosses = try captureXMLRecords(tag: "gloss", in: sense)
            definitions.append(contentsOf: glosses)
        }
        var kanji: [String] = []
        let k_eles = try captureXMLRecords(tag: "k_ele", in: xml)
        for k_ele in k_eles {
            let kebs = try captureXMLRecords(tag: "keb", in: k_ele)
            kanji.append(contentsOf: kebs)
        }
        // do not convert any katakana to hiragana here;
        // when doing string comparison, use .hiragana as we'd use lowercase in English
        //let hiraganed = readings.compactMap { $0.hiragana }
        return JMDictEntry(readings: readings, kanji: kanji, definitions: definitions)
    }
    
    func printStats() {
        print("#words: \(words.count)")
        var homonyms = 0
        for word in words {
            if word.value.count > 1 {
                homonyms += 1
            }
            if word.value.count > 10 {
                let key = word.key
                let defs = word.value.map { $0.description.replacingOccurrences(of: key, with: "") }
                var s = ""
                for i in 0..<defs.count {
                    s += "[\(i+1)] \(defs[i])\n"
                }
                print("\(key): \(s)")
            }
        }
        print("#homonyms: \(homonyms)")
    }
}
