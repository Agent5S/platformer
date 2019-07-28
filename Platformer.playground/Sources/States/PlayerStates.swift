import SpriteKit
import GameplayKit

fileprivate extension SKNode {
    func removeActionRecursively(forKey key: String) {
        self.removeAction(forKey: key)
        for child in self.children {
            child.removeAction(forKey: key)
        }
    }
}

class PlayerState: GKState {
    unowned var playerNode: PlayerNode
    
    init(_ playerNode: PlayerNode) {
        self.playerNode = playerNode
    }
}

class IdleState: PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return !(stateClass == IdleState.self || stateClass == LandingState.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        self.playerNode.sprite = JGReferenceNode(fileNamed: "Player Idle")!
    }
}

class FallingState: PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == LandingState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        self.playerNode.sprite = JGReferenceNode(fileNamed: "Player Fall")!
    }
}

class LandingState: PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return !(stateClass == FallingState.self || stateClass == LandingState.self)
    }
}

class WalkingState: PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return !(stateClass == WalkingState.self || stateClass == LandingState.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        self.playerNode.sprite = JGReferenceNode(fileNamed: "Player Walk")!
    }
}
