//
//  GameScene.swift
//  FlipTheBottle Shared
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import SpriteKit
import Darwin

class GameScene: SKScene {
    
    let table = TableTop()
    let bottle = Bottle()
    
    let gauge = Gauge()
    let gaugeFiller = GaugeFiller()
    
    let bottleFlash = BottleFlash()
    
    let score = Score()
    
    let currentLevel = 1

    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        gauge.addChild(gaugeFiller)
        
        addChild(table)
        addChild(bottle)
        addChild(gauge)
        addChild(bottleFlash)
        addChild(score)
        
        gauge.isHidden = true
        bottleFlash.run(SKAction.fadeOut(withDuration: 0.1))
        
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    func finishFlip() {
        bottle.flipping = false
        gauge.isHidden = true
    }
    
    func fillGauge() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 1000))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 1800)
        gaugeFiller.run(move)
    }
    
    func flashBottleFlash() {
        let animateList = SKAction.sequence([SKAction.fadeIn(withDuration: 0.1), SKAction.wait(forDuration: 0.2), SKAction.fadeOut(withDuration: 0.1)])
        bottleFlash.run(animateList)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            // Check if bottle is not already in air
            if !bottle.flipping {
                // Any commands to be executed while bottle is in air go here...
                bottle.flipping = true
                gauge.isHidden = false
                
                fillGauge()
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 300))
                path.addLine(to: CGPoint(x: 0, y: 0))
                
                //TODO: Bottle needs to fall DOWN faster (because of gravity)
                let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 500)
                bottle.run(move, completion: finishFlip)
            } else {
                if gaugeFiller.position.y > 250 {
                    flashBottleFlash()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

