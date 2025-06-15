//
//  Strings+Whitespacing.swift
//  Cities
//
//  Created by Gonza Giampietri on 15/06/2025.
//

extension String {
    func removeWithespaces() -> String {
        self.filter { !$0.isWhitespace }
    }
}
