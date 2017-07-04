//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Sambandam, Sujatha {BIS} on 7/3/17.
//  Copyright © 2017 Jothi R. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var score = SKLabelNode()
    
    var scoreNumber = 0
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    var gameOver = false
    
            func makePipes(){
                
                let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
                
                let gapHeight = bird.size.height * 4
                
                let movementAmt = arc4random() % UInt32(self.frame.height / 2)
                
                let pipeOffset = CGFloat(movementAmt) - self.frame.height / 4
                
                let pipeTexture = SKTexture(imageNamed: "pipe1.png")
                
                let pipe1 = SKSpriteNode(texture: pipeTexture)
                
                pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
                
                pipe1.run(movePipes)
                
                pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
                pipe1.physicsBody!.isDynamic = false
                
                pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
                pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
                pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
                
                self.addChild(pipe1)
                
                let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
                
                let pipe2 = SKSpriteNode(texture: pipe2Texture)
                
                pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeOffset)
                
                pipe2.run(movePipes)
                
                pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
                pipe2.physicsBody!.isDynamic = false
                
                pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
                pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
                pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
                
                self.addChild(pipe2)
                
                let gap = SKNode()
                
                gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
                
                gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
                
                gap.physicsBody!.isDynamic = false
                
                gap.run(movePipes)
                
                gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
                gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
                gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
                
                self.addChild(gap)
            
        }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue{
            
            scoreNumber += 1
            
            score.text = String(describing: score)
        } else {
        
        print(scoreNumber)
        
        self.speed = 0
        
        gameOver = true
            
        }
    
    }

    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)

        
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -backgroundTexture.size().width, dy: 0), duration: 7)
        
        let shiftBG = SKAction.move(by: CGVector(dx: backgroundTexture.size().width, dy: 0), duration: 0)
        
        let bgMove = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBG]))
        
        var i = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: backgroundTexture)
            
            bg.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)), y: self.frame.midY)
            
            bg.size.height = self.frame.height
            
            bg.run(bgMove)
            
            self.addChild(bg)
            
            i += 1
            
        }
        
        bg = SKSpriteNode(texture: backgroundTexture)
        
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bg.size.height = self.frame.height
        
        bg.zPosition = -1
        
        bg.run(bgMove)
        
        self.addChild(bg)
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let secondBirdTexture = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture,secondBirdTexture], timePerFrame: 0.5)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(bird)
        
        var ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        score.fontName = "Helvetica"
        
        score.fontSize = 60
        
        score.text = "0"
        
        score.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(score)
       
    }
    
   
    
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        
            bird.physicsBody!.isDynamic = true
        
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 80))
            
        }
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
