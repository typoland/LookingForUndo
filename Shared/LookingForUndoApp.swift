//
//  LookingForUndoApp.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import SwiftUI

@main
struct LookingForUndoApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: LookingForUndoDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.pasteboard) {
                    Button("Delete", action: {
                        deleteSelectedObject.send()
                    })
                    .keyboardShortcut(.delete, modifiers: [])
                }
        }
    }
}
