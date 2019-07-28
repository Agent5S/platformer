import SpriteKit

public class IntroScene: SKScene {
    var infoButton: ButtonNode!
    var startLabel: SKLabelNode!
    var loadLabel: SKLabelNode!
    
    public override func didMove(to view: SKView) {
        self.infoButton = self.childNode(withName: ".//Info Button") as! ButtonNode
        self.startLabel = self.childNode(withName: ".//Start") as! SKLabelNode
        self.loadLabel = self.childNode(withName: ".//Loading Message") as! SKLabelNode
        
        self.infoButton.clickCallback = { () -> () in
            self.infoButton.enabled = false
            let menu = JGReferenceNode(fileNamed: "Menu")!
            menu.name = "Menu"
            menu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            menu.zPosition = 40
            self.addChild(menu)
            
            let backButton = self.childNode(withName: ".//Back") as! ButtonNode
            backButton.clickCallback = { () -> () in
                let menu = self.childNode(withName: ".//Menu")!
                menu.run(SKAction.fadeAlpha(to: 0, duration: 0.3)) {
                    menu.removeFromParent()
                }
                self.infoButton.enabled = true
            }
        }
    }
    
    public override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            let gameScene = GameScene(fileNamed: "GameScene")!
            self.view!.presentScene(gameScene)
        }
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
}
