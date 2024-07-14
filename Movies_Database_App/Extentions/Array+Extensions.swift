//
//  Array+Extensions.swift
//  Movies_Database_App
//
//  Created by Sameer on 13/07/24.
//

import Foundation

extension Array where Element: Hashable {
    // For getting unique elements in the array
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}
