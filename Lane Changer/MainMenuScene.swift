//
//  MainMenuScene.swift
//  Lane Changer
//
//  Created by Logan Geefs on 2014-12-25.
//  Copyright (c) 2014 Logan Geefs. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    
    //DECLARE SPRITES AND LABELS
    //labels
    let play = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    let copyright = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    
    override func didMoveToView(view: SKView) {
        
        //set background color
        backgroundColor = SKColor.blackColor()
        
        play.text = "Tap to Play"
        play.fontSize = size.width/7
        play.fontColor = SKColor.yellowColor()
        play.position = CGPoint(x: size.width/2, y: size.height/2)
        
        copyright.text = "Copyright © Logan Geefs"
        copyright.fontSize = size.width/15
        copyright.fontColor = SKColor.yellowColor()
        copyright.position = CGPoint(x: size.width/2, y: size.height*0.05)
        
        //addChildrenToScene
        
        addChild(play)
        addChild(copyright)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        if play.containsPoint(location) {
            
            play.color = SKColor.blueColor()
            
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        if play.containsPoint(location) {
            
            let reveal = SKTransition.fadeWithDuration(0.5)
            let scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
    }
    
}
