//
//  LookingForUndoDocument.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var crazyType: UTType {
        UTType(importedAs: "com.typoland.panic")
    }
}

class InsideDoc: Codable {
    var points: [CGPoint]
    init (points: [CGPoint] = []) {
        self.points = points
    }
}

struct LookingForUndoDocument: FileDocument {
    var insideDoc: InsideDoc

    init(points: [CGPoint] = [CGPoint(x: 20, y: 20)]) {
        self.insideDoc = InsideDoc(points: points)
    }
    
    static var readableContentTypes: [UTType] { [.crazyType] }
    static var writableContentTypes: [UTType] { [.crazyType] }

    init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
       
        guard let data = configuration.file.regularFileContents

        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        insideDoc = try decoder.decode(InsideDoc.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(insideDoc)
        return .init(regularFileWithContents: data)
    }
    
    var undoManager: UndoManager?
}
