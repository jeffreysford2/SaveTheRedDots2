//
//  GamePlayScene.swift
//  Save The Red Dots
//
//  Created by Jeffrey Ford on 4/27/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion
import GameKit

struct PhysicsCategory{
    static let None : UInt32 = 0
    static let RedDot : UInt32 = 0b1
    static let Wall : UInt32 = 0b10
    static let BottomBoundary : UInt32 = 0b100
    static let TopBoundary : UInt32 = 0b1000
    static let LeftBoundary : UInt32 = 0b10000
    static let RightBoundary : UInt32 = 0b100000
}



class GamePlayScene: SKScene, SKPhysicsContactDelegate{
    var level = 1
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let gameOverLabel = SKLabelNode(fontNamed: "Futura")
    let tapToBeginLabel = SKLabelNode(fontNamed: "Futura")
    let returnToMainMenuLabel = SKLabelNode(fontNamed: "Futura")
    let finalScoreLabel = SKLabelNode(fontNamed: "Futura")
    let newHighScoreLabel = SKLabelNode(fontNamed: "Futura")
    
    //10 speed to start with
    var dotSpeed = 1
    var redDotSize = 0.5
    
    var abc = SKSpriteNode()
    
    var gameScore = 0
    var alive = true
    let gameArea: CGRect
    let manager = CMMotionManager()
    let redDot = SKSpriteNode(imageNamed: "red_dot")
    var wallPair = SKNode()
    var moveAndRemoveRightLeft = SKAction()
    var moveAndRemoveTopBottom = SKAction()
    var moveAndRemoveLeftRight = SKAction()
    var moveAndRemoveBottomTop = SKAction()
    var gameStarted = Bool()
    let bottomBoundary = SKSpriteNode(imageNamed: "Cyan Line Horizontal")
    let topBoundary = SKSpriteNode(imageNamed: "Cyan Line Horizontal")
    let leftBoundary = SKSpriteNode(imageNamed: "Cyan Line")
    let rightBoundary = SKSpriteNode(imageNamed: "Cyan Line")
    var marginSize = CGFloat()

    
    override init(size: CGSize){


        let maxAspectRatio: CGFloat = 16.0/9.0

        let playableWidth = size.height / maxAspectRatio
        print ("size.height = \(size.height)")
        print ("size.width = \(size.width)")
        //If 11 Pro Max, 11 Pro, 11, margin = 295

        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        print("game area is \(gameArea)")
        print("margin is \(margin)")
        marginSize = margin
        let screenSize: CGRect = UIScreen.main.bounds
        print("screenSize = \(screenSize)")
        
        
        //The following code changes the margin value for iphone X and later
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

            case 1334:
                print("iPhone 6/6S/7/8")

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

            case 2436:
                print("iPhone X/XS/11 Pro")
                marginSize = 295

            case 2688:
                print("iPhone XS Max/11 Pro Max")
                marginSize = 295

            case 1792:
                print("iPhone XR/ 11 ")
                marginSize = 295

            default:
                print("Unknown")
            }
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    func activateGravity(){
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        redDot.physicsBody!.affectedByGravity = true
        manager.startAccelerometerUpdates(to: OperationQueue()){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * CGFloat(self.dotSpeed), dy: CGFloat((data?.acceleration.y)!) * CGFloat(self.dotSpeed))
        }
    }
    
    func deactivateGravity(){
        redDot.physicsBody!.affectedByGravity = false
        redDot.physicsBody?.isDynamic = false
    }
    

    
    func createWallsFromTop(){
        wallPair = SKNode()
        let leftWall = SKSpriteNode(imageNamed: "Cyan Line Horizontal")
        let rightWall = SKSpriteNode(imageNamed: "Cyan Line Horizontal")
        
        rightWall.position = CGPoint(x: self.frame.width/2+900, y: self.frame.height)
        leftWall.position = CGPoint(x: self.frame.width/2-900, y: self.frame.height)
        
        rightWall.setScale(2.25)
        leftWall.setScale(2.25)
        
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.RedDot
        rightWall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.affectedByGravity = false
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.RedDot
        leftWall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.affectedByGravity = false
        
        wallPair.addChild(rightWall)
        wallPair.addChild(leftWall)
        
        wallPair.zPosition = 1
        let randomPosition = CGFloat.random(min: -300, max: 300)
        wallPair.position.x = wallPair.position.x + randomPosition
        
        self.addChild(wallPair)
        
        
        wallPair.run(moveAndRemoveTopBottom)
    }
    
    func createWallsFromRight(){
       
        
        print("Iphone 11 Pro Max")
        print("self.frame \(self.frame)")
        print("self.view?.frame \(self.view?.frame)")
        
        wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Cyan Line")
        let bottomWall = SKSpriteNode(imageNamed: "Cyan Line")
       
        
        topWall.position = CGPoint(x: self.frame.width-marginSize, y: self.frame.height/2 + 900)
        bottomWall.position = CGPoint(x: self.frame.width-marginSize, y: self.frame.height/2 - 900)
        print("Top wall position is \(topWall.position)")
        
        print("self.frame.width = \(self.frame.width)")
        
        
        topWall.setScale(2.25)
        bottomWall.setScale(2.25)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.RedDot
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.RedDot
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        wallPair.zPosition = 1
        let randomPosition = CGFloat.random(min: -500, max: 500)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        self.addChild(wallPair)
        

        wallPair.run(moveAndRemoveRightLeft)
        
    }
    
    override func didMove(to view: SKView) {

        let defaults = UserDefaults()
        level = defaults.integer(forKey: "levelSaved")
        
        if level == 0{
            level = 1
        }

        //The below code sets high score to 0, make sure this is commented out
        //defaults.set(0, forKey: "gameScoreSaved")
        
        //level = 100
        dotSpeed = level/5 + 5
        
        redDotSize = 0.5 - Double(level)/800
        
        
        
        self.physicsWorld.contactDelegate = self
        
        returnToMainMenuLabel.text = "Return To Main Menu"
        returnToMainMenuLabel.fontSize = 75
        returnToMainMenuLabel.fontColor = SKColor.white
        returnToMainMenuLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        returnToMainMenuLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        returnToMainMenuLabel.zPosition = 100
        self.addChild(returnToMainMenuLabel)
        
        tapToBeginLabel.text = "Tap to Begin!"
        tapToBeginLabel.fontSize = 50
        tapToBeginLabel.fontColor = SKColor.white
        tapToBeginLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapToBeginLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        tapToBeginLabel.zPosition = 100
        self.addChild(tapToBeginLabel)
        
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.05)
        print(scoreLabel.position)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        redDot.setScale(CGFloat(redDotSize))
        redDot.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        redDot.zPosition = 3
        redDot.physicsBody = SKPhysicsBody(circleOfRadius: redDot.frame.height/2)
        redDot.physicsBody?.categoryBitMask = PhysicsCategory.RedDot
        redDot.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        redDot.physicsBody?.contactTestBitMask = PhysicsCategory.BottomBoundary | PhysicsCategory.RightBoundary | PhysicsCategory.LeftBoundary | PhysicsCategory.TopBoundary
        
        
        redDot.physicsBody?.affectedByGravity = false
        redDot.physicsBody?.isDynamic = true
        self.addChild(redDot)
        
        bottomBoundary.setScale(3.125)
        bottomBoundary.position = CGPoint(x: self.size.width/2, y: 0)
        bottomBoundary.zPosition = 2
        bottomBoundary.physicsBody = SKPhysicsBody(rectangleOf: bottomBoundary.size)
        
        bottomBoundary.physicsBody?.categoryBitMask = PhysicsCategory.BottomBoundary
        bottomBoundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        bottomBoundary.physicsBody?.contactTestBitMask = PhysicsCategory.RedDot
        bottomBoundary.physicsBody?.affectedByGravity = false
        bottomBoundary.physicsBody?.isDynamic = false
        self.addChild(bottomBoundary)
        
        rightBoundary.setScale(3.125)
        rightBoundary.position = CGPoint(x: self.size.width-marginSize, y: self.size.height/2)
        rightBoundary.zPosition = 2
        rightBoundary.physicsBody = SKPhysicsBody(rectangleOf: rightBoundary.size)
        rightBoundary.physicsBody?.categoryBitMask = PhysicsCategory.RightBoundary
        rightBoundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        rightBoundary.physicsBody?.contactTestBitMask = PhysicsCategory.RedDot
        rightBoundary.physicsBody?.affectedByGravity = false
        rightBoundary.physicsBody?.isDynamic = false
        self.addChild(rightBoundary)
        
        topBoundary.setScale(3.125)
        topBoundary.position = CGPoint(x: self.size.width/2, y: self.size.height)
        topBoundary.zPosition = 2
        topBoundary.physicsBody = SKPhysicsBody(rectangleOf: topBoundary.size)
        topBoundary.physicsBody?.categoryBitMask = PhysicsCategory.TopBoundary
        topBoundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        topBoundary.physicsBody?.contactTestBitMask = PhysicsCategory.RedDot
        topBoundary.physicsBody?.affectedByGravity = false
        topBoundary.physicsBody?.isDynamic = false
        self.addChild(topBoundary)
        
        leftBoundary.setScale(3.125)
        
        leftBoundary.position = CGPoint(x: marginSize, y: self.size.height/2)
        leftBoundary.zPosition = 2
        leftBoundary.physicsBody = SKPhysicsBody(rectangleOf: rightBoundary.size)
        leftBoundary.physicsBody?.categoryBitMask = PhysicsCategory.LeftBoundary
        leftBoundary.physicsBody?.collisionBitMask = PhysicsCategory.None
        leftBoundary.physicsBody?.contactTestBitMask = PhysicsCategory.RedDot
        leftBoundary.physicsBody?.affectedByGravity = false
        leftBoundary.physicsBody?.isDynamic = false
        self.addChild(leftBoundary)
        
    }
    
    //This will run when two physics bodies make contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //This if statement assigns the body with the lower category number (see "struct PhysicalCategories") to be "body1". body2 will be the body with the higher number.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //if redDot has hit boundary
        if (body1.categoryBitMask == PhysicsCategory.RedDot && body2.categoryBitMask == PhysicsCategory.BottomBoundary) || (body1.categoryBitMask == PhysicsCategory.RedDot && body2.categoryBitMask == PhysicsCategory.LeftBoundary) || (body1.categoryBitMask == PhysicsCategory.RedDot && body2.categoryBitMask == PhysicsCategory.RightBoundary) || (body1.categoryBitMask == PhysicsCategory.RedDot && body2.categoryBitMask == PhysicsCategory.TopBoundary){
            
            
            alive = false
            deactivateGravity()
            runGameOver()
            
        }
    }
    
    func runGameOver(){
        
        
        
        self.removeAllActions()

        let changeSceneAction = SKAction.run(restartScene)
        let waitToChangeScene = SKAction.wait(forDuration: 4)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 120
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        gameOverLabel.zPosition = 1
        gameOverLabel.alpha = 0
        self.addChild(gameOverLabel)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.6)
        gameOverLabel.run(fadeInAction)
        
        finalScoreLabel.text = "Final Score: \(gameScore)"
        finalScoreLabel.fontSize = 80
        finalScoreLabel.fontColor = SKColor.white
        finalScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.43)
        finalScoreLabel.zPosition = 1
        finalScoreLabel.alpha = 0
        self.addChild(finalScoreLabel)
        let fadeInAction2 = SKAction.fadeIn(withDuration: 0.6)
        finalScoreLabel.run(fadeInAction2)
        
        newHighScoreLabel.text = "New High Score!"
        newHighScoreLabel.fontSize = 80
        newHighScoreLabel.fontColor = SKColor.orange
        newHighScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        newHighScoreLabel.zPosition = 1
        newHighScoreLabel.alpha = 0
        self.addChild(newHighScoreLabel)
        let fadeInAction3 = SKAction.fadeIn(withDuration: 0.2)
        
        //print("gameScore = \(gameScore)")
        
        
        
        
        let defaults = UserDefaults()
        //print("defaults.integer(forKey: gameScoreSaved) = \(defaults.integer(forKey: "gameScoreSaved"))")
        if gameScore > defaults.integer(forKey: "gameScoreSaved") {
            newHighScoreLabel.run(fadeInAction3)
            defaults.set(gameScore, forKey: "gameScoreSaved")
            saveHighScore()
        
        }
    }
    
    func saveHighScore(){
        
        let player = GKLocalPlayer.local
        if player.isAuthenticated{
            
            let scoreReporter = GKScore(leaderboardIdentifier: "SaveTheRedDotLeaderboard")
            scoreReporter.value = Int64(gameScore)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
        
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        
        
    }
    
    func restartScene(){
        
        let sceneToMoveTo = GamePlayScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    func addScore(){
        
        if alive == true{
            gameScore += 1
            scoreLabel.text = "Score: \(gameScore)"
        }
        

        
    }
    
    override func update(_ curentTime: CFTimeInterval){
        //called before each frame is rendered
    }
    
    
    func removeTapAndLevel(){
        let removeTap = SKAction.removeFromParent()
        let removeLevel = SKAction.removeFromParent()
        let removeRTMM = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: 0.1)
        let sequence1 = SKAction.sequence([wait, removeTap])
        let sequence2 = SKAction.sequence([wait, removeLevel])
        let sequence3 = SKAction.sequence([wait, removeRTMM])
        tapToBeginLabel.run(sequence1)
        
        returnToMainMenuLabel.run(sequence3)
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
        

            
        if gameStarted == false{
            gameStarted = true
            removeTapAndLevel()

                let spawn = SKAction.run({
                    () in
                    var rightTopLeftBottom = CGFloat.random(min: 1, max: 2)
                    rightTopLeftBottom = round(rightTopLeftBottom)
                    if rightTopLeftBottom == 1 {
                        self.createWallsFromRight()
                    } else{
                        self.createWallsFromTop()
                    }
                })
            
            //The below might only be able to be run once (if havent tapped yet, run, but if already tapped, can't run)
            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let SpawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(SpawnDelayForever)
            
            //print("hi")
            
            let distanceX = CGFloat(self.frame.width + wallPair.frame.width - marginSize * 2)
           
            let movePipesX = SKAction.moveBy(x: -distanceX, y: 0.0, duration: TimeInterval(0.005 * distanceX))
            let removePipes = SKAction.removeFromParent()
            let increaseScore = SKAction.run {
                self.addScore()
            }
            moveAndRemoveRightLeft = SKAction.sequence([movePipesX, removePipes, increaseScore])

            let distanceY = CGFloat(self.frame.height + wallPair.frame.width)
            let movePipesY = SKAction.moveBy(x: 0.0, y: -distanceY, duration: TimeInterval(0.005 * distanceX))
            
            //let x = 0.005 * distanceX
            //let y = 0.005 * 3 / 4 * distanceY
            //print(x)
            //print(y)
            moveAndRemoveTopBottom = SKAction.sequence([movePipesY, removePipes, increaseScore])
        }else{
            
        }
        
        activateGravity()

    

    }
    
}
