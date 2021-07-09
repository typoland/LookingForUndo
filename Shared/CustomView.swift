//
//  CustomView.swift
//  LookingForUndo
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import Foundation
import SwiftUI


struct CustomView: View {
    @ObservedObject var model: PointsViewModel
    @State var selectionIndex : Int?
    
    @Environment(\.undoManager) var undoManager
    @GestureState var isDragging: Bool = false
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 5
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(model.insideDoc.points.indices, id:\.self) { index in
                    HStack {
                        TextField("X", value: $model.insideDoc.points[index].x, formatter: formatter)
                            .frame(width: 80, alignment: .topLeading)
                        TextField("Y", value: $model.insideDoc.points[index].y, formatter: formatter)
                            .frame(width: 80, alignment: .topLeading)
                        Spacer()
                    }
                    
                }
                Spacer()
            }
        ZStack {
            ForEach(model.insideDoc.points.indices, id:\.self) { index in
                Circle()
                    .foregroundColor(index == selectionIndex ? .red : .blue)
                    .frame(width: 20, height: 20, alignment: .center)
                    .position(model.insideDoc.points[index])
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { drag in
                                    print ("CHANGED")
                                    if !isDragging {
                                        selectionIndex = index
                                        let now = model.insideDoc.points
                                        undoManager?.registerUndo(withTarget: model, handler: { model in
                                            model.insideDoc.points = now
                                            model.objectWillChange.send()
                                        })
                                        undoManager?.setActionName("undo Drag")
                                    }
                                    
                                }
                                .updating($isDragging, body: { drag, state, trans in
                                    model.insideDoc.points[index] = drag.location
                                    state = true
                                    model.objectWillChange.send()
                                })
                                .onEnded({drag in selectionIndex = index
                                    model.insideDoc.points[index] = drag.location
                                })
                    )
                
            }
        }.background(Color.black.opacity(0.01))
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded{ loc in
                        model.insideDoc.points.append(loc.location)
                        model.objectWillChange.send()
                    }
                 
        )
        .gesture(TapGesture().onEnded({selectionIndex = nil}))
        .onReceive(deleteSelectedObject, perform: { _ in
            if let deleteIndex = selectionIndex {
                let deleted = model.insideDoc.points[deleteIndex]
                undoManager?.registerUndo(withTarget: model, handler: {model in
                    model.insideDoc.points.insert(deleted, at: deleteIndex)
                    model.objectWillChange.send()
                })
                undoManager?.setActionName("remove Point")
                model.insideDoc.points.remove(at: deleteIndex)
                model.objectWillChange.send()
                selectionIndex = nil
            }
        })
        
    }
    }
}
