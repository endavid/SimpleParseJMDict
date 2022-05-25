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


let s = "\n<pos>&unc;</pos>\n<xref>一の字点</xref>\n<gloss g_type=\"expl\">repetition mark in katakana</gloss>\n"
let m = getGroupsFromRegex(pattern: #"<gloss.*>(.*)</gloss>"#, in: s)
print(m)

let s1 = "<ent_seq>1000000</ent_seq>\n<r_ele>\n<reb>ヽ</reb>\n</r_ele>\n<sense>\n<pos>&unc;</pos>\n<xref>一の字点</xref>\n<gloss g_type=\"expl\">repetition mark in katakana</gloss>\n</sense>\n"
let m1 = getGroupsFromRegex(pattern: #"<r_ele.*>(.*)</r_ele>"#, in: s1)
print(m1)

let s2 = "<ent_seq>1000000</ent_seq>\n<r_ele>\n<reb>ヽ</reb>\n</r_ele>\n<sense>\n<pos>&unc;</pos>\n<xref>一の字点</xref>\n<gloss g_type=\"expl\">repetition mark in katakana</gloss>\n</sense>\n"
let m2 = getGroupsFromRegex(pattern: #"<sense.*>(.*)</sense>"#, in: s2)
print(m2)
let m3 = getGroupsFromRegex(pattern: #"<sense( .*)?>(.*)</sense>"#, in: s2)
print(m3)
