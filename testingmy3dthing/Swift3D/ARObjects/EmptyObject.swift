//
//  EmptyObject.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import Foundation
import Combine

public struct EmptyObject: ARObject {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public init() { }
    public var object: ARObject { self }
    public var id = UUID()
    public var attributes = ARObjectAttributes()
}
