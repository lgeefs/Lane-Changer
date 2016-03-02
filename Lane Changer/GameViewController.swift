//
//  GameViewController.swift
//  Lane Changer
//
//  Created by Logan Geefs on 2014-12-25.
//  Copyright (c) 2014 Logan Geefs. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainMenuScene = MainMenuScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        mainMenuScene.scaleMode = .AspectFill
        
        skView.presentScene(mainMenuScene)
        
        
    }
    
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
