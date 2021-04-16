//
//  Scene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI
import SceneKit

public struct Scene3D: View, Scene3DProtocol {
    
    public init(baseObject: Object) {
        // Setup camera and scene.
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(cameraNode)
        
        // Initialise properties.
        self.scene = scene
        self.camera = cameraNode
        self.baseObject = baseObject
        self.baseObject.bindProperties(update)
        
        // Add lighting and objects to scene.
        scene.rootNode.addChildNode(ambientLight)
        scene.rootNode.addChildNode(directionalLight)
        scene.rootNode.addChildNode(baseObject.scnNode)
    }
    
    public var body: some View {
        SceneView(scene: scene, pointOfView: camera, options: [.allowsCameraControl, .jitteringEnabled])
    }
    
    internal var scene: SCNScene
    internal var baseObject: Object
    private var camera: SCNNode
    
    fileprivate init(
        baseObject: Object,
        backgroundColor: Color? = nil,
        backgroundImage: UIImage? = nil
    ) {
        self.init(baseObject: baseObject)
        
        if let backgroundColor = backgroundColor {
            scene.background.contents = UIColor(backgroundColor)
        }
        
        if let backgroundImage = backgroundImage {
            scene.background.contents = backgroundImage
        }
    }
}

extension Scene3D {
    public func backgroundColor(_ color: Color) -> some View {
        return Scene3D(baseObject: self.baseObject, backgroundColor: color)
    }
}

extension Scene3D {
    public func backgroundImage(_ image: UIImage) -> some View {
        return Scene3D(baseObject: self.baseObject, backgroundImage: image)
    }
}
