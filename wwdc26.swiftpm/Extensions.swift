//
//  Extensions.swift
//  wwdc26
//
//  Created by Sofia Villas Bôas on 04/02/26.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
