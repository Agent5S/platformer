import SpriteKit
import GameplayKit

class ButtonState: GKState {
    unowned var buttonNode: ButtonNode
    var regularAlpha: CGFloat!
    
    init(_ buttonNode: ButtonNode) {
        self.buttonNode = buttonNode
        self.regularAlpha = buttonNode.alpha
    }
}

class NormalState: ButtonState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return !(stateClass == ClickState.self || stateClass == NormalState.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        let action1 = SKAction.scale(to: 1, duration: 0.3)
        let action2 = SKAction.fadeAlpha(to: regularAlpha, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action1)
        self.buttonNode.run(action2)
    }
}

class HoverState: ButtonState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != HoverState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        let action = SKAction.scale(to: 1.1, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action)
    }
    
    override func willExit(to nextState: GKState) {
        guard nextState is ClickState else { return }
        
        let action = SKAction.scale(to: 1, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action)
    }
}

class ClickState: ButtonState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != ClickState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        let action = SKAction.scale(to: 0.8, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action)
    }
    
    override func willExit(to nextState: GKState) {
        guard nextState is HoverState else { return }
        
        let action = SKAction.scale(to: 1, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action)
    }
}

class DisabledState: ButtonState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == NormalState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        let action = SKAction.fadeAlpha(to: 0, duration: 0.3)
        self.buttonNode.removeAllActions()
        self.buttonNode.run(action)
    }
}
