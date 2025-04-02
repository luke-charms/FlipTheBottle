//
//  Symbol.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import Foundation
import SpriteKit

class Symbol: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "right")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "symbol"
        position = CGPoint(x: 0, y: 50)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(2.0)
        zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeDirection(newDirection: String) {
        switch newDirection {
        case "right":
            let texture = SKTexture(imageNamed: "right")
            self.texture = texture
        case "left":
            let texture = SKTexture(imageNamed: "left")
            self.texture = texture
        case "up":
            let texture = SKTexture(imageNamed: "up")
            self.texture = texture
        case "down":
            let texture = SKTexture(imageNamed: "down")
            self.texture = texture
        default:
            print("DIRECTION NOT FOUND!")
        }
    }
}
