//
//  ViewController.swift
//  TapMeasure
//
//  Created by James on 10/9/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
        var dotNodeList = [SCNNode]()
        var textNode = SCNNode()
        
        // MARK: - UIViewController lifecycle method overrides
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the view's delegate
            sceneView.delegate = self
            
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()

            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
        
        // MARK: - UIResponder method overrides
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            guard let touchLocation = touches.first?.location(in: sceneView) else { return }
            
            if dotNodeList.count > 1 { dotNodeList = [SCNNode]() }
            
            // capture 3D location in real world from tap
            let hitTestResults = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.featurePoint)
            
            // add red dot to 3D location
            guard let hitResult = hitTestResults.first else { return }
            
            addDot(at: hitResult)
        }
        
        // create dot geometry to specify a real-world location using the 2D screen
        func addDot(at hitResult: ARHitTestResult) {

            let dotGeometry = SCNSphere(radius: 0.005)  // approx 1/2 cm
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            dotGeometry.materials = [material]
            
            let dotNode = SCNNode(geometry: dotGeometry)
            
            // use hittest result to locate tap
            
            dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
            
            // add node as child to scene's root node
            sceneView.scene.rootNode.addChildNode(dotNode)
            
            dotNodeList.append(dotNode)
            
            if dotNodeList.count == 2 { calculate() }
        }
        
        func calculate() {
            
            let start = dotNodeList[0], end = dotNodeList[1]
            
            let distance = sqrt(
                pow(end.position.x - start.position.x, 2) +
                pow(end.position.y - start.position.y, 2) +
                pow(end.position.z - start.position.z, 2)
            )
            
            print(start.position, end.position, distance)
            
            updateText(text: "\(distance)", at: end.position)
        }
        
        func updateText(text: String, at position: SCNVector3) {
            
            textNode.removeFromParentNode()
            
            let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
            
            textGeometry.firstMaterial?.diffuse.contents = UIColor.red
            
            textNode = SCNNode(geometry: textGeometry)
            
            textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
            
            textNode.scale = SCNVector3(0.01, 0.01, 0.01)
            
            sceneView.scene.rootNode.addChildNode(textNode)
        }
    }
