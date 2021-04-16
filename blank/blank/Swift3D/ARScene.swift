//
//  ARScene.swift
//  blank
//
//  Created by Christian Privitelli on 16/4/21.
//

import SwiftUI
import ARKit

public struct ARScene3D: UIViewRepresentable {
    
    private var baseObject: Object
    private var arView: ARSCNView
    private var coachingOverlay: ARCoachingOverlayView
    
    public init(baseObject: Object) {
        // MARK: - Setup AR View
        
        arView = ARSCNView(frame: .init(x: 1, y: 1, width: 1, height: 1))
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        arView.autoenablesDefaultLighting = false
        arView.automaticallyUpdatesLighting = true
        
        arView.session.run(config)
        
        // MARK: - Setup Coaching Overlay
        
        coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [
          .flexibleWidth, .flexibleHeight
        ]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session
        arView.addSubview(coachingOverlay)
        
        // MARK: - Setup Base Object
        
        self.baseObject = baseObject
        self.baseObject.bindProperties(update)
    }
    
    private func update() {
        arView.scene.rootNode.enumerateChildNodes { node, stop in
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
                        
                        let xTranslation = index == 0 ? 0 : totalWidth + ((spacing)*Float(parentNode.childNodes.count-1))
                        let yTranslation = index == 0 ? 0 : totalHeight + ((spacing)*Float(parentNode.childNodes.count-1))
                        let zTranslation = index == 0 ? 0 : totalLength + ((spacing)*Float(parentNode.childNodes.count-1))
                        
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
    
    public func makeUIView(context: Context) -> ARSCNView {
        coachingOverlay.delegate = context.coordinator
        arView.delegate = context.coordinator
        
        return arView
    }
    
    public func updateUIView(_ uiView: ARSCNView, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {
        var parent: ARScene3D
        var arView: ARSCNView {
            return parent.arView
        }
        var raycastFirstResult: ARRaycastResult!
        init(_ arScene: ARScene3D) {
            self.parent = arScene
        }
        
        public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            _ = arView.scene.rootNode.childNodes.map { $0.removeFromParentNode() }
            coachingOverlayView.session?.run(configuration, options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction, .stopTrackedRaycasts])
        }
        
        public func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            _ = arView.scene.rootNode.childNodes.map { $0.removeFromParentNode() }
            coachingOverlayView.session?.run(configuration, options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction, .stopTrackedRaycasts])
        }
        
        public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            let screenCenter = arView.screenCenter
            guard let query = arView.raycastQuery(from: screenCenter, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return }
            let raycastResults = arView.session.raycast(query)
            if raycastResults.isEmpty {
                print("FAIL")
            } else if let result = raycastResults.first {
                let anchor = ARAnchor(name: "BaseObjectAnchor", transform: result.worldTransform)
                raycastFirstResult = result
                parent.arView.session.add(anchor: anchor)
            }
        }
        
        public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if anchor.name == "BaseObjectAnchor" {
                let rotate = simd_float4x4(SCNMatrix4MakeRotation(arView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
                let rotateTransform = simd_mul(raycastFirstResult.worldTransform, rotate)
                node.transform = SCNMatrix4(rotateTransform)
                
                let plane = SCNPlane(width: 2, height: 2)
                plane.heightSegmentCount = 1
                plane.widthSegmentCount = 1
                
                let ambientLight = SCNLight()
                ambientLight.type = .ambient
                ambientLight.color = UIColor.white
                ambientLight.intensity = 1000
                ambientLight.categoryBitMask = -1
                
                let directionalLight = SCNLight()
                directionalLight.type = .directional
                directionalLight.castsShadow = true
                directionalLight.color = UIColor.white
                directionalLight.automaticallyAdjustsShadowProjection = true
                directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.65)
                directionalLight.shadowMode = .deferred
                directionalLight.shadowRadius = 8
                directionalLight.zNear = 0
                directionalLight.zFar = 50
                directionalLight.shadowSampleCount = 24
                directionalLight.shadowMapSize = CGSize(width: 4096, height: 4096)
                directionalLight.categoryBitMask = -1
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.renderingOrder = -10
                planeNode.castsShadow = false
                planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                planeNode.geometry?.firstMaterial?.colorBufferWriteMask = SCNColorMask(rawValue: 0)
                planeNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
                planeNode.geometry?.firstMaterial?.isDoubleSided = true
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
                
                let directionalLightNode = SCNNode()
                directionalLightNode.light = directionalLight
                directionalLightNode.position = SCNVector3(x: 0, y: 10, z: 0)
                directionalLightNode.eulerAngles = SCNVector3(deg2rad(-88), 0, deg2rad(-10))
                
                let ambientLightNode = SCNNode()
                ambientLightNode.light = ambientLight
                ambientLightNode.position = SCNVector3(x: 0, y: 5, z: 0)
                
                let baseObject = parent.baseObject.scnNode
                let baseNodeContainer = SCNNode()
                baseNodeContainer.addChildNode(baseObject)
                baseNodeContainer.scale = SCNVector3(0.1, 0.1, 0.1)
                baseNodeContainer.position.y = (baseObject.boundingBox.max.y*0.1)
                
                node.addChildNode(ambientLightNode)
                node.addChildNode(directionalLightNode)
                node.addChildNode(baseNodeContainer)
                node.addChildNode(planeNode)
            }
        }
    }
}

