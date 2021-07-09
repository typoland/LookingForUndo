//
//  ContentView.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 09/07/2021.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: LookingForUndoDocument

    var body: some View {
        CustomView(model: PointsViewModel(insideDoc: document.insideDoc))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(LookingForUndoDocument()))
    }
}
