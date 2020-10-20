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
    
    // starting point from touch [and hold] on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodeList.count > 0 {
            dotNodeList.forEach { $0.removeFromParentNode() }
            dotNodeList = [SCNNode]()
        }

        traceTouch(touches)
    }
    
    // add points tracing press moved along screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        traceTouch(touches)
    }
    
    // end point from release of finger on screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard dotNodeList.count == 1 else { return }
        
        traceTouch(touches)
    }
        
    // MARK: - helper methods
    
    func traceTouch(_ touches: Set<UITouch>) {
        
        guard let touchLocation = touches.first?.location(in: sceneView) else { return }
        
        // capture 3D location in real world from tap
        let hitTestResults = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.featurePoint)
        
        // add red dot to 3D location
        guard let hitResult = hitTestResults.first else { return }
        
        addDot(at: hitResult)
    }
    
    // create dot geometry to specify a real-world location using the 2D screen
    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.001)  // approx 1/2 cm
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        // use hittest result to locate tap
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        // add node as child to scene's root node
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodeList.append(dotNode)
        
        if dotNodeList.count > 1 { calculate() }
    }
    
    func calculate() {
        
        let start = dotNodeList.first!, end = dotNodeList.last!
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
                pow(end.position.y - start.position.y, 2) +
                pow(end.position.z - start.position.z, 2)
        )
        
        print("\n - measurements: ", start.position, end.position, distance, "\n")
                
        // convert distance from meters to inches
        let distanceInInches = distance * 100 * 0.393701
        
        updateText(text: "\(distanceInInches)", at: end.position)
    }
    
    func updateText(text: String, at position: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNode.scale = SCNVector3(0.001, 0.001, 0.001)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
