//
//  EmptyObject.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import Foundation
import Combine

public struct EmptyObject: Object {
    public var subject = PassthroughSubject<UUID, Never>()
    
    public init() { }
    public var object: Object { self }
    public var id = UUID()
    public var attributes = ObjectAttributes()
}