//
//  BottleFlash.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 31/03/2025.
//

import Foundation
import SpriteKit


class BottleFlash: SKSpriteNode {

    
    init() {
        let texture = SKTexture(imageNamed: "bottleFlash")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "bottleFlash"
        position = CGPoint(x: 0, y: 250)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(10.0)
        zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

