//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    var object: Object {
        Box()
    }
}

struct ContentView: View {
    var body: some View {
        Scene3D(baseObject: obj())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
