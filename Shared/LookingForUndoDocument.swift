//
//  LookingForUndoDocument.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static var whatever: UTType {
        UTType(importedAs: "com.typoland.panic")
    }
}


let deleteSelectedObject = PassthroughSubject<Void, Never>()

struct LookingForUndoDocument: FileDocument {
    
    var insideDoc: SomeClassInsideDocument
    @Environment(\.undoManager) var undoManager
    var myUndoManager = UndoManager()
    init(points: [CGPoint] = [CGPoint(x: 20, y: 20)]) {
        self.insideDoc = SomeClassInsideDocument(points: points)
        
    }
    
    static var readableContentTypes: [UTType] { [.whatever] }
    static var writableContentTypes: [UTType] { [.whatever] }

    init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
       
        guard let data = configuration.file.regularFileContents

        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        insideDoc = try decoder.decode(SomeClassInsideDocument.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(insideDoc)
        return .init(regularFileWithContents: data)
    }
    
}
