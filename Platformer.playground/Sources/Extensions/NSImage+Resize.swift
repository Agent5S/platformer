import Cocoa

public extension NSImage {
    func resized(to size: NSSize, mode: NSImage.ResizingMode = .stretch, insets: NSEdgeInsets? = nil) -> NSImage {
        if let insets = insets, mode == .tile {
            self.resizingMode = mode
            self.capInsets = insets
        }
        
        let ret = NSImage(size: size)
        ret.lockFocus()
        self.draw(in: NSRect(x: 0, y: 0, width: size.width, height: size.height), from: NSRect(x: 0, y: 0, width: self.size.width, height: self.size.height), operation: .sourceOver, fraction: 1)
        ret.unlockFocus()
        ret.size = size
        return NSImage(data: ret.tiffRepresentation!)!
    }
}

