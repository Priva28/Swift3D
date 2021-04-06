//
//  ARDynamicProperty.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

public protocol ARDynamicProperty {
    var update: () -> Void { get set }
}
