import SpriteKit

class CandyNode: SKSpriteNode, PhysicsEvents {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactedBody = contact.separate(body: self.physicsBody!)
        if contactedBody.categoryBitMask.compare(to: UInt32.player) {
            self.removeFromParent()
        }
    }
}
