import SpriteKit

extension SKPhysicsContact {
    func separate(body: SKPhysicsBody) -> SKPhysicsBody {
        return self.bodyA == body ? self.bodyB : self.bodyA
    }
    
    func isContactBelow(_ point: CGPoint) -> Bool {
        return point.y > self.contactPoint.y
    }
}
