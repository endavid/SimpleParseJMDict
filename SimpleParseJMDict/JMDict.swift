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

enum Dialect: String, Codable {
    case Brazilian = "bra"
    case Hokkaido = "hob"
    case Kansai = "ksb"
    case Kantou = "ktb"
    case Kyoto = "kyb"
    case Kyuushuu = "kyu"
    case Nagano = "nab"
    case Osaka = "osb"
    case Ryuukyuu = "rkb"
    case Touhoku = "thb"
    case Tosa = "tsb"
    case Tsugaru = "tsug"
}

let DialectNames: [Dialect: String] = [
    .Brazilian: "Brazilian",
    .Hokkaido: "Hokkaido-ben",
    .Kansai: "Kansai-ben",
    .Kantou: "Kantou-ben",
    .Kyoto: "Kyoto-ben",
    .Kyuushuu: "Kyuushuu-ben",
    .Nagano: "Nagano-ben",
    .Osaka: "Osaka-ben",
    .Ryuukyuu: "Ryuukyuu-ben",
    .Touhoku: "Touhoku-ben",
    .Tosa: "Tosa-ben",
    .Tsugaru: "Tsugaru-ben"
]

enum Field: String, Codable {
    case agriculture = "agric"
    case anatomy = "anat"
    case archeology = "archeol"
    case architecture = "archit"
    case art = "art" // & aesthetics
    case astronomy = "astron"
    case audiovisual = "audvid"
    case aviation = "aviat"
    case baseball = "baseb"
    case biochemistry = "biochem"
    case biology = "biol"
    case botany = "bot"
    case buddhism = "Buddh"
    case business = "bus"
    case chemistry = "chem"
    case christianity = "Christn"
    case clothing = "cloth"
    case computing = "comp"
    case crystallography = "cryst"
    case ecology = "ecol"
    case economics = "econ"
    case electricity = "elec" // & elec. eng.
    case electronics = "electr"
    case embryology = "embryo"
    case engineering = "engr"
    case entomology = "ent"
    case finance = "finc"
    case fishing = "fish"
    case food = "food"
    case gardening = "gardn"
    case genetics = "genet"
    case geography = "geogr"
    case geology = "geol"
    case geometry = "geom"
    case go = "go"
    case golf = "golf"
    case grammar = "gramm"
    case greekMythology = "grmyth"
    case hanafuda = "hanaf"
    case horseRacing = "horse"
    case law = "law"
    case linguistics = "ling"
    case logic = "logic"
    case martialArts = "MA"
    case mahjong = "mahj"
    case mathematics = "math"
    case mechanicalEngineering = "mech"
    case medicine = "med"
    case meteorology = "met"
    case military = "mil"
    case music = "music"
    case ornithology = "ornith"
    case paleontology = "paleo"
    case pathology = "pathol"
    case pharmacy = "pharm"
    case philosophy = "phil"
    case photography = "photo"
    case physics = "physics"
    case physiology = "physiol"
    case printing = "print"
    case psychiatry = "psy"
    case psychology = "psych"
    case railway = "rail"
    case shinto = "Shinto"
    case shogi = "shogi"
    case sports = "sports"
    case statistics = "stat"
    case sumo = "sumo"
    case telecommunications = "telec"
    case trademark = "tradem"
    case videoGames = "vidg"
    case zoology = "zool"
}

let FieldNames: [Field: String] = [
    .agriculture: "agriculture",
    .anatomy: "anatomy",
    .archeology: "archeology",
    .architecture: "architecture",
    .art: "art",
    .astronomy: "astronomy",
    .audiovisual: "audiovisual",
    .aviation: "aviation",
    .baseball: "baseball",
    .biochemistry: "biochemistry",
    .biology: "biology",
    .botany: "botany",
    .buddhism: "buddhism",
    .business: "business",
    .chemistry: "chemistry",
    .christianity: "christianity",
    .clothing: "clothing",
    .computing: "computing",
    .crystallography: "crystallography",
    .ecology: "ecology",
    .economics: "economics",
    .electricity: "electricity",
    .electronics: "electronics",
    .embryology: "embryology",
    .engineering: "engineering",
    .entomology: "entomology",
    .finance: "finance",
    .fishing: "fishing",
    .food: "food",
    .gardening: "gardening",
    .genetics: "genetics",
    .geography: "geography",
    .geology: "geology",
    .geometry: "geometry",
    .go: "go",
    .golf: "golf",
    .grammar: "grammar",
    .greekMythology: "Greek Mythology",
    .hanafuda: "hanafuda",
    .horseRacing: "horse racing",
    .law: "law",
    .linguistics: "linguistics",
    .logic: "logic",
    .martialArts: "martial arts",
    .mahjong: "mahjong",
    .mathematics: "mathematics",
    .mechanicalEngineering: "mechanical engineering",
    .medicine: "medicine",
    .meteorology: "meteorology",
    .military: "military",
    .music: "music",
    .ornithology: "ornithology",
    .paleontology: "paleontology",
    .pathology: "pathology",
    .pharmacy: "pharmacy",
    .philosophy: "philosophy",
    .photography: "photography",
    .physics: "physics",
    .physiology: "physiology",
    .printing: "printing",
    .psychiatry: "psychiatry",
    .psychology: "psychology",
    .railway: "railway",
    .shinto: "Shinto",
    .shogi: "shogi",
    .sports: "sports",
    .statistics: "statistics",
    .sumo: "sumo",
    .telecommunications: "telecommunications",
    .trademark: "trademark",
    .videoGames: "video games",
    .zoology: "zoology"
]


class Sense: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    let dialects: Set<Dialect>
    let fields: Set<Field>
    let info: String?
    let meanings: [String] // glosses
    
    override var description: String {
        get {
            var s = ""
            if dialects.count > 0 {
                s = "[" + dialects.map{$0.rawValue}.sorted().joined(separator: ",") + "] "
            }
            if fields.count > 0 {
                s = "[" + fields.map{$0.rawValue}.sorted().joined(separator: ",") + "] "
            }
            if let info = info {
                s += "\(info). "
            }
            for i in 0..<meanings.count {
                s += "(\(i)) \(meanings[i]); "
            }
            return s
        }
    }
    
    init(dialects: Set<Dialect>, fields: Set<Field>, info: String?, meanings: [String]) {
        self.dialects = Set(dialects)
        self.fields = Set(fields)
        self.info = info
        self.meanings = meanings
    }

    required convenience init?(coder: NSCoder) {
        guard let dialects = coder.decodeObject(forKey: "dialects") as? [Dialect],
              let fields = coder.decodeObject(forKey: "fields") as? [Field],
              let meanings = coder.decodeObject(forKey: "meanings") as? [String] else {
            return nil
        }
        let info = coder.decodeObject(forKey: "info") as? String
        self.init(dialects: Set(dialects), fields: Set(fields), info: info, meanings: meanings)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(Array(dialects), forKey: "dialects")
        coder.encode(Array(fields), forKey: "fields")
        coder.encode(info, forKey: "info")
        coder.encode(meanings, forKey: "meanings")
    }
}

struct JMDictEntry {
    let readings: [String]
    let kanji: [String]
    let senses: [Sense]
}

class DictWord: NSObject, NSSecureCoding, Codable {
    static var supportsSecureCoding: Bool = true
    
    let reading: String
    let kanji: [String]
    let senses: [Sense]
    var writing: String {
        get {
            if kanji.isEmpty {
                return reading
            }
            return kanji.joined(separator: "、")
        }
    }
    override var description: String {
        get {
            let kanjis = kanji.joined(separator: "、")
            let ss = senses.map{$0.description}.joined(separator: "; ")
            return "\(reading) \(kanjis)： \(ss)"
        }
    }
    
    init(reading: String, kanji: [String], senses: [Sense]) {
        self.reading = reading
        self.kanji = kanji
        self.senses = senses
    }

    required convenience init?(coder: NSCoder) {
        guard let reading = coder.decodeObject(forKey: "reading") as? String,
              let kanji = coder.decodeObject(forKey: "kanji") as? [String],
              let senses = coder.decodeObject(forKey: "senses") as? [Sense] else {
            return nil
        }
        self.init(reading: reading, kanji: kanji, senses: senses)
    }

    func encode(with coder: NSCoder) {
        coder.encode(reading, forKey: "reading")
        coder.encode(kanji, forKey: "kanji")
        coder.encode(senses, forKey: "senses")
    }
}

/// Remove 1st and last character, so &hob; -> hob
func unentity(_ s: String) -> String {
    let i = s.index(from: 1)
    let j = s.index(from: s.count - 1)
    // &hob; -> hob
    return String(s[i..<j])
}

class JMDict: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    let words: [String: [DictWord]]
    let dialectalCount: [Dialect: Int]
    let fieldCount: [Field: Int]
    
    init(words: [String: [DictWord]], dialectalCount: [Dialect: Int], fieldCount: [Field: Int]) {
        self.words = words
        self.dialectalCount = dialectalCount
        self.fieldCount = fieldCount
    }
    
    required convenience init?(coder: NSCoder) {
        guard let words = coder.decodeObject(forKey: "words") as? [String: [DictWord]],
              let dialectalCount = coder.decodeObject(forKey: "dialectalCount") as? [Dialect: Int],
              let fieldCount = coder.decodeObject(forKey: "fieldCount") as? [Field: Int] else {
            return nil
        }
        self.init(words: words, dialectalCount: dialectalCount, fieldCount: fieldCount)
    }
    
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
        var dialectalCount: [Dialect: Int] = [:]
        var fieldCount: [Field: Int] = [:]
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
                    for sense in entry.senses {
                        for d in sense.dialects {
                            dialectalCount[d, default: 0] += 1
                        }
                        for f in sense.fields {
                            fieldCount[f, default: 0] += 1
                        }
                    }
                    // if already exists, append kanji and definitions (they should be paired)
                    words[oomojied, default: []].append(DictWord(reading: reading, kanji: entry.kanji, senses: entry.senses))
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
        // use the ja locale for sorting so ゔ come right after う, and not after ん
        // ref: http://endavid.com/index.php?entry=107
        let sortedSymbols = symbols.sorted {
            String($0).compare(String($1), options: .caseInsensitive, locale: Locale(identifier: "ja")) == .orderedAscending
        }
        print(sortedSymbols)
        self.words = words
        self.dialectalCount = dialectalCount
        self.fieldCount = fieldCount
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(words, forKey: "words")
        coder.encode(dialectalCount, forKey: "dialectalCount")
        coder.encode(fieldCount, forKey: "fieldCount")
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
        var senses: [Sense] = []
        let senseRecords = try captureXMLRecords(tag: "sense", in: xml)
        var missingDialects: Set<String> = []
        var missingFields: Set<String> = []
        for record in senseRecords {
            let glosses = try captureXMLRecords(tag: "gloss", in: record)
            let infos = try captureXMLRecords(tag: "s_info", in: record)
            // infos max count = 1
            if infos.count > 1 {
                print(infos)
            }
            let dials = try captureXMLRecords(tag: "dial", in: record)
            var dialects: Set<Dialect> = []
            for dial in dials {
                if let dialect = Dialect(rawValue: unentity(dial)) {
                    dialects.insert(dialect)
                } else {
                    missingDialects.insert(dial)
                }
            }
            let fieldRecords = try captureXMLRecords(tag: "field", in: record)
            var fields: Set<Field> = []
            for f in fieldRecords {
                if let field = Field(rawValue: unentity(f)) {
                    fields.insert(field)
                } else {
                    missingFields.insert(f)
                }
            }
            let sense = Sense(dialects: dialects, fields: fields, info: infos.first, meanings: glosses)
            senses.append(sense)
        }
        var kanji: [String] = []
        let k_eles = try captureXMLRecords(tag: "k_ele", in: xml)
        for k_ele in k_eles {
            let kebs = try captureXMLRecords(tag: "keb", in: k_ele)
            kanji.append(contentsOf: kebs)
        }
        if !missingDialects.isEmpty {
            print("Missing dialects: \(missingDialects)")
        }
        if !missingFields.isEmpty {
            print("Missing fields: \(missingFields)")
        }
        // do not convert any katakana to hiragana here;
        // when doing string comparison, use .hiragana as we'd use lowercase in English
        //let hiraganed = readings.compactMap { $0.hiragana }
        return JMDictEntry(readings: readings, kanji: kanji, senses: senses)
    }
    
    func printStats() {
        print("#words: \(words.count)")
        var homonyms = 0
        var dialectalSample: [Dialect: Set<String>] = [:]
        var fieldSample: [Field: Set<String>] = [:]
        for word in words {
            let entry = word.value
            if entry.count > 1 {
                homonyms += 1
            }
            if entry.count > 20 {
                let key = word.key
                let defs = entry.map { $0.description.replacingOccurrences(of: key, with: "") }
                var s = ""
                for i in 0..<defs.count {
                    s += "[\(i+1)] \(defs[i])\n"
                }
                print("\(key): \(s)")
            }
            for w in entry {
                for sense in w.senses {
                    for d in sense.dialects {
                        var samples = dialectalSample[d, default: []]
                        if samples.count < 10 {
                            samples.insert(w.writing)
                            dialectalSample[d] = samples
                        }
                    }
                    for f in sense.fields {
                        var samples = fieldSample[f, default: []]
                        if samples.count < 10 {
                            samples.insert(w.writing)
                            fieldSample[f] = samples
                        }
                    }
                }
            }
        }
        print("#homonyms: \(homonyms)")
        for (k, v) in dialectalSample {
            let name = DialectNames[k]!
            let count = dialectalCount[k] ?? 0
            print("\(name): \(count) words. E.g. " + v.joined(separator: ", "))
        }
        print("\nFields:\n")
        for (k, v) in fieldSample {
            let name = FieldNames[k]!
            let count = fieldCount[k] ?? 0
            print("\(name): \(count) words. E.g. " + v.joined(separator: ", "))
        }
    }
}
