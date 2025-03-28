//
//  Table.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import Foundation
import SpriteKit

class TableTop: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "table")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "table"
        position = CGPoint(x: 0, y: -300)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(2.0)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
