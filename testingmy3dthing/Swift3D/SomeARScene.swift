//
//  SomeARScene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import SwiftUI
import SceneKit
import Combine

struct SomeARScene: ARObject {
    
    @CustomState var test: Int = 5
    public var subject = PassthroughSubject<UUID, Never>()
    
    var object: ARObject {
        Stack(.y) {
            AR4()
            Sphere(radius: 1)
                .color(test == 5 ? .green : .red)
            Stack(.z) {
                Sphere(radius: 1)
                    .color(.yellow)
                Box(size: ARSize(width: 3, height: 2, length: 3), chamferRadius: 0.1)
                    .color(.yellow)
                    .offset(z: test == 5 ? -2 : -5)
            }
            Stack(.x, spacing: 1) {
                Box(size: ARSize(width: 1, height: 2, length: 2))
                Sphere(radius: 1.3)
                Box(size: ARSize(width: 2, height: 2, length: 2))
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
    var attributes = ARObjectAttributes()
    
}

struct AR4: ARObject {
    @CustomState var test: Int = 5
    var object: ARObject {
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
    var attributes = ARObjectAttributes()
    public var subject = PassthroughSubject<UUID, Never>()
}
