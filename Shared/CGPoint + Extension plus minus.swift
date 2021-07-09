//
//  CGPoint + Extension plus minus.swift
//  LookingForUndo (iOS)
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation

extension CGPoint {
    static func + (lhs:CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs:CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
