import SpriteKit
import GameplayKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK: Properties
    var cloudEmitter: SKEmitterNode!
    var player: PlayerNode!
    var candyMarker: SKLabelNode!
    var goBackMessage: SKLabelNode!
    var previousTime: TimeInterval?
    var previousCameraPosition: CGPoint?
    
    //MARK: Scene events
    public override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.player = self.childNode(withName: "Player") as! PlayerNode
        self.player.gameScene = self
        self.player.removeFromParent()
        self.addChild(self.player)
        
        self.cloudEmitter = self.childNode(withName: "Cloud Emitter") as! SKEmitterNode
        self.cloudEmitter.numParticlesToEmit = 0
    
        let horizontalRange = SKRange(lowerLimit: 320, upperLimit: 4000)
        let verticalRange = SKRange(lowerLimit: 240)
        self.camera?.constraints = [SKConstraint.positionX(horizontalRange), SKConstraint.positionY(verticalRange)]
        
        self.candyMarker = self.childNode(withName: ".//Candy Marker") as! SKLabelNode
        self.goBackMessage = self.childNode(withName: ".//Go Back Message") as! SKLabelNode
        
        let pit = self.childNode(withName: ".//Pit")!
        pit.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if let previousTime = self.previousTime {
            let dt = currentTime - previousTime
            self[".//*"].flatMap { $0 as? GameLoopEvents }.forEach { $0.update(deltaTime: dt) }
        }
        self.previousTime = currentTime
        
        if let previousPosition = self.previousCameraPosition {
            let ds = CGVector(dx: self.camera!.position.x - previousPosition.x, dy: self.camera!.position.y - previousPosition.y)
            self.cloudEmitter.position.x += ds.dx
            self.cloudEmitter.position.y += ds.dy
        }
        self.previousCameraPosition = self.camera!.position
        
        self.camera?.position = self.player!.position
    }
    
    //MARK: Input Events
    public override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            self.isPaused = !self.isPaused
        }
        
        self[".//*"].flatMap { $0 as? InputEvents }.forEach { $0.keyPressed(event.keyCode) }
    }
    
    public override func keyUp(with event: NSEvent) {
        self[".//*"].flatMap { $0 as? InputEvents }.forEach { $0.keyReleased(event.keyCode) }
    }
    
    public override func mouseUp(with event: NSEvent) {
        self[".//*"].flatMap { $0 as? InputEvents }.forEach { $0.mouseUp(at: event.location(in: self)) }
    }
    
    public override func mouseDown(with event: NSEvent) {
        self[".//*"].flatMap { $0 as? InputEvents }.forEach { $0.mouseDown(at: event.location(in: self)) }
    }
    
    public override func mouseMoved(with event: NSEvent) {
        self[".//*"].flatMap { $0 as? InputEvents }.forEach { $0.mouseMoved(to: event.location(in: self)) }
    }
    
    //MARK: Physics Events
    public func didBegin(_ contact: SKPhysicsContact) {
        self[".//*"].flatMap { $0 as? SKNode & PhysicsEvents }.forEach { dispatch(contact, for: $0) }
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        self[".//*"].flatMap { $0 as? SKNode & PhysicsEvents }.forEach { dispatch(contact, for: $0, begin: false) }
    }
    
    fileprivate func dispatch(_ contact: SKPhysicsContact, for node: SKNode & PhysicsEvents, begin: Bool = true) {
        if node.physicsBody == contact.bodyA || node.physicsBody == contact.bodyB {
            if begin { node.didBegin(contact) }
            else { node.didEnd(contact) }
        }
    }
}
