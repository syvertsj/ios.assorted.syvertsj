//
//  MenuLayer.swift
//  SchoolhouseSkateboarder
//
//  Created by James on 9/12/20.
//  Copyright © 2020 syvertsj. All rights reserved.
//

import SpriteKit

class MenuLayer: SKSpriteNode {

    // display message
    func display(message: String, score: Int?) {

        // create message label using the passed-in message
        let messageLabel: SKLabelNode = SKLabelNode(text: message)
        
        // set label starting position
        let messageX = -frame.width
        let messageY = frame.height / 2.0
        messageLabel.position = CGPoint(x: messageX, y: messageY)
        
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.fontName = "Courier-Bold"
        messageLabel.fontSize = 48.0
        messageLabel.zPosition = 20
        self.addChild(messageLabel)
        
        // animate the message label to the center of the screen (label runs an skaction)
        let finalX = frame.width / 2.0
        let messageAction = SKAction.moveTo(x: finalX, duration: 0.3)
        messageLabel.run(messageAction)
        
        // display score if it was passed
        guard let scoreToDisplay = score else { return }
        
        let scoreString = String(format: "Score: %04d", scoreToDisplay)
        let scoreLabel = SKLabelNode(text: scoreString)
        
        // set the label's starting position to the right of the menu layer
        let scoreLabelX = frame.width
        let scoreLabelY = messageLabel.position.y - messageLabel.frame.height
        
        scoreLabel.position = CGPoint(x: scoreLabelX, y: scoreLabelY)
        
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontName = "Courier-Bold"
        scoreLabel.fontSize = 32.0
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
        
        // animate the score label to the center of the screen
        let scoreAction = SKAction.moveTo(x: finalX, duration: 0.3)
        scoreLabel.run(scoreAction)
    }
}
