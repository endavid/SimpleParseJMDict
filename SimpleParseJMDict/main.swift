//
//  main.swift
//  SimpleParseJMDict
//
//  Created by David Gavilan on 2022/05/21.
//

import Foundation

func main() {
    do {
        let jmDict = try parseCLI()
        jmDict.printStats()
    } catch {
        print(error.localizedDescription)
    }
}

main()


let s1 = "\n<pos>&n;</pos>\n<gloss>Blue Sky with a White Sun</gloss>\n<gloss g_type=\"expl\">party flag and emblem of the Kuomintang (Chinese Nationalist Party)</gloss>\n"
let m1 = try? captureXMLRecords(tag: "gloss", in: s1)
print(m1 ?? [])
