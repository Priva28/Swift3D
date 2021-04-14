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
            print(node)
            if let name = node.name,
               let object = baseObject.childWithId(id: name) {
                let child = object.object
                
                let animation = child.animation
                let saveColor = node.geometry?.firstMaterial?.diffuse.contents as? UIColor
                let saveOffset = node.transform
                let saveOpacity = node.opacity
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = animation?.duration ?? 0
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: animation?.option ?? .linear)
                if let repeats = animation?.repeatForever,
                   repeats == true {
                    SCNTransaction.completionBlock = {
                        SCNTransaction.flush()
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = animation?.duration ?? 0
                        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: animation?.option ?? .linear)
                        SCNTransaction.completionBlock = {
                            print("now")
                            update()
                        }
                        node.geometry?.firstMaterial?.diffuse.contents = saveColor
                        node.opacity = saveOpacity
                        node.transform = saveOffset
                        SCNTransaction.commit()
                        
                    }
                }
                
                if name.contains("color"),
                   let newColor = child.color,
                   UIColor(newColor) != node.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor(newColor)
                }
                
                if name.contains("offset"),
                   let newOffset = child.offset {
                    if let parentNode = node.parent,
                       let parentName = parentNode.name,
                       parentName.hasPrefix("Stack") {
                        
                        let stackProperties = parentName.components(separatedBy: ",")
    
                        let xyz = XYZ(rawValue: stackProperties[1])!
                        let spacing = Float(stackProperties[2]) ?? 0
                        let index = Int(name.suffix(4))
                        
                        var totalWidth: Float = 0
                        for stackChild in parentNode.childNodes {
                            totalWidth += stackChild.geometry?.boundingBox.max.x ?? stackChild.boundingBox.max.x/2
                        }
                        
                        var totalHeight: Float = 0
                        for stackChild in parentNode.childNodes {
                            totalHeight += stackChild.geometry?.boundingBox.max.y ?? stackChild.boundingBox.max.y/2
                        }
                        
                        var totalLength: Float = 0
                        for stackChild in parentNode.childNodes {
                            totalLength += stackChild.geometry?.boundingBox.max.z ?? stackChild.boundingBox.max.z/2
                        }
                        
                        let xTranslation = index == 0 ? 0 : totalWidth + (spacing*Float(parentNode.childNodes.count-1))
                        let yTranslation = index == 0 ? 0 : totalHeight + (spacing*Float(parentNode.childNodes.count-1))
                        let zTranslation = index == 0 ? 0 : totalLength + (spacing*Float(parentNode.childNodes.count-1))
                        
                        switch xyz {
                        case .x:
                            node.position.x = xTranslation + newOffset.x
                            node.position.y = newOffset.y
                            node.position.z = newOffset.z
                        case .y:
                            node.position.x = newOffset.x
                            node.position.y = yTranslation + newOffset.y
                            node.position.z = newOffset.z
                        case .z:
                            node.position.x = newOffset.x
                            node.position.y = newOffset.y
                            node.position.z = zTranslation + newOffset.z
                        }
                    } else {
                        node.transform = SCNMatrix4MakeTranslation(newOffset.x, newOffset.y, newOffset.z)
                    }
                }
                
                if name.contains("opacity"),
                   let newOpacity = child.opacity,
                   newOpacity != node.opacity {
                    node.opacity = newOpacity
                }
                
                SCNTransaction.commit()
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
