//
//  PointsViewModel.swift
//  LookingForUndo (iOS)
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation
class PointsViewModel: ObservableObject {
    @Published var insideDoc: InsideDoc
    init (insideDoc: InsideDoc) {
        self.insideDoc = insideDoc
    }
}
