//
//  LookingForUndoApp.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import SwiftUI

@main
struct LookingForUndoApp: App {
    @Environment(\.undoManager) var undoManager
    var body: some Scene {
        DocumentGroup(newDocument: LookingForUndoDocument()) { file in
            ContentView(document: file.$document).onAppear {
                print ("UNDO?? \(undoManager)")
            }
        }
    }
}
