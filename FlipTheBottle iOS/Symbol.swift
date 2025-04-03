//
//  Symbol.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import Foundation
import SpriteKit

class Symbol: SKSpriteNode {
    
    var currentDirection: String = "right" // Default direction
    
    init() {
        let texture = SKTexture(imageNamed: "right")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "symbol"
        position = CGPoint(x: 0, y: 50)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(4.5)
        zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeDirection() {
        let randomInt = Int.random(in: 0..<4)
        switch randomInt {
        case 0:
            let texture = SKTexture(imageNamed: "right")
            self.texture = texture
            currentDirection = "right"
        case 1:
            let texture = SKTexture(imageNamed: "left")
            self.texture = texture
            currentDirection = "left"
        case 2:
            let texture = SKTexture(imageNamed: "up")
            self.texture = texture
            currentDirection = "up"
        case 3:
            let texture = SKTexture(imageNamed: "down")
            self.texture = texture
            currentDirection = "down"
        default:
            print("DIRECTION NOT FOUND!")
        }
    }
}
