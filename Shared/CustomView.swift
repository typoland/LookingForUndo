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
    var body: some View {
        ZStack {
            ForEach(model.insideDoc.points.indices, id:\.self) { index in
                Circle()
                    .frame(width: 10, height: 10, alignment: .center)
                    .position(model.insideDoc.points[index])
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged{
                                    loc in model.insideDoc.points[index] = loc.location
                                    model.objectWillChange.send()
                                })
                
            }
        }.background(Color.black.opacity(0.01))
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded{ loc in
                        model.insideDoc.points.append(loc.location)
                        model.objectWillChange.send()
                    }
                 
        )
    }
}
