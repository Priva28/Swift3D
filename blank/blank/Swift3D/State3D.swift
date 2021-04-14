//
//  ARState.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 4/4/21.
//

import Foundation
import SwiftUI

@propertyWrapper public class State3D<Value>: DynamicProperty3D {
    
    /// Set the initial default value.
    public init(wrappedValue value: Value) {
        self.storage.internalValue = value
    }
    
    /// This is the value that is accessed by default. Eg `@CustomState var test = 5` access this wrapped value with just `test`.
    public var wrappedValue: Value {
        /// Get the wrappedValue from the internal value of the model.
        get { self.storage.internalValue! }
        
        /// When a user changes the wrappedValue, it will change the internalValue meaning that with @CustomState, they can mutate and access a value without storing it in the struct/classes self.
        set {
            self.storage.internalValue = newValue
            self.update()
        }
    }
    
    public var update: () -> Void = { }
    
    private var storage = InternalStorage()
    
    private class InternalStorage {
        var internalValue: Value?
        /// Be nil by default, but this doesn't matter as when a @CustomState is created, the internalValue is set to the default it is created with.
        internal init() { self.internalValue = nil }
    }
}
