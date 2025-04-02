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
    let symbol = Symbol()
    
    let score = Score()
    
    var currentLevel = 0
    var bottleSpeed = 1.0
    var gameEnded = false
    var roundClick = false

    
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
        bottle.addChild(bottleFlash)
        
        addChild(table)
        addChild(bottle)
        addChild(gauge)
        addChild(score)
        addChild(symbol)
        
        gauge.isHidden = true
        bottleFlash.run(SKAction.fadeOut(withDuration: 0.1))
        
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
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
        roundClick = false
        gauge.isHidden = true
        if gameEnded {
            gameOver()
        }
    }
    
    func fillGauge() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 1000))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 1800 * bottleSpeed)
        gaugeFiller.run(move)
    }
    
    func flashBottleFlash() {
        let animateList = SKAction.sequence([SKAction.fadeIn(withDuration: 0.1), SKAction.wait(forDuration: 0.2), SKAction.fadeOut(withDuration: 0.1)])
        bottleFlash.run(animateList)
    }
    
    func updateBottleSpeed() {
        switch currentLevel {
        case 0...5:
            bottleSpeed += 0.050
        case 5...15:
            bottleSpeed += 0.025
        case 15...20:
            bottleSpeed += 0.020
        case 20...25:
            bottleSpeed += 0.015
        case 25...50:
            bottleSpeed += 0.010
        default:
            bottleSpeed += 0.005
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if !gameEnded {
                // Check if bottle is not already in air
                if !bottle.flipping {
                    // Any commands to be executed while bottle is in air go here...
                    bottle.flipping = true
                    gauge.isHidden = false
                    
                    fillGauge()
                    
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 300))
                    
                    let downPath = UIBezierPath()
                    downPath.move(to: CGPoint(x: 0, y: 0))
                    downPath.addLine(to: CGPoint(x: 0,y: -300))
                    
                    
                    let movement = SKAction.sequence([
                        SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 500 * bottleSpeed),
                        SKAction.follow(downPath.cgPath, asOffset: true, orientToPath: false, speed: 600 * bottleSpeed)])
                    bottle.run(movement, completion: finishFlip)
                    
                    
                } else {
                    //Player click screen CORRECT during bottle flip
                    if gaugeFiller.position.y > 250 {
                        flashBottleFlash()
                        currentLevel += 1
                        score.updateLabel(currentLevel)
                        updateBottleSpeed()
                        roundClick = true
                    } else {
                        if !roundClick {
                            //Player click screen WRONG during bottle flip
                            let shake = SKAction.shake(duration: 0.6)
                            bottle.run(shake)
                            gameEnded = true
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            
        }
    }
    
    func gameOver() {
        bottle.gameOver()
        score.gameOver()
        
        
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


extension SKAction {
    class func shake(duration:CGFloat, amplitudeX:Int = 20, amplitudeY:Int = 20) -> SKAction {
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            let forward = SKAction.moveBy(x: dx, y:dy, duration: 0.015)
            let reverse = forward.reversed()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
}
