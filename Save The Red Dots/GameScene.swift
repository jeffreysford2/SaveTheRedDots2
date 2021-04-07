//
//  GameScene.swift
//  Save The Red Dots
//
//  Created by Jeffrey Ford on 4/27/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

let titleLabel = SKLabelNode(fontNamed: "Futura")
let arcadeModeLabel = SKLabelNode(fontNamed: "Futura")
let storyModeLabel = SKLabelNode(fontNamed: "Futura")
let redDot = SKSpriteNode(imageNamed: "red_dot")
let storyModeLevelLabel = SKLabelNode(fontNamed: "Futura")
let arcadeModeHighScoreLabel = SKLabelNode(fontNamed: "Futura")
let leaderboardLabel = SKLabelNode(fontNamed: "Futura")
let instructionsLabel = SKLabelNode(fontNamed: "Futura")

class GameScene: SKScene, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    override func didMove(to view: SKView) {
        
        let defaults = UserDefaults()
        let levelSaved = defaults.integer(forKey: "levelSaved")
        let gameScoreSaved = defaults.integer(forKey: "gameScoreSaved")
        
        
        titleLabel.text = "SAVE THE RED DOT"
        titleLabel.fontSize = 100
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.82)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        redDot.setScale(1)
        redDot.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        //redDot.physicsBody = SKPhysicsBody(circleOfRadius: redDot.frame.height/2)
        self.addChild(redDot)
        
        storyModeLabel.text = "Story Mode"
        storyModeLabel.fontSize = 80
        storyModeLabel.fontColor = SKColor.white
        storyModeLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        storyModeLabel.zPosition = 1
        self.addChild(storyModeLabel)
        
        arcadeModeLabel.text = "Arcade Mode"
        arcadeModeLabel.fontSize = 80
        arcadeModeLabel.fontColor = SKColor.white
        arcadeModeLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.42)
        arcadeModeLabel.zPosition = 1
        self.addChild(arcadeModeLabel)
        
        leaderboardLabel.text = "Leaderboard"
        leaderboardLabel.fontSize = 80
        leaderboardLabel.fontColor = SKColor.white
        leaderboardLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.34)
        leaderboardLabel.zPosition = 1
        self.addChild(leaderboardLabel)
        
        instructionsLabel.text = "Instructions"
        instructionsLabel.fontSize = 80
        instructionsLabel.fontColor = SKColor.white
        instructionsLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.26)
        instructionsLabel.zPosition = 1
        self.addChild(instructionsLabel)
        
        storyModeLevelLabel.text = "Story Mode Level: \(levelSaved)"
        storyModeLevelLabel.fontSize = 38
        storyModeLevelLabel.fontColor = SKColor.white
        storyModeLevelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        storyModeLevelLabel.position = CGPoint(x: self.size.width*0.53, y: self.size.height*0.03)
        print(storyModeLevelLabel.position)
        storyModeLevelLabel.zPosition = 100
        self.addChild(storyModeLevelLabel)
        
        arcadeModeHighScoreLabel.text = "Arcade High Score: \(gameScoreSaved)"
        arcadeModeHighScoreLabel.fontSize = 38
        arcadeModeHighScoreLabel.fontColor = SKColor.white
        arcadeModeHighScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        arcadeModeHighScoreLabel.position = CGPoint(x: self.size.width*0.47, y: self.size.height*0.03)
        print(arcadeModeHighScoreLabel.position)
        arcadeModeHighScoreLabel.zPosition = 100
        self.addChild(arcadeModeHighScoreLabel)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
                
            let pointOfTouch = touch.location(in: self)
            
            if arcadeModeLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GamePlayScene(size: self.size)
                print("self.size = \(self.size)")
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if storyModeLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = StoryMode(size: self.size)
                print("self.size = \(self.size)")
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if instructionsLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = Instructions(size: self.size)
                print("self.size = \(self.size)")
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
         
            if leaderboardLabel.contains(pointOfTouch){
                showLeaderboard()
            }
            
        }

    }
    func showLeaderboard(){
        let viewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
    }
}


    
    
    /*func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
} */

