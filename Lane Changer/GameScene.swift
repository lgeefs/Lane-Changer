//
//  GameScene.swift
//  Lane Changer
//
//  Created by Logan Geefs on 2014-12-25.
//  Copyright (c) 2014 Logan Geefs. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import Social
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //global variables, such as Sprites and Labels
    
    var scoreAdded : Bool = false
    
    var obstacleInterval : NSTimeInterval = 1.0
    
    //Sprites
    
    let car = SKSpriteNode(imageNamed: "images/yellowcar.png")
    let leftObstacle = SKSpriteNode()
    let rightObstacle = SKSpriteNode()
    
    //labels
    
    let scoreLabel = SKLabelNode(fontNamed: "Optima-BoldItalic")
    let highscoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    let help = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    
    //variables
    
    var scoreNumber = Int()
    var highscoreNumber = Int()
    
    struct PhysicsCategory {
        static let None             : UInt32 = 0
        static let All              : UInt32 = UInt32.max
        static let Car              : UInt32 = 0b1      //1
        static let LeftObstacle     : UInt32 = 0b10     //2
        static let RightObstacle    : UInt32 = 0b100    //4
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    override func didMoveToView(view: SKView) {
        
        //physics body
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //sprites
        
        car.size = CGSize(width: size.width/8, height: size.height/8)
        car.physicsBody = SKPhysicsBody(rectangleOfSize: car.size)
        car.position = CGPoint(x: size.width/2, y: size.height/4)
        car.physicsBody?.friction = 0.0
        car.physicsBody?.allowsRotation = false
        car.physicsBody?.categoryBitMask = PhysicsCategory.Car
        car.physicsBody?.contactTestBitMask = PhysicsCategory.LeftObstacle | PhysicsCategory.RightObstacle
        car.physicsBody?.dynamic = true
        car.physicsBody?.usesPreciseCollisionDetection = true
        
        //labels
        
        scoreLabel.text = NSString(format: "%i", scoreNumber) as String
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.yellowColor()
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        
        highscoreLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("highscoreNumber"))
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = SKColor.yellowColor()
        highscoreLabel.position = CGPoint(x: size.width*0.07, y: size.height*0.93)
        
        //addChildrenToScene
        addChild(car)
        addChild(scoreLabel)
        addChild(highscoreLabel)
        
        //addobstaclestimer
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addObstacles),
                SKAction.waitForDuration(obstacleInterval + 0.1)
                ])
            ))
        
        scoreNumber = -1
        highscoreNumber = NSUserDefaults.standardUserDefaults().integerForKey("highscoreNumber")
    
    }

    func addObstacles() {
        
        let gap = car.size.width*1.5
        
        let leftObstacleSize = random(min: 5, max: size.width - 100)
        let rightObstacleSize = size.width - leftObstacleSize - gap
        
        leftObstacle.size = CGSize(width: leftObstacleSize, height: 10)
        rightObstacle.size = CGSize(width: rightObstacleSize, height: 10)
        
        leftObstacle.color = SKColor.yellowColor()
        
        leftObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: leftObstacle.size)
        leftObstacle.physicsBody?.friction = 0.0
        leftObstacle.physicsBody?.restitution = 1.0
        leftObstacle.physicsBody?.dynamic = false
        leftObstacle.physicsBody?.categoryBitMask = PhysicsCategory.LeftObstacle
        leftObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        leftObstacle.physicsBody?.usesPreciseCollisionDetection = true
        
        rightObstacle.color = SKColor.yellowColor()
        
        rightObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: rightObstacle.size)
        rightObstacle.physicsBody?.friction = 0.0
        rightObstacle.physicsBody?.restitution = 1.0
        rightObstacle.physicsBody?.dynamic = false
        rightObstacle.physicsBody?.categoryBitMask = PhysicsCategory.RightObstacle
        rightObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Car
        rightObstacle.physicsBody?.usesPreciseCollisionDetection = true
        
        leftObstacle.position = CGPoint(x: leftObstacle.size.width/2, y: size.height - leftObstacle.size.height)
        rightObstacle.position = CGPoint(x: size.width - rightObstacle.size.width/2, y: size.height - rightObstacle.size.height)
        
        addChild(leftObstacle)
        addChild(rightObstacle)
        scoreAdded = false
        
        let actionMoveLeft = SKAction.moveTo(CGPoint(x: leftObstacle.position.x, y: 0), duration: NSTimeInterval(obstacleInterval))
        let actionMoveDoneLeft = SKAction.removeFromParent()
        leftObstacle.runAction(SKAction.sequence([actionMoveLeft, actionMoveDoneLeft]))
        
        let actionMoveRight = SKAction.moveTo(CGPoint(x: rightObstacle.position.x, y: 0), duration: NSTimeInterval(obstacleInterval))
        let actionMoveDoneRight = SKAction.removeFromParent()
        rightObstacle.runAction(SKAction.sequence([actionMoveRight, actionMoveDoneRight]))
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        let actualX = location.x
        
        car.position = CGPoint(x: actualX, y: car.position.y)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Car) != 0) && ((secondBody.categoryBitMask & PhysicsCategory.Car) != 0) {
            
            //println("hit")
            car.removeFromParent()
            leftObstacle.removeFromParent()
            rightObstacle.removeFromParent()
            
            NSUserDefaults.standardUserDefaults().setInteger(scoreNumber, forKey: "scoreNumber")
            NSUserDefaults.standardUserDefaults().setInteger(highscoreNumber, forKey: "highscoreNumber")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            let scene = GameOverScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            
        }

    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if car.position.y < highscoreLabel.position.y {
            car.position.y += 0.1
        }
        
        if leftObstacle.position.y < car.position.y && scoreAdded == false {
            scoreAdded = true
            scoreNumber += 1
            scoreLabel.text = String(scoreNumber)
        }
        
        if scoreNumber > highscoreNumber {
            highscoreNumber = scoreNumber
            highscoreLabel.text = String(highscoreNumber)
        }
        
        if (highscoreNumber > 99) {
            highscoreLabel.position.x = size.width * 0.1
        }
        
        obstacleInterval = 1 - (Double(scoreNumber) * 0.01) as Double
        
    }

}
