//
//  Instructions.swift
//  Save The Red Dots
//
//  Created by Jeffrey Ford on 6/29/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let instructionsWords = SKLabelNode(fontNamed: "Futura")
let returnToMainMenuLabel = SKLabelNode(fontNamed: "Futura")

class Instructions: SKScene{
    
    override func didMove(to view: SKView) {
    
        //levelCompleteLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        instructionsWords.numberOfLines = 0
        instructionsWords.text = "Welcome to Save the Red Dots!\n\nInstructions:\nUse gravity to move the red\ndot through the moving walls.\n\nRules:\nDon't touch the outer walls!\n\nStory Mode:\nAdvance through the levels \none by one. The higher level,\nthe faster the red dot moves!\nBut be careful, the walls\nwill begin to move faster as\nwell.\n\nArcade Mode:\nPlay until you touch the\nouter walls! The higher level\nyou have advanced to in story\nmode, the faster the dot\nmoves in arcade mode!"
        instructionsWords.fontSize = 50
        instructionsWords.fontColor = SKColor.white
        instructionsWords.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        instructionsWords.zPosition = 1
        self.addChild(instructionsWords)
        
        returnToMainMenuLabel.text = "Return to main menu"
        returnToMainMenuLabel.fontSize = 65
        returnToMainMenuLabel.fontColor = SKColor.white
        returnToMainMenuLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.08)
        returnToMainMenuLabel.zPosition = 1
        self.addChild(returnToMainMenuLabel)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch: AnyObject in touches{
                   
            let pointOfTouch = touch.location(in: self)
            print(pointOfTouch)
            
            if returnToMainMenuLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                print("self.size = \(self.size)")
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }

        }
    }
    
    
}
