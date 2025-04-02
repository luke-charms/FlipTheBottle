//
//  Bottle.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import Foundation
import SpriteKit


class Bottle: SKSpriteNode {
    
    var flipping = false
    
    init() {
        let texture = SKTexture(imageNamed: "bottle")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "bottle"
        position = CGPoint(x: 0, y: -220)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(3.0)
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameOver() {
        self.zRotation = .pi / 2
    }
}


class BottleFlash: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bottleFlash")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "bottleFlash"
        position = CGPoint(x: 0, y: 90)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(3.0)
        zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
