import SpriteKit

class PlatformNode: SKSpriteNode, PhysicsEvents {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let image = NSImage(named: NSImage.Name("Platform"))
        let scaledImage = image?.resized(to: self.size, mode: .tile, insets: NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        self.texture = SKTexture(image: scaledImage!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactedBody = contact.separate(body: self.physicsBody!)
        
        if contactedBody.categoryBitMask.compare(to: UInt32.player) {
            let playerNode = contactedBody.node as! PlayerNode
            if playerNode.previousVelocity.dy > 0 {
                self.physicsBody?.categoryBitMask = UInt32.platform
            } else {
                self.physicsBody?.categoryBitMask = UInt32.floor
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        self.physicsBody?.categoryBitMask = UInt32.platform
    }
}
