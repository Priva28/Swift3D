//
//  ARDynamicProperty.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import Combine
import Foundation

public protocol DynamicProperty3D {
    var id: UUID? { get set }
    var subject: PassthroughSubject<UUID, Never>? { get set }
}