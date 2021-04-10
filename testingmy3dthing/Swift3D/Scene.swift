//
//  Scene.swift
//  testingmy3dthing
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI
import SceneKit

struct Scene: View {
    var body: some View {
        SceneView(scene: scene, pointOfView: camera, options: [.allowsCameraControl, .autoenablesDefaultLighting])
    }
    
    var scene: SCNScene {
        let scene = SCNScene()
        scene.rootNode.addChildNode(camera)
        camera.position = SCNVector3(x: 0, y: 0, z: 15)
        
        scene.rootNode.addChildNode(baseObject.scnNode)
        return scene
    }
    
    var camera: SCNNode
    var baseObject: Object
    
    public init(baseObject: Object) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        self.camera = cameraNode
        self.baseObject = baseObject
    }
}
