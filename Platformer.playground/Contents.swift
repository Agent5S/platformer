//: Playground - noun: a place where people can play

import PlaygroundSupport
import AppKit
import SpriteKit

let view = JGView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))
let scene = IntroScene(fileNamed: "IntroScene")
view.presentScene(scene)

PlaygroundPage.current.liveView = view
