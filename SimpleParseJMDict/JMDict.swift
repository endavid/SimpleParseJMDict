//
//  JMDict.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

enum JMDictError: LocalizedError {
    case unclosedEntry(lineNumber: Int)
    case expectedSingle(tag: String, word: String)
    
    var errorDescription: String? {
        switch self {
        case .unclosedEntry(let n):
            return "Entry #\(n) wasn't closed"
        case .expectedSingle(let tag, let word):
            return "More than one #\(tag) for word: \(word)"
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

enum MiscTag: String, Codable {
    case abbr = "abbr"
    case arch = "arch"
    case char = "char"
    case chn = "chn"
    case col = "col"
    case company = "company"
    case creat = "creat"
    case dated = "dated"
    case dei = "dei"
    case derog = "derog"
    case doc = "doc"
    case ev = "ev"
    case fam = "fam"
    case fem = "fem"
    case fict = "fict"
    case form = "form"
    case given = "given"
    case group = "group"
    case hist = "hist"
    case hon = "hon"
    case hum = "hum"
    case id = "id"
    case joc = "joc"
    case leg = "leg"
    case m_sl = "m-sl"
    case male = "male"
    case myth = "myth"
    case net_sl = "net-sl"
    case obj = "obj"
    case obs = "obs"
    case obsc = "obsc"
    case on_mim = "on-mim"
    case organization = "organization"
    case oth = "oth"
    case person = "person"
    case place = "place"
    case poet = "poet"
    case pol = "pol"
    case product = "product"
    case proverb = "proverb"
    case quote = "quote"
    case rare = "rare"
    case relig = "relig"
    case sens = "sens"
    case serv = "serv"
    case sl = "sl"
    case station = "station"
    case surname = "surname"
    case uk = "uk"
    case unclass = "unclass"
    case vulg = "vulg"
    case work = "work"
    case x = "X"
    case yoji = "yoji"
}

let MiscDescription: [MiscTag: String] = [
    .abbr: "abbreviation",
    .arch: "archaism",
    .char: "character",
    .chn: "children's language",
    .col: "colloquialism",
    .company: "company name",
    .creat: "creature",
    .dated: "dated term",
    .dei: "deity",
    .derog: "derogatory",
    .doc: "document",
    .ev: "event",
    .fam: "familiar language",
    .fem: "female term or language",
    .fict: "fiction",
    .form: "formal or literary term",
    .given: "given name or forename, gender not specified",
    .group: "group",
    .hist: "historical term",
    .hon: "honorific or respectful (sonkeigo) language",
    .hum: "humble (kenjougo) language",
    .id: "idiomatic expression",
    .joc: "jocular, humorous term",
    .leg: "legend",
    .m_sl: "manga slang",
    .male: "male term or language",
    .myth: "mythology",
    .net_sl: "Internet slang",
    .obj: "object",
    .obs: "obsolete term",
    .obsc: "obscure term",
    .on_mim: "onomatopoeic or mimetic word",
    .organization: "organization name",
    .oth: "other",
    .person: "full name of a particular person",
    .place: "place name",
    .poet: "poetical term",
    .pol: "polite (teineigo) language",
    .product: "product name",
    .proverb: "proverb",
    .quote: "quotation",
    .rare: "rare",
    .relig: "religion",
    .sens: "sensitive",
    .serv: "service",
    .sl: "slang",
    .station: "railway station",
    .surname: "family or surname",
    .uk: "word usually written using kana alone",
    .unclass: "unclassified name",
    .vulg: "vulgar expression or word",
    .work: "work of art, literature, music, etc. name",
    .x: "rude or X-rated term (not displayed in educational software)",
    .yoji: "yojijukugo"
]


class Sense: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    let dialects: Set<Dialect>
    let fields: Set<Field>
    let misc: Set<MiscTag>
    let info: String?
    let meanings: [String] // glosses
    
    var meaningList: String {
        get {
            return meanings.joined(separator: "; ")
        }
    }
    
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
            s += meaningList
            return s
        }
    }
    
    init(dialects: Set<Dialect>, fields: Set<Field>, misc: Set<MiscTag>, info: String?, meanings: [String]) {
        self.dialects = Set(dialects)
        self.fields = Set(fields)
        self.misc = Set(misc)
        self.info = info
        self.meanings = meanings
    }

    required convenience init?(coder: NSCoder) {
        guard let dialects = coder.decodeObject(forKey: "dialects") as? [String],
              let fields = coder.decodeObject(forKey: "fields") as? [String],
              let misc = coder.decodeObject(forKey: "misc") as? [String],
              let meanings = coder.decodeObject(forKey: "meanings") as? [String] else {
            return nil
        }
        let ds = dialects.compactMap { Dialect(rawValue: $0) }
        let fs = fields.compactMap { Field(rawValue: $0) }
        let ms = misc.compactMap { MiscTag(rawValue: $0) }
        let info = coder.decodeObject(forKey: "info") as? String
        self.init(dialects: Set(ds), fields: Set(fs), misc: Set(ms), info: info, meanings: meanings)
    }
    
    func encode(with coder: NSCoder) {
        let ds = dialects.map { $0.rawValue }
        let fs = fields.map { $0.rawValue }
        coder.encode(ds, forKey: "dialects")
        coder.encode(fs, forKey: "fields")
        coder.encode(info, forKey: "info")
        coder.encode(meanings, forKey: "meanings")
    }
}

struct JMDictEntry {
    let reading: String
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
            let ss = senses.map{$0.description}.joined(separator: "&& ")
            return "\(reading) \(kanjis)： \(ss)"
        }
    }
    var dictionaryDescription: String {
        get {
            let kanjis = kanji.joined(separator: "、")
            let ss = senses.map{$0.meaningList}.joined(separator: "; ")
            if kanjis.isEmpty {
                return ss
            }
            return "\(kanjis) ## \(ss)"
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
    
    func filterBySense(using closure: (Sense) -> Bool) -> DictWord? {
        let filtered = senses.filter(closure)
        if filtered.isEmpty {
            return nil
        }
        return DictWord(reading: reading, kanji: kanji, senses: filtered)
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
    let miscCount: [MiscTag: Int]
    
    init(words: [String: [DictWord]], dialectalCount: [Dialect: Int], fieldCount: [Field: Int], miscCount: [MiscTag: Int]) {
        self.words = words
        self.dialectalCount = dialectalCount
        self.fieldCount = fieldCount
        self.miscCount = miscCount
    }
    
    init(words: [String: [DictWord]]) {
        self.words = words
        var dCount: [Dialect: Int] = [:]
        var fCount: [Field: Int] = [:]
        var mCount: [MiscTag: Int] = [:]
        for (_, dwords) in words {
            for dw in dwords {
                for s in dw.senses {
                    for d in s.dialects {
                        dCount[d, default: 0] += 1
                    }
                    for f in s.fields {
                        fCount[f, default: 0] += 1
                    }
                    for m in s.misc {
                        mCount[m, default: 0] += 1
                    }
                }
            }
        }
        self.dialectalCount = dCount
        self.fieldCount = fCount
        self.miscCount = mCount
    }
    
    required convenience init?(coder: NSCoder) {
        guard let words = coder.decodeObject(forKey: "words") as? [String: [DictWord]],
              let dialectalCount = coder.decodeObject(forKey: "dialectalCount") as? [String: Int],
              let fieldCount = coder.decodeObject(forKey: "fieldCount") as? [String: Int], let miscCount = coder.decodeObject(forKey: "miscCount") as? [String: Int] else {
            return nil
        }
        var dMap: [Dialect: Int] = [:]
        dialectalCount.forEach { dMap[Dialect(rawValue: $0.key)!] = $0.value }
        var fMap: [Field: Int] = [:]
        fieldCount.forEach { fMap[Field(rawValue: $0.key)!] = $0.value }
        var mMap: [MiscTag: Int] = [:]
        miscCount.forEach { mMap[MiscTag(rawValue: $0.key)!] = $0.value }
        self.init(words: words, dialectalCount: dMap, fieldCount: fMap, miscCount: mMap)
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
        var miscCount: [MiscTag: Int] = [:]
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
                let entries = try JMDict.readEntry(xml: currentEntryLines)
                for entry in entries {
                    let reading = entry.reading
                    if reading.count < minWordLength {
                        skipped += 1
                        continue
                    }
                    let hiraganed = reading.hiragana
                    if hiraganed.contains("ゐ") || hiraganed.contains("ゑ") || hiraganed.contains("〜") {
                        // ignore very minor symbols. They only appear in these words:
                        // ウヰスキー whisky
                        // スヰーデン 瑞典 Sweden (not in the latest JMDict file)
                        // ゑびす 恵比寿 Ebisu
                        // モワァ〜ン whoosh
                        // あぼ〜ん deleted
                        // https://twitter.com/endavid/status/1530241999886069761?s=20&t=mQD5FqfbAeI6x7uGhOo1VQ
                        // should I also skip "んー what?" ??
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
                        for m in sense.misc {
                            miscCount[m, default: 0] += 1
                        }
                    }
                    if entry.kanji.count == 1 && reading.katakana == entry.kanji.first {
                        // use katakana for the reading for katakana words (single reading, no kanji)
                        words[oomojied, default: []].append(DictWord(reading: entry.kanji.first!, kanji: [], senses: entry.senses))
                    } else {
                        // we use append because there could be words sounding the same
                        words[oomojied, default: []].append(DictWord(reading: reading, kanji: entry.kanji, senses: entry.senses))
                    }
                }
                inEntry = false
                currentEntry += 1
            } else if inEntry {
                currentEntryLines.append(line)
            }
            // updates number of bytes read, for the next iteration
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
        print("Skipped \(skipped) readings shorter than \(minWordLength)")
        print("Symbols: ")
        // use the ja locale for sorting so ゔ come right after う, and not after ん
        // ref: http://endavid.com/index.php?entry=107
        let sortedSymbols = symbols.sorted {
            jaIncreasingOrder(String($0), String($1))
        }
        print(sortedSymbols)
        self.words = words
        self.dialectalCount = dialectalCount
        self.fieldCount = fieldCount
        self.miscCount = miscCount
    }
    
    func encode(with coder: NSCoder) {
        var dMap: [String: Int] = [:]
        dialectalCount.forEach { dMap[$0.key.rawValue] = $0.value }
        var fMap: [String: Int] = [:]
        fieldCount.forEach { fMap[$0.key.rawValue] = $0.value }
        var mMap: [String: Int] = [:]
        miscCount.forEach { mMap[$0.key.rawValue] = $0.value }
        coder.encode(words, forKey: "words")
        coder.encode(dMap, forKey: "dialectalCount")
        coder.encode(fMap, forKey: "fieldCount")
        coder.encode(mMap, forKey: "miscCount")
    }
    
    func sortedKeys() -> [String] {
        return words.keys.sorted(by: jaIncreasingOrder)
    }
    
    func flattenDictionary(senseFilter: ((Sense) -> Bool)? = nil) -> [String] {
        let keys = sortedKeys()
        var lines: [String] = []
        for key in keys {
            let list = words[key]!
            // group by reading, because the key しよう could correspond to both しょう and しよう
            var grouped: [String: [DictWord]] = [:]
            for w in list {
                grouped[w.reading, default: []].append(w)
            }
            var readings: [String] = []
            for (r, wlist) in grouped {
                var dictWords = wlist
                if let f = senseFilter {
                    dictWords = wlist.compactMap { $0.filterBySense(using: f) }
                }
                if !dictWords.isEmpty {
                    let defs = dictWords.map { $0.dictionaryDescription }.sorted(by: jaIncreasingOrder)
                    readings.append("【\(r)】" + defs.joined(separator: " // ") )
                }
            }
            if !readings.isEmpty {
                lines.append("\(key): " + readings.joined(separator: " || "))
            }
        }
        return lines
    }

    static func goodSense(_ s: Sense) -> Bool {
        if !s.dialects.isEmpty {
            return false
        }
        let miscNG: Set<MiscTag> = [
            .abbr,
            .arch,
            .char,
            .chn,
            .col,
            .company,
            .creat,
            .dated,
            .dei,
            .derog,
            .doc,
            .ev,
            .fict,
            .given,
            .group,
            .hist,
            .joc,
            .leg,
            .m_sl,
            .myth,
            .net_sl,
            .obj,
            .obs,
            .obsc,
            .oth,
            .person,
            .place,
            .poet,
            .product,
            .proverb,
            .quote,
            .rare,
            .relig,
            .sens,
            .serv,
            .sl,
            .station,
            .surname,
            .unclass,
            .vulg,
            .work,
            .x
        ]
        if !s.misc.intersection(miscNG).isEmpty {
            return false
        }
        return true
    }
    
    func dictionaryWithoutUselessWords() -> JMDict {
        var filteredWords: [String: [DictWord]] = [:]
        for (key, wlist) in words {
            let dictWords = wlist.compactMap { $0.filterBySense(using: JMDict.goodSense) }
            if !dictWords.isEmpty {
                filteredWords[key] = dictWords
            }
        }
        return JMDict(words: filteredWords)
    }
    
    /**
     Reads a <entry>, but it returns a list of JMDictEntry because each Entry corresponds to
     unique reading/kanji pairs. For instance 掌 can be read しょう, but しょう can't be the reading for 手のひら.
     */
    static func readEntry(xml: String) throws -> [JMDictEntry] {
        // for each reading, we also have a list of potential kanji form restrictions
        // If that list is empty, it means the list applies to all
        var readings: [String: Set<String>] = [:]
        let eles = try captureXMLRecords(tag: "r_ele", in: xml)
        for readingElement in eles {
            let rebs = try captureXMLRecords(tag: "reb", in: readingElement)
            if rebs.count > 1 {
                throw JMDictError.expectedSingle(tag: "reb", word: rebs.first!)
            }
            guard let r = rebs.first else {
                continue
            }
            let reading = r.replacingOccurrences(of: "・", with: "")
            if readingElement.contains("re_nokanji") {
                // not the true reading of the kanji
                // but if it's katakana, remember it
                if reading.hiragana != reading {
                    readings[reading] = readings[r, default: []].union([r])
                }
            } else {
                let restr = try captureXMLRecords(tag: "re_restr", in: readingElement)
                // メダル・ゲーム -> メダルゲーム
                readings[reading] = readings[r, default: []].union(Set(restr))
            }
        }
        var senses: [Sense] = []
        let senseRecords = try captureXMLRecords(tag: "sense", in: xml)
        var missingDialects: Set<String> = []
        var missingFields: Set<String> = []
        var missingMisc: Set<String> = []
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
            let miscRecords = try captureXMLRecords(tag: "misc", in: record)
            var misc: Set<MiscTag> = []
            for m in miscRecords {
                if let tag = MiscTag(rawValue: unentity(m)) {
                    misc.insert(tag)
                } else {
                    missingMisc.insert(m)
                }
            }
            let sense = Sense(dialects: dialects, fields: fields, misc: misc, info: infos.first, meanings: glosses)
            senses.append(sense)
        }
        var kanji: [String] = []
        let k_eles = try captureXMLRecords(tag: "k_ele", in: xml)
        for k_ele in k_eles {
            let kebs = try captureXMLRecords(tag: "keb", in: k_ele)
            kanji.append(contentsOf: kebs)
        }

        // readings with no specific restrictions, apply to all kanji
        for (r, restr) in readings {
            if restr.isEmpty {
                readings[r] = Set(kanji)
                if r.hiragana != r {
                    // we treat katakana as kanji, because the reading will always be in hiragana
                    readings[r]?.insert(r)
                }
            }
        }
        // now convert the readings to hiragana, with the full set
        // it's done in 2 stages so readings like オムツかぶれ do not make other kanji readings disappear, 御襁褓気触れ
        var readingsH: [String: Set<String>] = [:]
        for (r, restr) in readings {
            // アッというまに -> あっというまに, メダルゲーム -> めだるげーむ
            let reading = r.hiragana
            readingsH[reading] = readingsH[reading, default: []].union(Set(restr))
        }
        
        if !missingDialects.isEmpty {
            print("Missing dialects: \(missingDialects)")
        }
        if !missingFields.isEmpty {
            print("Missing fields: \(missingFields)")
        }
        if !missingMisc.isEmpty {
            print("Missing misc: \(missingMisc)")
        }
        // readingsH are all in hiragana, but the kanji list contains the katakana as well
        var entries: [JMDictEntry] = []
        for (r, restr) in readingsH {
            entries.append(JMDictEntry(reading: r, kanji: restr.sorted(by: jaIncreasingOrder), senses: senses))
        }
        return entries
    }
    
    func printStats() {
        print("#words: \(words.count)")
        var homonyms = 0
        var dialectalSample: [Dialect: Set<String>] = [:]
        var fieldSample: [Field: Set<String>] = [:]
        var miscSample: [MiscTag: Set<String>] = [:]
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
                    for m in sense.misc {
                        var samples = miscSample[m, default: []]
                        if samples.count < 10 {
                            samples.insert(w.writing)
                            miscSample[m] = samples
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
        print("\nMisc:\n")
        for (k, v) in miscSample {
            let name = MiscDescription[k]!
            let count = miscCount[k] ?? 0
            print("\(name): \(count) words. E.g. " + v.joined(separator: ", "))
        }
    }
}
