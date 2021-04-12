//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = 0
    @State var y = 7
    var id = UUID()
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Box(chamferRadius: 0.4)
            .opacity(test == 0 ? 0.1 : 1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    test = 1
                    print("ran")
                }
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
