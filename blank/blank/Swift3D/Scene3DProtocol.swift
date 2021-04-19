//
//  Scene3DProtocol.swift
//  blank
//
//  Created by Christian Privitelli on 17/4/21.
//

import SceneKit

internal protocol Scene3DProtocol {
    var scene: SCNScene { get }
    var baseObject: Object { get set }
    
    var realisticLighting: Bool { get }
    var ambientLight: SCNNode { get }
    var directionalLight: SCNNode { get }
    func update()
}

// MARK: - Configure Scene Lighting

extension Scene3DProtocol {
    // Ambient light lights areas not lit by directional light.
    var ambientLight: SCNNode {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.white
        ambientLight.intensity = 2000
        ambientLight.categoryBitMask = -1
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        ambientLightNode.position = SCNVector3(x: 0, y: 5, z: 0)
        return ambientLightNode
    }
    
    // Directional light creates shadows
    var directionalLight: SCNNode {
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.castsShadow = true
        directionalLight.color = UIColor.white
        directionalLight.automaticallyAdjustsShadowProjection = true
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.5)
        directionalLight.shadowMode = .deferred
        directionalLight.shadowRadius = 8
        directionalLight.zNear = 0
        directionalLight.zFar = 50
        directionalLight.shadowSampleCount = 32
        directionalLight.shadowMapSize = CGSize(width: 4096, height: 4096)
        directionalLight.categoryBitMask = -1
        
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.position = SCNVector3(x: 0, y: 15, z: 0)
        directionalLightNode.eulerAngles = SCNVector3(deg2rad(-88), 0, deg2rad(-2))
        
        return directionalLightNode
    }
}

// MARK: - Configure update method.

extension Scene3DProtocol {
    func update() {
        scene.rootNode.enumerateChildNodes { node, stop in
            // Ensure node has a name.
            // If so search for a child object from base object with matching id.
            if let name = node.name,
               let object = baseObject.childWithId(id: name)
            {
                let child = object.object
                
                let animationDuration = child.animation?.duration ?? 0
                let animationCurve = child.animation?.option ?? .linear
                let animationRepeatsForever = child.animation?.repeatForever ?? false
                
                var animationGroup: [SCNAction] = []
                
                // MARK: - Update color
                if name.contains("color"),
                   let newColor = child.color,
                   UIColor(newColor) != node.geometry?.firstMaterial?.diffuse.contents as? UIColor
                {
                    let oldColor = node.geometry?.firstMaterial?.diffuse.contents as? UIColor ?? .white
                    
                    func newColorAction(toColor: UIColor) -> SCNAction {
                        SCNAction.customAction(duration: animationDuration) { actionNode, time in
                            SCNTransaction.begin()
                            SCNTransaction.animationDuration = animationDuration
                            SCNTransaction.animationTimingFunction = animationCurve.caMediaTimingFunction()
                            node.geometry?.firstMaterial?.diffuse.contents = toColor
                            SCNTransaction.commit()
                        }
                    }
                    
                    let colorAction = newColorAction(toColor: UIColor(newColor))
                    colorAction.timingMode = animationCurve
                    
                    if animationRepeatsForever {
                        let colorAction2 = newColorAction(toColor: oldColor)
                        colorAction2.timingMode = animationCurve
                        animationGroup.append(SCNAction.sequence([colorAction, colorAction2]))
                    } else {
                        animationGroup.append(colorAction)
                    }
                }
                
                // MARK: - Update offset
                if name.contains("offset"),
                   let newOffset = child.offset
                {
                    var newVector = SCNVector3()
                    
                    // Check if object is in a stack.
                    if let parentNode = node.parent,
                       let parentName = parentNode.name,
                       parentName.hasPrefix("Stack")
                    {
                        let stackProperties = parentName.components(separatedBy: ",")
    
                        let xyz = XYZ(rawValue: stackProperties[1])!
                        let spacing = Float(stackProperties[2]) ?? 0
                        let index = Int(name.suffix(4))!
                        
                        var totalWidth: Float = 0
                        for childIndex in 0...index {
                            if childIndex != 0 {
                                totalWidth += parentNode.childNodes[childIndex-1].boundingBox.max.x
                                totalWidth += parentNode.childNodes[childIndex].boundingBox.max.x
                            }
                        }
                        
                        var totalHeight: Float = 0
                        for childIndex in 0...index {
                            if childIndex != 0 {
                                totalHeight += parentNode.childNodes[childIndex-1].boundingBox.max.y
                                totalHeight += parentNode.childNodes[childIndex].boundingBox.max.y
                            }
                        }
                        
                        var totalLength: Float = 0
                        for childIndex in 0...index {
                            if childIndex != 0 {
                                totalLength += parentNode.childNodes[childIndex-1].boundingBox.max.z
                                totalLength += parentNode.childNodes[childIndex].boundingBox.max.z
                            }
                        }
                        
                        print("calc: \(totalWidth)")
                        print(node.position.x)
                        let xTranslation = totalWidth + ((spacing)*Float(parentNode.childNodes.count-1))
                        let yTranslation = totalHeight + ((spacing)*Float(parentNode.childNodes.count-1))
                        let zTranslation = totalLength + ((spacing)*Float(parentNode.childNodes.count-1))
                        
                        switch xyz {
                        case .x:
                            newVector = SCNVector3(
                                x: xTranslation - node.position.x,
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
                    } else if
                        newOffset.x != node.position.x ||
                        newOffset.y != node.position.y ||
                        newOffset.z != node.position.z
                    {
                        newVector = SCNVector3(
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
                
                // MARK: - Update rotation
                if name.contains("rotation"),
                   let newRotation = child.rotation,
                   deg2rad(newRotation.x) != node.eulerAngles.x ||
                   deg2rad(newRotation.y) != node.eulerAngles.y ||
                   deg2rad(newRotation.z) != node.eulerAngles.z
                {
                    let rotationAction = SCNAction.rotateBy(
                        x: CGFloat(deg2rad(newRotation.x) - node.eulerAngles.x),
                        y: CGFloat(deg2rad(newRotation.y) - node.eulerAngles.y),
                        z: CGFloat(deg2rad(newRotation.z) - node.eulerAngles.z),
                        duration: animationDuration
                    )
                    rotationAction.timingMode = animationCurve
                    
                    if animationRepeatsForever {
                        animationGroup.append(SCNAction.sequence([rotationAction, rotationAction.reversed()]))
                    } else {
                        animationGroup.append(rotationAction)
                    }
                }
                
                // MARK: - Update opacity
                // Yes my code is messy but if anyone at apple who works with scenekit is reading this, SCNActions modifying opacity are broken... no time to fix only 3 days left and still need to do the playground pages and walkthroughs.
                if name.contains("opacity"),
                   let newOpacity = child.opacity,
                   newOpacity != node.opacity
                {
                    let opacityChange = newOpacity - node.opacity
                    let opacityAction = SCNAction.fadeOpacity(by: opacityChange, duration: animationDuration)
                    opacityAction.timingMode = animationCurve
                    
                    if animationRepeatsForever {
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
}
