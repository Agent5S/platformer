import SpriteKit

public class JGView: SKView {
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        let trackingOptions: NSTrackingArea.Options = [.mouseMoved, .activeInKeyWindow, .activeAlways, .inVisibleRect] as NSTrackingArea.Options
        let tracker = NSTrackingArea(rect: self.frame, options: trackingOptions, owner: self, userInfo: nil)
        self.addTrackingArea(tracker)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

