//
//  Util.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

enum XMLError: LocalizedError {
    case unclosedTag(tag: String)
    
    var errorDescription: String? {
        switch self {
        case .unclosedTag(let tag):
            return "Tag #\(tag) wasn't closed"
        }
    }
}

// https://stackoverflow.com/a/39677704
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    // https://stackoverflow.com/a/32306142/1765629
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    // https://www.egao-inc.co.jp/programming/swift_recipe7/
    var kana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: false)
    }
    var hiragana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: true)
    }
}

func getGroupsFromRegex(pattern: String, in line: String) -> [[String]] {
    let range = NSRange(location: 0, length: line.utf16.count)
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    guard let matches = regex?.matches(in: line, options: [], range: range) else {
        return []
    }
    var out: [[String]] = []
    for m in matches {
        var groups: [String] = []
        if m.numberOfRanges < 2 {
            continue
        }
        for i in 1..<m.numberOfRanges {
            if let r = Range(m.range(at: i), in: line) {
                groups.append(String(line[r]))
            }
        }
        out.append(groups)
    }
    return out
}

func captureXMLRecords(tag: String, in line: String) throws -> [String] {
    let tagOpens = line.indices(of: "<\(tag)>")
    let tagCloses = line.indices(of: "</\(tag)>")
    if tagOpens.count != tagCloses.count {
        throw XMLError.unclosedTag(tag: tag)
    }
    var out: [String] = []
    for i in 0..<tagOpens.count {
        let a = line.index(tagOpens[i], offsetBy: tag.count + 2)
        let b = tagCloses[i]
        let r = a..<b
        out.append(String(line[r]))
    }
    return out
}
