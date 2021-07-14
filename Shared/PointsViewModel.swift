//
//  PointsViewModel.swift
//  LookingForUndo (iOS)
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation
class PointsViewModel: ObservableObject {
    
    
    @Published var insideDoc: SomeClassInsideDocument
    @Published var selectionIndex: Int?
    
    init (insideDoc: SomeClassInsideDocument) {
        self.insideDoc = insideDoc
    }
    
    func movePoint(index: Int, to point: CGPoint) {
        insideDoc.points[index] = point
        objectWillChange.send()
    }
}
