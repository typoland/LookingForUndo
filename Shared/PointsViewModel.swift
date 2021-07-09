//
//  PointsViewModel.swift
//  LookingForUndo (iOS)
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation
class PointsViewModel: ObservableObject {
    
    @Published var insideDoc: SomeClassInsideDocument
    init (insideDoc: SomeClassInsideDocument) {
        self.insideDoc = insideDoc
    }
    var undoManager: UndoManager?
    
    func movePoint(index: Int, to point: CGPoint) {
        insideDoc.points[index] = point
        objectWillChange.send()
    }
    func testUM() {
        print ("UndoManager in ViewModel \(undoManager)")
    }
}
