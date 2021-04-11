//
//  Scene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI
import SceneKit

struct Scene3D: View {
    var body: some View {
        SceneView(scene: scene, pointOfView: camera, options: [.allowsCameraControl, .autoenablesDefaultLighting])
    }
    
    private var scene: SCNScene {
        let scene = SCNScene()
        scene.rootNode.addChildNode(camera)
        camera.position = SCNVector3(x: 0, y: 0, z: 15)
        camera.rotation = SCNVector4(0, 1, 1, 45)
        
        scene.rootNode.addChildNode(baseObject.scnNode)
        
        if let backgroundColor = backgroundColor {
            scene.background.contents = UIColor(backgroundColor)
        }
        
        if let backgroundImage = backgroundImage {
            scene.background.contents = backgroundImage
        }
        return scene
    }
    
    private var camera: SCNNode
    private var baseObject: Object
    
    private var backgroundColor: Color?
    private var backgroundImage: UIImage?
    
    public init(baseObject: Object) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.camera = cameraNode
        self.baseObject = baseObject
    }
    
    fileprivate init(
        baseObject: Object,
        backgroundColor: Color? = nil,
        backgroundImage: UIImage? = nil
    ) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.camera = cameraNode
        self.baseObject = baseObject
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
    }
}

extension Scene3D {
    func backgroundColor(_ color: Color) -> some View {
        return Scene3D(baseObject: self.baseObject, backgroundColor: color)
    }
}

extension Scene3D {
    func backgroundImage(_ image: UIImage) -> some View {
        return Scene3D(baseObject: self.baseObject, backgroundImage: image)
    }
}
