//
//  Skater.swift
//  SchoolhouseSkateboarder
//
//  Created by James on 9/10/20.
//  Copyright © 2020 syvertsj. All rights reserved.
//

import SpriteKit

class Skater: SKSpriteNode {

    var velocity = CGPoint.zero
    var minimumY: CGFloat = 0.0
    var jumpSpeed: CGFloat = 20.0
    var isOnGround = true
    
    func setupPhysicsBody() {
        
        if let skaterTexture = texture {
            
            physicsBody = SKPhysicsBody(texture: skaterTexture, size: size)
            physicsBody?.isDynamic = true
            physicsBody?.density = 6.0
            physicsBody?.allowsRotation = false  // do not allow skater to tip over (easier to play)
            physicsBody?.angularDamping = 1.0
            
            physicsBody?.categoryBitMask = PhysicsCategory.skater
            physicsBody?.collisionBitMask = PhysicsCategory.brick
            physicsBody?.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.gem
        }
    }
    
    func createSparks() {
        
        // find the particle emitter file for sparks (.sks file) in the project bundle
        
        guard let sparksPath = Bundle.main.path(forResource: "sparks", ofType: "sks") else { return }
        
        // create sparks emitter node
        let sparksNode = NSKeyedUnarchiver.unarchiveObject(withFile: sparksPath) as! SKEmitterNode
        sparksNode.position = CGPoint(x: 0.0, y: -50.0)
        addChild(sparksNode)
        
        // run action for 0.5 seconds and then remove emitter
        let waitAction = SKAction.wait(forDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let waitThenRemove = SKAction.sequence([waitAction, removeAction])
        
        sparksNode.run(waitThenRemove)
    }
}
