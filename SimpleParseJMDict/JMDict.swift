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

struct DictWord {
    let reading: String
    let kanji: [String]
    let definitions: [String]
}

class JMDict {
    let words: [String: DictWord]
    
    init(fileUrl: URL) throws {
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
        var currentEntry = 0
        var currentEntryLines = ""
        var words: [String: DictWord] = [:]
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
                    let hiraganed = reading.hiragana!
                    words[hiraganed] = DictWord(reading: reading, kanji: entry.kanji, definitions: entry.definitions)
                }
                inEntry = false
                currentEntry += 1
            } else if inEntry {
                currentEntryLines.append(line)
            }
            // updates number of bytes read, for the next iteration
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
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
        // random word sample
        var i = 0
        for word in words {
            print(word)
            i += 0
            if i > 200 {
                break
            }
        }
    }
}
