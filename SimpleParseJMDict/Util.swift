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
    var kana: String {
        return self.applyingTransform(.hiraganaToKatakana, reverse: false)!
    }
    var hiragana: String {
        // we want to keep the ー !!
        // .hiraganaToKatakana transforms シュー into しゅう, but I want しゅー actually...
        // so small trick is to replace ー by another symbol...
        var s = self.replacingOccurrences(of: "ー", with: "＊")
        s = s.applyingTransform(.hiraganaToKatakana, reverse: true)!
        return s.replacingOccurrences(of: "＊", with: "ー")
    }
    var oomoji: String {
        // ["〜", "ぁ", "あ", "ぃ", "い", "ぅ", "う", "ぇ", "え", "ぉ", "お", "か", "が", "き", "ぎ", "く", "ぐ", "け", "げ", "こ", "ご", "さ", "ざ", "し", "じ", "す", "ず", "せ", "ぜ", "そ", "ぞ", "た", "だ", "ち", "ぢ", "っ", "つ", "づ", "て", "で", "と", "ど", "な", "に", "ぬ", "ね", "の", "は", "ば", "ぱ", "ひ", "び", "ぴ", "ふ", "ぶ", "ぷ", "へ", "べ", "ぺ", "ほ", "ぼ", "ぽ", "ま", "み", "む", "め", "も", "ゃ", "や", "ゅ", "ゆ", "ょ", "よ", "ら", "り", "る", "れ", "ろ", "ゎ", "わ", "ゐ", "ゑ", "を", "ん", "ゔ", "・"]
        var s = self.replacingOccurrences(of: "・", with: "")
        s = s.replacingOccurrences(of: "ぁ", with: "あ")
        s = s.replacingOccurrences(of: "ぃ", with: "い")
        s = s.replacingOccurrences(of: "ぅ", with: "う")
        s = s.replacingOccurrences(of: "ぇ", with: "え")
        s = s.replacingOccurrences(of: "ぉ", with: "お")
        s = s.replacingOccurrences(of: "ぉ", with: "お")
        s = s.replacingOccurrences(of: "っ", with: "つ")
        s = s.replacingOccurrences(of: "ゃ", with: "や")
        s = s.replacingOccurrences(of: "ゅ", with: "ゆ")
        s = s.replacingOccurrences(of: "ょ", with: "よ")
        s = s.replacingOccurrences(of: "ゎ", with: "わ")
        return s
    }
}

func getGroupsFromRegex(pattern: String, in line: String) -> [[String]] {
    let range = NSRange(location: 0, length: line.utf16.count)
    let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
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
    let closingTag = "</\(tag)>"
    let closings = line.indices(of: closingTag)
    var matches: [String] = []
    var start = line.startIndex
    for i in closings {
        let end = line.index(i, offsetBy: closingTag.count)
        let s = String(line[start..<end])
        // (?:...) non-capturing parentheses
        let m = getGroupsFromRegex(pattern: "<\(tag)(?: .*)?>(.*)</\(tag)>", in: s)
        let flat = m.flatMap { $0 }
        matches.append(contentsOf: flat)
        start = end
    }
    return matches
}
