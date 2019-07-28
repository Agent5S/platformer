//
//  PlayerNode.swift
//  Platformer
//
//  Created by Jorge on 3/27/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerNode: SKNode, GameLoopEvents, InputEvents, PhysicsEvents {
    //MARK: Properties
    let maxVelocity = CGVector(dx: 100, dy: 250)
    var pressedKeys = Set<UInt16>()
    var bodiesBeneath = Set<SKPhysicsBody>()
    var candies = 0
    
    weak var gameScene: GameScene!
    var stateMachine: GKStateMachine!
    var previousVelocity: CGVector!
    
    //MARK: Calculated Properties
    var sprite: SKNode? {
        get { return self.children.first }
        set {
            guard let newValue = newValue else { return }
            self.removeAllChildren()
            self.addChild(newValue)
        }
    }
    
    //MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        //Set up node physics body
        let upperCircle = SKPhysicsBody(circleOfRadius: 85, center: CGPoint(x: 0, y: 72.5))
        let lowerCircle = SKPhysicsBody(circleOfRadius: 35, center: CGPoint(x: 0, y: -22.5))
        let physicsBody = SKPhysicsBody(bodies: [upperCircle, lowerCircle])
        physicsBody.categoryBitMask = UInt32(UInt32.player)
        physicsBody.contactTestBitMask = UInt32(UInt32.floor, UInt32.platform, UInt32.checkpoint, UInt32.pit)
        physicsBody.collisionBitMask = UInt32(UInt32.floor)
        physicsBody.allowsRotation = false
        physicsBody.friction = 0
        physicsBody.restitution = 0
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        
        super.init(coder: aDecoder)
        self.physicsBody = physicsBody
        self.stateMachine = GKStateMachine(states: [IdleState(self), FallingState(self), WalkingState(self)])
        self.stateMachine.enter(IdleState.self)
    }
    
    //MARK: EntityEvents
    //Gameloop Events
    func update(deltaTime dt: TimeInterval) {
        let physicsBody = self.physicsBody!
        
        var walking = false
        if pressedKeys.contains(123) {
            walking = true
            if physicsBody.velocity.dx > -240 {
                if physicsBody.velocity.dx > 0 { physicsBody.velocity.dx = 0 }
                physicsBody.velocity.dx -= 480 * CGFloat(dt)
            } else {
                physicsBody.velocity.dx = -240
            }
            self.xScale = -1
        }
        if pressedKeys.contains(124) {
            walking = true
            if physicsBody.velocity.dx < 240 {
                if physicsBody.velocity.dx < 0 { physicsBody.velocity.dx = 0 }
                physicsBody.velocity.dx += 480 * CGFloat(dt)
            } else {
                physicsBody.velocity.dx = 240
            }
            self.xScale = 1
        }
        if !walking {
            physicsBody.velocity.dx = 0
        }
        
        if self.physicsBody!.velocity.dy < 0 { self.scene?.physicsWorld.gravity.dy = -19.6 }
        self.stateMachine.enter(walking ? WalkingState.self : IdleState.self)
        self.previousVelocity = self.physicsBody?.velocity
    }
    
    //Input Events
    func keyPressed(_ keyCode: UInt16) {
        //KeyCodes 123: ←, 124: →, 125: ↓, 126: ↑, 49: Space, 36: Enter
        if pressedKeys.contains(keyCode) { return }
        
        if keyCode == 49 && self.stateMachine.canEnterState(FallingState.self) {
            //self.player?.physicsComponent?.physicsBody.velocity.dy = 797
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 940))
            self.scene?.physicsWorld.gravity.dy = -4.9
        }
        
        self.pressedKeys.insert(keyCode)
    }
    
    func keyReleased(_ keyCode: UInt16) {
        self.pressedKeys.remove(keyCode)
        
        if keyCode == 49 {
            self.scene?.physicsWorld.gravity.dy = -19.6
        }
    }
    
    //Physics Events
    func didBegin(_ contact: SKPhysicsContact) {
        let contactedBody = contact.separate(body: self.physicsBody!)
        if contact.contactPoint.y < self.position.y {
            self.bodiesBeneath.insert(contactedBody)
        }
        
        if contactedBody.categoryBitMask.compare(to: UInt32.pit) {
            let gameOverScene = GameOverScene(fileNamed: "GameOverScene")!
            self.scene!.view!.presentScene(gameOverScene, transition: SKTransition.crossFade(withDuration: 1))
        }
        if contactedBody.categoryBitMask.compare(to: UInt32.candy) {
            self.candies += 1
            self.gameScene.candyMarker.text = "\(self.candies) / 5"
        }
        if contactedBody.categoryBitMask.compare(to: UInt32.checkpoint) {
            if self.candies < 5 {
                self.gameScene.goBackMessage.isHidden = false
            } else {
                let victoryScene = VictoryScene(fileNamed: "VictoryScene")!
                self.scene!.view!.presentScene(victoryScene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
        
        if !self.bodiesBeneath.isEmpty {
            if self.stateMachine.canEnterState(LandingState.self) {
                self.stateMachine.enter(LandingState.self)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactedBody = contact.separate(body: self.physicsBody!)
        self.bodiesBeneath.remove(contactedBody)
        
        if contactedBody.categoryBitMask.compare(to: UInt32.checkpoint) {
            if self.candies < 5 {
                self.gameScene.goBackMessage.isHidden = true
            }
        }
        
        if self.bodiesBeneath.isEmpty {
            if self.stateMachine.canEnterState(FallingState.self) {
                self.stateMachine.enter(FallingState.self)
            }
        }
    }
}
