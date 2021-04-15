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
            if let name = node.name,
               let object = baseObject.childWithId(id: name) {
                let child = object.object
                
                let animationDuration = child.animation?.duration ?? 0
                let animationCurve = child.animation?.option ?? .linear
                let animationRepeatsForever = child.animation?.repeatForever ?? false
                
                var animationGroup: [SCNAction] = []
                
                if name.contains("color"),
                   let newColor = child.color,
                   UIColor(newColor) != node.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    let oldColor = node.geometry?.firstMaterial?.diffuse.contents as? UIColor ?? .white
                    let colorAction = SCNAction.customAction(duration: animationDuration) { actionNode, time in
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = animationDuration
                        SCNTransaction.animationTimingFunction = animationCurve.caMediaTimingFunction()
                        node.geometry?.firstMaterial?.diffuse.contents = UIColor(newColor)
                        SCNTransaction.commit()
                    }
                    colorAction.timingMode = animationCurve
                    if animationRepeatsForever {
                        let colorAction2 = SCNAction.customAction(duration: animationDuration) { actionNode, time in
                            SCNTransaction.begin()
                            SCNTransaction.animationDuration = animationDuration
                            SCNTransaction.animationTimingFunction = animationCurve.caMediaTimingFunction()
                            node.geometry?.firstMaterial?.diffuse.contents = oldColor
                            SCNTransaction.commit()
                        }
                        colorAction2.timingMode = animationCurve
                        animationGroup.append(SCNAction.sequence([colorAction, colorAction2]))
                    } else {
                        animationGroup.append(colorAction)
                    }
                }
                
                if name.contains("offset"),
                   let newOffset = child.offset {
                    if let parentNode = node.parent,
                       let parentName = parentNode.name,
                       parentName.hasPrefix("Stack") {
                        print("here")
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
                        
                        var newVector = SCNVector3()
                        switch xyz {
                        case .x:
                            newVector = SCNVector3(
                                x: xTranslation + newOffset.x - node.position.x,
                                y: newOffset.y - node.position.y,
                                z: newOffset.z - node.position.z
                            )
                        case .y:
                            newVector = SCNVector3(
                                x: newOffset.x - node.position.x,
                                y: yTranslation + newOffset.y - node.position.y,
                                z: newOffset.z - node.position.z
                            )
                        case .z:
                            newVector = SCNVector3(
                                x: newOffset.x - node.position.x,
                                y: newOffset.y - node.position.y,
                                z: zTranslation + newOffset.z - node.position.z
                            )
                        }
                        let offsetAction = SCNAction.move(by: newVector, duration: animationDuration)
                        offsetAction.timingMode = animationCurve
                        if animationRepeatsForever {
                            animationGroup.append(SCNAction.sequence([offsetAction, offsetAction.reversed()]))
                        } else {
                            animationGroup.append(offsetAction)
                        }
                    } else {
                        let newVector = SCNVector3(
                            x: newOffset.x - node.position.x,
                            y: newOffset.y - node.position.y,
                            z: newOffset.z - node.position.z
                        )
                        let offsetAction = SCNAction.move(by: newVector, duration: animationDuration)
                        offsetAction.timingMode = animationCurve
                        if animationRepeatsForever {
                            animationGroup.append(SCNAction.sequence([offsetAction, offsetAction.reversed()]))
                        } else {
                            animationGroup.append(offsetAction)
                        }
                    }
                }
                
                // Yes my code is messy but if anyone at apple who works with scenekit is reading this, SCNActions modifying opacity are broken... no time to fix only 3 days left and still need to do the playground pages and walkthroughs.
                if name.contains("opacity"),
                   let newOpacity = child.opacity,
                   newOpacity != node.opacity {
                    let opacityChange = newOpacity - node.opacity
                    let opacityAction = SCNAction.fadeOpacity(by: opacityChange, duration: animationDuration)
                    opacityAction.timingMode = animationCurve
                    if animationRepeatsForever {
                        print(opacityChange)
                        let opacityAction2 = SCNAction.fadeOpacity(by: -opacityChange, duration: animationDuration)
                        opacityAction2.timingMode = animationCurve
                        animationGroup.append(SCNAction.sequence([opacityAction, opacityAction2]))
                    } else {
                        animationGroup.append(opacityAction)
                    }
                }
                
                
                let groupAction = SCNAction.group(animationGroup)
                
                if animationRepeatsForever {
                    let repeatAction = SCNAction.repeatForever(groupAction)
                    node.runAction(repeatAction)
                } else {
                    node.runAction(groupAction)
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

extension SCNActionTimingMode {
    func caMediaTimingFunction() -> CAMediaTimingFunction {
        switch self {
        case .easeIn:
            return CAMediaTimingFunction(name: .easeIn)
        case .easeInEaseOut:
            return CAMediaTimingFunction(name: .easeInEaseOut)
        case .easeOut:
            return CAMediaTimingFunction(name: .easeOut)
        case .linear:
            return CAMediaTimingFunction(name: .linear)
        default:
            return CAMediaTimingFunction(name: .linear)
        }
    }
}
