//
//  String_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 05/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension String {

    private func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    /// Returns the substring, starting from the given character to the end.
    /// For example: "abcdef"[3...] returns "def".
    ///
    /// - Parameter from: The position of the first character to be returned.
    /// - Returns: A substring of this string, starting from the given character to the end.
    ///
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(_ range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    func realigned() -> String {
        var s1 = self.trimmingCharacters(in: .whitespacesAndNewlines)
//        while let rangeToReplace = s1.rangeOfCharacter(from: .newlines) {
//            s1.replaceSubrange(rangeToReplace, with: " ")
//        }
        while let rangeToReplace = s1.range(of: "... ") {
            s1.replaceSubrange(rangeToReplace, with: "...\n")
        }
//        while let rangeToReplace = s1.range(of: "ST.\n") {
//            s1.replaceSubrange(rangeToReplace, with: "ST. ")
//        }
        return s1
    }
}
