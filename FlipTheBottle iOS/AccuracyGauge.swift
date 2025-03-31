//
//  AccuracyGauge.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 28/03/2025.
//

import Foundation
import SpriteKit



class Gauge: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "meter")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "Gauge"
        position = CGPoint(x: 200, y: -25)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(0.25)
        zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GaugeFiller: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "meter_filler")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "GaugeFiller"
        position = CGPoint(x: 0, y: -500)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setScale(0.035)
        zPosition = 1
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
