//
//  SomeARScene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI
import SceneKit
import Combine

struct SomeARScene: Object {
    
    @State3D var test: Int = 5
    public var subject = PassthroughSubject<UUID, Never>()
    
    var object: Object {
        Stack(.y) {
            AR4()
            Sphere(radius: 1)
                .color(test == 5 ? .green : .red)
            Stack(.z) {
                Sphere(radius: 1)
                    .color(.yellow)
                Box(size: Size3D(width: 3, height: 2, length: 3), chamferRadius: 0.1)
                    .chamferRadius(20)
                    .color(.yellow)
                    .offset(z: test == 5 ? -2 : -5)
            }
            Stack(.x, spacing: 1) {
                Box(size: Size3D(width: 1, height: 2, length: 2))
                Sphere(radius: 1.3)
                Box(size: Size3D(width: 2, height: 2, length: 2))
                Sphere(radius: 1.3)
                Sphere(radius: 1.3)
                    .color(.blue)
            }
            .color(.red)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let sub = subject.sink { id in
                        print(id)
                    }
                    test = 6
                }
            }
        }
    }
    
    var id: UUID = UUID()
    var attributes = ObjectAttributes()
    
}

struct First: Object {
    var object: Object {
        Box()
    }
}

struct AR4: Object {
    @State3D var test: Int = 5
    var object: Object {
        if test == 5 {
            return Sphere(radius: 1)
                .color(.green)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        //test = 6
                    }
                }
        } else {
            return Sphere(radius: 5)
                .color(.red)
        }
        
    }
    
    var id: UUID = UUID()
    var attributes = ObjectAttributes()
    public var subject = PassthroughSubject<UUID, Never>()
}