//
//  ARScene.swift
//  blank
//
//  Created by Christian Privitelli on 16/4/21.
//

import SwiftUI
import ARKit

public struct ARScene3D: UIViewRepresentable, Scene3DProtocol {
    public init(baseObject: Object, realisticLighting: Bool = true) {
        self.realisticLighting = realisticLighting
        self.baseObject = baseObject
        
        // Setup AR view.
        arView = ARSCNView(frame: .init(x: 1, y: 1, width: 1, height: 1))
        coachingOverlay = ARCoachingOverlayView()
        
        configureARView()
        configureCoachingOverlay()
        self.baseObject.bindProperties(update)
    }
    
    public func makeUIView(context: Context) -> ARSCNView {
        coachingOverlay.delegate = context.coordinator
        arView.delegate = context.coordinator
        return arView
    }
    
    internal var scene: SCNScene { arView.scene }
    internal var realisticLighting: Bool
    internal var baseObject: Object
    private var arView: ARSCNView
    private var coachingOverlay: ARCoachingOverlayView
    
    func configureARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        arView.autoenablesDefaultLighting = !realisticLighting
        arView.automaticallyUpdatesLighting = !realisticLighting
        arView.session.run(config)
    }
    
    func configureCoachingOverlay() {
        coachingOverlay.autoresizingMask = [
          .flexibleWidth, .flexibleHeight
        ]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session
        arView.addSubview(coachingOverlay)
    }
}

// MARK: - Coordinator

extension ARScene3D {
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {
        init(_ arScene: ARScene3D) {
            self.parent = arScene
        }
        
        var parent: ARScene3D
        var scene: SCNScene { parent.arView.scene }
        var arView: ARSCNView { parent.arView }
        
        var raycastFirstResult: ARRaycastResult!
        
        // MARK: - ARCoachingOverlayViewDelegate Methods
        public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            resetAR()
        }
        
        public func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
            resetAR()
        }
        
        func resetAR() {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            _ = scene.rootNode.childNodes.map { $0.removeFromParentNode() }
            arView.session.run(
                configuration,
                options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction, .stopTrackedRaycasts]
            )
        }
        
        public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            guard let query = arView.raycastQuery(
                from: arView.screenCenter,
                allowing: .existingPlaneInfinite,
                alignment: .horizontal
            ) else { return }
            
            let raycastResults = arView.session.raycast(query)
            if raycastResults.isEmpty {
                print("FAIL THIS WONT HAPPEN THO")
            } else if let result = raycastResults.first {
                let anchor = ARAnchor(name: "BaseObjectAnchor", transform: result.worldTransform)
                raycastFirstResult = result
                arView.session.add(anchor: anchor)
            }
        }
        
        public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if anchor.name == "BaseObjectAnchor" {
                // Make the node face the user.
                let rotate = simd_float4x4(
                    SCNMatrix4MakeRotation(arView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0)
                )
                let rotateTransform = simd_mul(raycastFirstResult.worldTransform, rotate)
                node.transform = SCNMatrix4(rotateTransform)
                
                // Create the plane that will display shadows from lights
                let plane = SCNPlane(width: 2, height: 2)
                plane.heightSegmentCount = 1
                plane.widthSegmentCount = 1
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.renderingOrder = -10
                planeNode.castsShadow = false
                planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                planeNode.geometry?.firstMaterial?.colorBufferWriteMask = SCNColorMask(rawValue: 0)
                planeNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
                planeNode.geometry?.firstMaterial?.isDoubleSided = true
                planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
                
                let baseObject = parent.baseObject.scnNode
                let baseNodeContainer = SCNNode()
                baseNodeContainer.addChildNode(baseObject)
                baseNodeContainer.scale = SCNVector3(0.1, 0.1, 0.1)
                baseNodeContainer.position.y = (baseObject.boundingBox.max.y*0.1)
                
                let ambientLightNode = parent.ambientLight
                ambientLightNode.light?.intensity = 1000
                let directionalLightNode = parent.directionalLight
                
                arView.prepare(
                    [baseNodeContainer, planeNode, ambientLightNode, directionalLightNode]
                ) { _ in
                    if self.parent.realisticLighting {
                        node.addChildNode(ambientLightNode)
                        node.addChildNode(directionalLightNode)
                    }
                    node.addChildNode(baseNodeContainer)
                    node.addChildNode(planeNode)
                }
            }
        }
    }
}

// Required but unused method.
extension ARScene3D {
    public func updateUIView(_ uiView: ARSCNView, context: Context) { }
}
