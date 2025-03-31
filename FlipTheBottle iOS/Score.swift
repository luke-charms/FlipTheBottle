//
//  Score.swift
//  FlipTheBottle iOS
//
//  Created by Lukas Hjortenfeldt on 31/03/2025.
//

import Foundation
import SpriteKit

class Score: SKLabelNode {
    override init() {
        super.init()
        
        text = String(0)
        
        fontSize = 128
        fontName = "Futura Bold"
        fontColor = .white
        
        position = CGPoint(x: 0, y: 250)
        zPosition = 4
    }
    
    func updateLabel(_ level: Int) {
        text = String(level)
    }
    
    func gameOver() {
        setScale(0.5)
        text = "GAME OVER"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
