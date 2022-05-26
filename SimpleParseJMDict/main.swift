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

