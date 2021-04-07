//
//  RandomFunction.swift
//  Save The Red Dots
//
//  Created by Jeffrey Ford on 5/3/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func random() -> CGFloat{
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    public static func random(min min : CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
    
}
