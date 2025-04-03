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
    
    var symbolActivate = false
    
    var flash = SKAction.sequence([
        SKAction.fadeIn(withDuration: 0.1),
        SKAction.wait(forDuration: 0.2),
        SKAction.fadeOut(withDuration: 0.1)])

    
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
        //bottle.addChild(bottleFlash)
        
        addChild(table)
        addChild(bottle)
        addChild(gauge)
        addChild(score)
        addChild(symbol)
        
        gauge.run(SKAction.fadeOut(withDuration: 0.01))
        symbol.run(SKAction.fadeOut(withDuration: 0.01))
        bottleFlash.run(SKAction.fadeOut(withDuration: 0.01))
        
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
            swipe.direction = direction
            view.addGestureRecognizer(swipe)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    func finishFlip() {
        //MIGHT NEED TO CHANGE THIS VALUE IF TOO CLOSE TO BOTTOM OF SWIPING
        if self.speed < 0.4 {
            gameEnded = true
        }
        gauge.run(SKAction.fadeOut(withDuration: 0.05))
        self.run(SKAction.speed(to: 1.0, duration: 0.05))

        bottle.flipping = false
        roundClick = false
        symbolActivate = false
        
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
    
    
    func handleInitialFlip() {
        bottle.flipping = true
        gauge.run(SKAction.fadeIn(withDuration: 0.05))
        
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
    }
    
    
    func handleSuccessfulClick() {
            setFlash(timeValue: 0.2)
            bottleFlash.run(flash)
            
            setFlash(timeValue: 0.15 * bottleSpeed)
            symbol.changeDirection()
            symbol.run(flash)
            
            symbolActivate = true
            self.speed = 0.2
            
            
            //currentLevel += 1
            //score.updateLabel(currentLevel)
            //updateBottleSpeed()
            //roundClick = true
    }
    
    
    func handleFailedClick() {
        if !roundClick {
            //Player click screen WRONG during bottle flip
            let shake = SKAction.shake(duration: 0.6)
            bottle.run(shake)
            gameEnded = true
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if !gameEnded {
                if !bottle.flipping {
                    handleInitialFlip()
                } else {
                    if gaugeFiller.position.y > 250 {
                        handleSuccessfulClick()
                    } else if !symbolActivate {
                        handleFailedClick()
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
    
    @objc func swipeHandler(_ gesture: UISwipeGestureRecognizer) {
        if symbolActivate {
            self.run(SKAction.speed(to: 1.0, duration: 0.5))
            symbolActivate = false
            switch gesture.direction {
            case .up:
                print("Swipe Up Detected")
                handleSwipe(direction: "up")
            case .down:
                print("Swipe Down Detected")
                handleSwipe(direction: "down")
            case .left:
                print("Swipe Left Detected")
                handleSwipe(direction: "left")
            case .right:
                print("Swipe Right Detected")
                handleSwipe(direction: "right")
            default:
                break
            }
        }
    }
    
    func handleSwipe(direction: String) {
        if symbol.currentDirection == direction {
            print("Correct Swipe! 🎉")
            // Reward the player
            currentLevel += 1
            score.updateLabel(currentLevel)
            updateBottleSpeed()
            roundClick = true
        } else {
            print("Wrong Swipe! ❌")
            gameEnded = true
        }
    }
    
    func gameOver() {
        bottle.gameOver()
        score.gameOver()
    }
    
    func setFlash(timeValue: Double) {
        flash = SKAction.sequence([
            SKAction.fadeIn(withDuration: timeValue),
            SKAction.wait(forDuration: timeValue * 2),
            SKAction.fadeOut(withDuration: timeValue)])

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
