//
//  Scene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI
import SceneKit

public struct Scene3D: View {
    public var body: some View {
        SceneView(scene: scene, pointOfView: camera, options: [.allowsCameraControl, .autoenablesDefaultLighting])
    }
    
    private var scene: SCNScene
    
    private var camera: SCNNode
    private var baseObject: Object
    
    private func update() {
        scene.rootNode.enumerateChildNodes { node, stop in
            if let name = node.name, name.contains("opacity") {
                let stringId = String(node.name!.dropLast(7))
                print(stringId)
                let newNode = baseObject.childWithId(uuid: UUID(uuidString: stringId)!)!.scnNode
                if newNode.opacity != node.opacity {
                    SCNTransaction.animationDuration = 3
                    SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
                    node.opacity = newNode.opacity
                }
            }
        }
    }
    
    public init(baseObject: Object) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        scene.rootNode.addChildNode(baseObject.scnNode)
        
        self.scene = scene
        self.camera = cameraNode
        self.baseObject = baseObject
        self.baseObject.bindProperties(update)
    }
    
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
