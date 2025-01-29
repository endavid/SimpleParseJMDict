# SimpleParseJMDict

A command-line tool written in Swift to process JMDict and get some stats from it.

## Usage

```bash
SimpleParseJMDict <JMDict.xml> (<outputPrefix>)
```

If `outputPrefix` is specified, it will save the dictionary as JSON and as an archive, using `NSKeyedArchiver`.


## Relevant classes 

Important for decoding the archive:

```swift
enum Dialect: String
enum Field: String 
struct Sense {
    let dialects: Set<Dialect>
    let fields: Set<Field>
    let info: String?
    let meanings: [String] 
}
struct DictWord {
    let reading: String
    let kanji: [String]
    let senses: [Sense]
}
class JMDict {
    let words: [String: [DictWord]]
    let dialectalCount: [Dialect: Int]
    let fieldCount: [Field: Int]
}
```
