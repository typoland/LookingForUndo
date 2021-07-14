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
            
            @Environment(\.undoManager) var undoManager
            
            @GestureState var isDragging: Bool = false
            @State var dragOffsetDelta = CGPoint.zero
            
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
                            .foregroundColor(index == model.selectionIndex ? .red : .blue)
                            .frame(width: 20, height: 20, alignment: .center)
                            .position(model.insideDoc.points[index])
                            
                            //MARK: - drag point
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged { drag in
                                            if !isDragging {
                                                dragOffsetDelta = drag.location - model.insideDoc.points[index]
                                                model.selectionIndex = index
                                                let now = model.insideDoc.points[index]
                                                undoManager?.registerUndo(withTarget: model, handler: { model in
                                                    model.insideDoc.points[index] = now
                                                    model.objectWillChange.send()
                                                })
                                                undoManager?.setActionName("undo Drag")
                                            }
                                            model.insideDoc.points[index] = drag.location - dragOffsetDelta
                                        }
                                        .updating($isDragging, body: { drag, state, trans in
                                            state = true
                                            model.objectWillChange.send()
                                        })
                                        .onEnded({drag in model.selectionIndex = index
                                            model.insideDoc.points[index] = drag.location - dragOffsetDelta
                                            model.objectWillChange.send()
                                        })
                            )
                        
                    }
                }.background(Color.orange.opacity(0.5))
                
                //MARK: - new point
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded{ loc in
                                let previousIndex = model.selectionIndex
                                undoManager?.registerUndo(withTarget: model, handler: {model in
                                    model.insideDoc.points.removeLast()
                                    model.selectionIndex = previousIndex
                                    model.objectWillChange.send()
                                })
                                model.insideDoc.points.append(loc.location)
                                model.selectionIndex = model.insideDoc.points.count - 1
                                model.objectWillChange.send()
                            }
                         
                )
                
                //MARK: - delete point
                .onReceive(deleteSelectedObject, perform: { _ in
                    if let deleteIndex = model.selectionIndex {
                        let deleted = model.insideDoc.points[deleteIndex]
                        undoManager?.registerUndo(withTarget: model, handler: {model in
                            model.insideDoc.points.insert(deleted, at: deleteIndex)
                            model.objectWillChange.send()
                        })
                        undoManager?.setActionName("remove Point")
                        model.insideDoc.points.remove(at: deleteIndex)
                        model.objectWillChange.send()
                        model.selectionIndex = nil
                    }
                })
                
            }
            }
        }
