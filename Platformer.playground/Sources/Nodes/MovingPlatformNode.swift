import SpriteKit

class MovingPlatformNode: PlatformNode, GameLoopEvents {
    let pointA: CGPoint
    let pointB: CGPoint
    
    lazy var previousPosition: CGPoint = self.position
    var nodesOnTop = Set<SKNode>()
    var returning = false
    
    public required init?(coder aDecoder: NSCoder) {
        self.pointA = CGPoint(x: aDecoder.decodeDouble(forKey: "Point A1"), y: aDecoder.decodeDouble(forKey: "Point A2"))
        self.pointB = CGPoint(x: aDecoder.decodeDouble(forKey: "Point B1"), y: aDecoder.decodeDouble(forKey: "Point B2"))
        super.init(coder: aDecoder)
    }
    
    func update(deltaTime dt: TimeInterval) {
        self.nodesOnTop.forEach {
            let ds = CGVector(dx: self.position.x - self.previousPosition.x, dy: self.position.y - self.previousPosition.y)
            self.previousPosition = self.position
            
            $0.position.x += ds.dx
            $0.position.y += ds.dy
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        let contactedBody = contact.separate(body: self.physicsBody!)
        
        if contactedBody.categoryBitMask.compare(to: UInt32.player) {
            nodesOnTop.insert(contactedBody.node!)
        }
    }
    
    override func didEnd(_ contact: SKPhysicsContact) {
        super.didEnd(contact)
        let contactedBody = contact.separate(body: self.physicsBody!)
        
        nodesOnTop.remove(contactedBody.node!)
    }
}
