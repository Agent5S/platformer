import SpriteKit

public class GameOverScene: SKScene {
    public override func keyDown(with event: NSEvent) {
        let gameScene = GameScene(fileNamed: "GameScene")
        self.view!.presentScene(gameScene)
    }
}
