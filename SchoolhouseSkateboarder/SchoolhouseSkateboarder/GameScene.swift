//
//  GameScene.swift
//  SchoolhouseSkateboarder
//
//  Created by James on 9/10/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {

    static let skater: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let gem: UInt32 = 0x1 << 2
}

enum GameState {
    case notRunning, running
}

class GameScene: SKScene {

    enum BrickLevel: CGFloat {
        case low = 0.0, high = 100.0
    }
    
    var gameState = GameState.notRunning
    
    let skater = Skater(imageNamed: "skaterSophia")
    var bricks = [SKSpriteNode]()
    var gems = [SKSpriteNode]()
    
    var brickSize = CGSize.zero // size of sidewalk brick graphics
    var brickLevel = BrickLevel.low // the y-position of new bricks
    
    var lastUpdateTime: TimeInterval?    // timestamp of the last update method call
    
    var scrollSpeed: CGFloat = 5.0
    let startingScrollSpeed: CGFloat = 5.0
    let gravitySpeed: CGFloat = 1.5
    
    var score: Int = 0
    var highScore: Int = 0
    var lastScoreUpdateTime: TimeInterval = 0.0
    
    func resetSkater() {
            
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0 // (64 is the height of the step)
        
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
        skater.zRotation = 0.0
        skater.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        skater.physicsBody?.angularVelocity = 0.0
    }
    
    func startGame() {
        
        gameState = .running
        
        resetSkater()
        
        score = 0
        scrollSpeed = startingScrollSpeed
        lastUpdateTime = nil
        brickLevel = .low
        
        bricks.forEach { $0.removeFromParent() }
        
        bricks.removeAll(keepingCapacity: true)
        
        gems.forEach { removeGem($0) }
    }
    
    func gameOver() {
        
        scrollSpeed = 0.0
        
        gameState = .notRunning
        
        if score > UserDefaults.standard.integer(forKey: "highScore") {
            highScore = score
            updateHighScoreLabelText()
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
        
        // show "Game Over!" menu overlay
        let menuBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        let menuLayer = MenuLayer(color: menuBackgroundColor, size: frame.size)
        menuLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menuLayer.position = CGPoint(x: 0.0, y: 0.0)
        menuLayer.zPosition = 30
        menuLayer.name = "menuLayer"
        menuLayer.display(message: "Game Over! Tap to play", score: nil)
        addChild(menuLayer)
    }
    
    func spawnBrick(atPosition position: CGPoint) -> SKSpriteNode {
        
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        
        brickSize = brick.size
        bricks.append(brick)
        
        // set up brick's physics body
        let center = brick.centerRect.origin
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size, center: center)
        brick.physicsBody?.affectedByGravity = false
        brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
        brick.physicsBody?.collisionBitMask = 0
        
        return brick
    }
    
    func spawnGem(atPosition position: CGPoint) {
            
        // create a gem sprite and add it to the scene
        let gem = SKSpriteNode(imageNamed: "gem")
        gem.position = position
        gem.zPosition = 9
        addChild(gem)
        
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size, center: gem.centerRect.origin)
        gem.physicsBody?.categoryBitMask = PhysicsCategory.gem
        gem.physicsBody?.affectedByGravity = false
        
        // add new gem to the array of gems
        gems.append(gem)
    }
    
    func setupLabels() {
            
        // label to show the player's score
        
        let scoreTextLabel: SKLabelNode = SKLabelNode(text: "score")
        scoreTextLabel.position = CGPoint(x: 14.0, y: frame.size.height - 20)
        scoreTextLabel.horizontalAlignmentMode = .left
        scoreTextLabel.fontName = "Courier-Bold"
        scoreTextLabel.fontSize = 14.0
        scoreTextLabel.zPosition = 20
        addChild(scoreTextLabel)
        
        let scoreLabel: SKLabelNode = SKLabelNode(text: "0")
        scoreLabel.name = "scoreLabel"
        scoreLabel.position = CGPoint(x: 14.0, y: frame.size.height - 40)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Courier-Bold"
        scoreLabel.fontSize = 18.0
        scoreLabel.zPosition = 20
        addChild(scoreLabel)

        // label displaying high score

        let highScoreTextLabel: SKLabelNode = SKLabelNode(text: "high score")
        highScoreTextLabel.position = CGPoint(x: frame.size.width - 30.0, y: frame.size.height - 20)
        highScoreTextLabel.horizontalAlignmentMode = .right
        highScoreTextLabel.fontName = "Courier-Bold"
        highScoreTextLabel.fontSize = 14.0
        highScoreTextLabel.zPosition = 20
        addChild(highScoreTextLabel)
        
        // label showing the player's highest score
        
        let highScoreText = (UserDefaults.standard.value(forKey: "highScore") != nil) ? "\(UserDefaults.standard.integer(forKey: "highScore"))" : "0"
        let highScoreLabel: SKLabelNode = SKLabelNode(text: highScoreText)
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.position = CGPoint(x: frame.size.width - 30.0, y: frame.size.height - 40)
        highScoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.fontName = "Courier-Bold"
        highScoreLabel.fontSize = 18.0
        highScoreLabel.zPosition = 20
        addChild(highScoreLabel)
    }
    
    func updateScoreLabelText() {
        
        if let scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode {
            scoreLabel.text = String(format: "%04d", score)
        }
    }
    
    func updateHighScoreLabelText() {
    
        if let highScoreLabel = childNode(withName: "highScoreLabel") as? SKLabelNode {
            highScoreLabel.text = String(format: "%04d", highScore)
        }
    }
    
    func removeGem(_ gem: SKSpriteNode) {
        
        gem.removeFromParent()
        
        if let gemIndex = gems.firstIndex(of: gem) {
            gems.remove(at: gemIndex)
        }
    }
    
    func updateGems(withScrollAmount currentScrollAmount: CGFloat) {
        
        for gem in gems {
            
            // update each gem's position
            let thisGemX = gem.position.x - currentScrollAmount
            gem.position = CGPoint(x: thisGemX, y: gem.position.y)
            
            // remove any gems that have moved offscrean
            if gem.position.x < 0.0 {
                removeGem(gem)
            }
        }
    }
    
    func updateSkater() {
        
        if !skater.isOnGround {
            
            // set skater's vertical velocity after she jumps
            let velocityY = skater.velocity.y - gravitySpeed
            skater.velocity = CGPoint(x: skater.velocity.x, y: velocityY)
            
            // set skater's new vertical, y-position based upon her velocity
            let newSkaterY: CGFloat = skater.position.y + skater.velocity.y
            skater.position = CGPoint(x: skater.position.x, y: newSkaterY)
        
            // check if skater has landed
            if skater.position.y < skater.minimumY {
                skater.position.y = skater.minimumY
                skater.velocity = CGPoint.zero
                skater.isOnGround = true
            }
        }
        
        // determine if the skater is on the ground
        if let velocityY = skater.physicsBody?.velocity.dy, velocityY < -100.0 || velocityY > 100.0 {
            skater.isOnGround = false
        }
        
        // check if game should end
        let isOffScreen = skater.position.y < 0.0 || skater.position.x < 0.0
        
        let maxRotation = CGFloat(GLKMathDegreesToRadians(85.0))
        let isTippedOver = skater.zRotation > maxRotation || skater.zRotation < -maxRotation
        
        if isOffScreen || isTippedOver { gameOver() }
    }
    
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
        
        var farthestRightBrickX: CGFloat = 0.0
        
        for brick in bricks {
            
            let newX = brick.position.x - currentScrollAmount
            
            // if a brick has moved too far left, off the screen, remove it
            if newX < -brickSize.width {
                
                brick.removeFromParent()
                
                if let brickIndex = bricks.firstIndex(of: brick) { bricks.remove(at: brickIndex) }
                
            } else {
                
                // for a brick that is still onscreen, update its position
                brick.position = CGPoint(x: newX, y: brick.position.y)
                
                // update our farthest.right position tracker
                if brick.position.x > farthestRightBrickX { farthestRightBrickX = brick.position.x }
            }
        }
        
        while farthestRightBrickX < frame.width {
            
            var brickX = farthestRightBrickX + brickSize.width + 1.0
            let brickY = brickSize.height / 2.0 + brickLevel.rawValue
            
            // create gaps to jump
            
            let randomNumber = arc4random_uniform(99)
            
            if randomNumber < 2 && score > 10 {
            
                // 2 % chance of increased gap between bricks once the player has a score > 10
                let gap = 20.0 * scrollSpeed
                brickX += gap
                
            } else if randomNumber < 4 && score > 20 {
                
                // 4 % chance that brick Y level will change after player has a score > 20
                brickLevel = (brickLevel == .high) ? .low : .high
                
            } else if randomNumber < 5 {
                
                // give 5 percent chance that we will leave a gap between the bricks
                let gap = 20.0 * scrollSpeed
                brickX += gap
                
                // add a new gem at each gap
                let randomGemYAmount = CGFloat(arc4random_uniform(150))
                let newGemY = brickY + skater.size.height + randomGemYAmount
                let newGemX = brickX + gap / 2.0
                
                spawnGem(atPosition: CGPoint(x: newGemX, y: newGemY))
                
            } else if randomNumber < 10 {
                
                // 10 % chance of the brick level changing
                brickLevel = (brickLevel == .high) ? .low : .high
            }
            
            let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
            
            farthestRightBrickX = newBrick.position.x
        }
    }
    
    func updateScore(withCurrentTime currentTime: TimeInterval) {
    
        // player's score increases as they stay alive
        
        let elapsedTime = currentTime - lastScoreUpdateTime
        
        if elapsedTime > 1.0 {
            
            score += Int(scrollSpeed)  // increase score
            
            lastScoreUpdateTime = currentTime  // reset the last score update time to the current time
            
            updateScoreLabelText()
        }
    }
    
    // tap gesture to support skater jumping
    @objc func handleTap(tapGesture: UITapGestureRecognizer) {
        
        if gameState == .running {

            if skater.isOnGround {
                
                skater.velocity = CGPoint(x: 0.0, y: skater.jumpSpeed)  // set skater's y-velocity to the skater's initial jump speed
                skater.isOnGround = false
                //skater.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 260.0))
                
                run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
            }
        
        } else {  // tap to start new game if it is not running
        
            if let menuLayer: SKSpriteNode = childNode(withName: "menuLayer") as? SKSpriteNode {
                
                menuLayer.removeFromParent()
            }
            
            startGame()
        }
    }
        
    // starting point
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        
        // set up labels
        setupLabels()
        
        // set up skater and add her to the scene
        skater.setupPhysicsBody()
        //resetSkater()
        addChild(skater)
        
        // add support for tap gesture to make skater jump
        let tapMethod = #selector(GameScene.handleTap(tapGesture:))
        let tapGesture = UITapGestureRecognizer(target: self,action: tapMethod)
        view.addGestureRecognizer(tapGesture)
        
        //startGame()
        
        // add menu overlay with "Tap to play" text
        let menuBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        let menuLayer = MenuLayer(color: menuBackgroundColor, size: frame.size)
        menuLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menuLayer.position = CGPoint(x: 0.0, y: 0.0)
        menuLayer.zPosition = 30
        menuLayer.name = "menuLayer"
        menuLayer.display(message: "Tap to play", score: nil)
        addChild(menuLayer)
    }
    
    // the game loop: called by system once per frame (approximately 60 frames per second)
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard gameState == .running else { return }
        
        //scrollSpeed += 0.01 // gradually increase speed
        
        var elapsedTime: TimeInterval = 0.0  // time since last update call
        
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        
        lastUpdateTime = currentTime
        
        let expectedElapsedTime: TimeInterval = 1.0 / 60.0  // expected call to update() every 1/60 of a second
        
        // calculate how far everything should move in this update
        let scrollAdjustment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjustment
        
        updateBricks(withScrollAmount: currentScrollAmount)
        
        updateSkater()
        updateGems(withScrollAmount: currentScrollAmount)
        updateScore(withCurrentTime: currentTime)
    }
}

// MARK: - SKPhysicsContactDelegate - to respond to sprite nodes coming into contact

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // check if the contact is between the skater and a brick
        if contact.bodyA.categoryBitMask == PhysicsCategory.skater && contact.bodyB.categoryBitMask == PhysicsCategory.brick {
            
            if let velocityY = skater.physicsBody?.velocity.dy, velocityY < 100.0 && !skater.isOnGround  {
                
                skater.createSparks()
            }
            
            skater.isOnGround = true
            
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.skater && contact.bodyB.categoryBitMask == PhysicsCategory.gem {
            
            // remove gem if skater comes into contact with it
            if let gem = contact.bodyB.node as? SKSpriteNode {
                removeGem(gem)
            }
            
            // give player 50 points for getting a gem
            score += 50
            updateScoreLabelText()
            
            run(SKAction.playSoundFileNamed("gem.wav", waitForCompletion: false))
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
                
    }
}
