import SpriteKit

protocol GameLoopEvents {
    func update(deltaTime dt: TimeInterval)
}
   
protocol InputEvents {
    func keyPressed(_ keyCode: UInt16)
    func keyReleased(_ keyCode: UInt16)
    
    func mouseUp(at point: CGPoint)
    func mouseDown(at point: CGPoint)
    func mouseMoved(to point: CGPoint)
}
    
protocol PhysicsEvents {
    func didBegin(_ contact: SKPhysicsContact)
    func didEnd(_ contact: SKPhysicsContact)
}

extension InputEvents {
    func keyPressed(_ keyCode: UInt16) { }
    func keyReleased(_ keyCode: UInt16) { }
    
    func mouseUp(at point: CGPoint) { }
    func mouseDown(at point: CGPoint) { }
    func mouseMoved(to point: CGPoint) { }
}

extension PhysicsEvents {
    func didBegin(_ contact: SKPhysicsContact) { }
    func didEnd(_ contact: SKPhysicsContact) { }
}
