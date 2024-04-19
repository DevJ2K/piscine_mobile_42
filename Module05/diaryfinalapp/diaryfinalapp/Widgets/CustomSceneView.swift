//
//  CustomSceneView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI
import SceneKit

struct CustomSceneView: UIViewRepresentable {
    
    let sceneName: String
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        let scene: SCNScene? = .init(named: "\(sceneName).scn")
        
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}

#Preview {
    LoginView()
}
