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
            //print(node.name)
            if let name = node.name,
               let object = baseObject.childWithId(id: name) {
                let child = object.object
                //print("here")
                if name.contains("color"),
                   let newColor = child.color,
                   UIColor(newColor) != node.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    
                    SCNTransaction.animationDuration = 3
                    SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor(newColor)
                }
                
                if name.contains("offset"),
                   let newOffset = child.offset,
                   !SCNMatrix4EqualToMatrix4(
                    SCNMatrix4MakeTranslation(newOffset.x, newOffset.y, newOffset.z),
                    node.transform
                   ) {
                    let tempNode = node.clone()
                    let transform = SCNMatrix4MakeTranslation(newOffset.x, newOffset.y, newOffset.z)
                    tempNode.transform = transform
                    print(node.transform)
                    //print(newOffset)
                    
                    if let parentNode = node.parent,
                       let parentName = parentNode.name,
                       parentName.hasPrefix("Stack") {
                        
                        let stackProperties = parentName.components(separatedBy: ",")
    
                        let xyz = XYZ(rawValue: stackProperties[1])!
                        let spacing = Float(stackProperties[2]) ?? 0
                        let index = Int(name.suffix(4))
                        
                        let xTranslation = index == 0 ? 0 : parentNode.boundingBox.max.x
                        let yTranslation = index == 0 ? 0 : parentNode.boundingBox.min.y
                        let zTranslation = index == 0 ? 0 : parentNode.boundingBox.max.z
                        
                        SCNTransaction.animationDuration = 3
                        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
                        switch xyz {
                        case .x:
                            node.transform = SCNMatrix4Translate(tempNode.transform, xTranslation, 0, 0)
                        case .y:
                            node.transform = SCNMatrix4Translate(tempNode.transform, 0, yTranslation, 0)
                        case .z:
                            node.transform = SCNMatrix4Translate(tempNode.transform, 0, 0, zTranslation)
                        }
                    } else {
                        SCNTransaction.animationDuration = 3
                        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
                        node.transform = SCNMatrix4MakeTranslation(newOffset.x, newOffset.y, newOffset.z)
                    }
                }
                
                if name.contains("opacity"),
                   let newOpacity = child.opacity,
                   newOpacity != node.opacity {
                    
                    SCNTransaction.animationDuration = 3
                    SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
                    node.opacity = newOpacity
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
