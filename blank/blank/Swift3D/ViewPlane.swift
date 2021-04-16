//
//  ViewPlane.swift
//  blank
//
//  Created by Christian Privitelli on 15/4/21.
//

import SceneKit
import SwiftUI

public struct ViewPlane<Content>: Object where Content: View {
    public init(size: CGSize = .init(width: 10, height: 10), doubleSided: Bool = true, vertical: Bool = false, cornerRadius: CGFloat = 0, @ViewBuilder body: () -> Content) {
        self.size = size
        self.doubleSided = doubleSided
        self.vertical = vertical
        self.cornerRadius = cornerRadius
        self.body = body()
    }
    
    public init(size: CGSize = .init(width: 10, height: 10), doubleSided: Bool = true, vertical: Bool = false, cornerRadius: CGFloat = 0, body: Content) {
        self.size = size
        self.doubleSided = doubleSided
        self.vertical = vertical
        self.cornerRadius = cornerRadius
        self.body = body
    }
    
    public var object: Object { self }
    public var attributes = ObjectAttributes()
    
    private let size: CGSize
    private var doubleSided: Bool
    private var vertical: Bool
    private var cornerRadius: CGFloat
    private var body: Content
}

extension ViewPlane {
    public func renderScnNode() -> (SCNNode, [Attributes]) {
        let plane = SCNPlane(width: size.width, height: size.height)
        
        plane.cornerRadius = cornerRadius
        var node = SCNNode(geometry: plane)
        if !vertical {
            node.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        }
        let changedAttributes = applyAttributes(to: &node)
        
        DispatchQueue.main.async {
            let materialView = UIHostingController(rootView: body).view!
            materialView.isOpaque = false
            materialView.backgroundColor = UIColor(color ?? .clear)
            materialView.frame = CGRect(x: 0, y: 0, width: plane.width*50, height: plane.height*50)
            
            let material = SCNMaterial()
            material.diffuse.contents = viewToImage(view: materialView)
            node.geometry?.materials = [material]
            node.geometry?.materials.first?.isDoubleSided = doubleSided
        }
        
        return (node, changedAttributes)
    }
    
    private func viewToImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
}

extension ViewPlane {
    public func doubleSided(_ bool: Bool) -> ViewPlane {
        var me = self
        me.doubleSided = bool
        return me
    }
}

extension ViewPlane {
    public func cornerRadius(_ cornerRadius: CGFloat) -> ViewPlane {
        var me = self
        me.cornerRadius = cornerRadius
        return me
    }
}
