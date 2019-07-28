import SpriteKit
import GameplayKit

class ButtonNode: SKSpriteNode, InputEvents {
    var clickCallback: (() -> ())?
    
    var stateMachine: GKStateMachine!
    
    var enabled: Bool = true {
        didSet {
            self.stateMachine.enter(enabled ? NormalState.self : DisabledState.self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.stateMachine = GKStateMachine(states: [NormalState(self), HoverState(self), ClickState(self), DisabledState(self)])
        self.stateMachine.enter(NormalState.self)
    }
    
    func mouseDown(at point: CGPoint) {
        guard enabled else { return }
        if self.contains(self.scene!.convert(point, to: self.parent!)) {
            self.stateMachine.enter(ClickState.self)
            clickCallback?()
        }
    }
    
    func mouseUp(at point: CGPoint) {
        guard enabled else { return }
        self.stateMachine.enter(self.contains(self.scene!.convert(point, to: self.parent!)) ? HoverState.self : NormalState.self)
    }
    
    func mouseMoved(to point: CGPoint) {
        guard enabled else { return }
        self.stateMachine.enter(self.contains(self.scene!.convert(point, to: self.parent!)) ? HoverState.self : NormalState.self)
    }
}

