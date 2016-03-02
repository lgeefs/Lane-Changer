//
//  GameOverScene.swift
//  Lane Changer
//
//  Created by Logan Geefs on 2015-03-23.
//  Copyright (c) 2015 Logan Geefs. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene : SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "Optima-BoldItalic")
    let mainMenuLabel = SKLabelNode(fontNamed: "Optima-BoldItalic")
    let highscoreLabel = SKLabelNode(fontNamed: "Optima")
    let scoreLabel = SKLabelNode(fontNamed: "Optima")
    
    var highscoreNumber = NSUserDefaults.standardUserDefaults().integerForKey("highscoreNumber")
    var scoreNumber = NSUserDefaults.standardUserDefaults().integerForKey("scoreNumber")
    
    override func didMoveToView(view: SKView) {
        
        restartLabel.text = "Restart"
        restartLabel.fontColor = SKColor.yellowColor()
        restartLabel.fontSize = 24
        restartLabel.position = CGPoint(x: size.width/2, y: size.height*0.2)
        
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontColor = SKColor.yellowColor()
        mainMenuLabel.fontSize = 24
        mainMenuLabel.position = CGPoint(x: size.width/2, y: size.height*0.8)
        
        highscoreLabel.text = "Highscore: " + String(highscoreNumber)
        highscoreLabel.fontColor = SKColor.yellowColor()
        highscoreLabel.fontSize = 24
        highscoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.6)
        
        scoreLabel.text = "Score: " + String(scoreNumber)
        scoreLabel.fontColor = SKColor.yellowColor()
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.4)
        
        addChild(restartLabel)
        addChild(mainMenuLabel)
        addChild(highscoreLabel)
        addChild(scoreLabel)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            if nodeAtPoint(touch.locationInNode(self)) == restartLabel {
                
                let reveal = SKTransition.crossFadeWithDuration(0.5)
                let scene = GameScene(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
                
            } else if nodeAtPoint(touch.locationInNode(self)) == mainMenuLabel {
                
                let reveal = SKTransition.crossFadeWithDuration(0.5)
                let scene = MainMenuScene(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
                
            }
            
        }
        
    }
    
}
