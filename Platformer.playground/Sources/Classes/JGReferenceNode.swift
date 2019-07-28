import SpriteKit

fileprivate extension SKNode {
    func setIsPausedRecursively(_ value: Bool) {
        self.isPaused = value
        for child in self.children {
            child.setIsPausedRecursively(value)
        }
    }
}

class JGReferenceNode: SKReferenceNode {
    override func didLoad(_ node: SKNode?) {
        super.didLoad(node)
        
        node?.setIsPausedRecursively(false)
    }
}
