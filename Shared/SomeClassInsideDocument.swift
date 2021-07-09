//
//  SomeClassInsideDocument.swift
//  LookingForUndo (iOS)
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation

class SomeClassInsideDocument: Codable {
    var points: [CGPoint]
    init (points: [CGPoint] = []) {
        self.points = points
    }
}
