//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = 0
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.x) {
            Box(chamferRadius: 0.1)
                .color(test == 0 ? .white : .red)
                .opacity(test == 0 ? 0.1 : 1)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        test = 3
                    }
                }
            Box(chamferRadius: 0.1)
                .color(test == 0 ? .white : .yellow)
                .opacity(test == 0 ? 0.1 : 1)
                .offset(z: test == 0 ? 1 : 0.1)
        }
        
    }
}

struct ContentView: View {
    var body: some View {
        Scene3D(baseObject: obj())
            .backgroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
