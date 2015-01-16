//
//  UIColorExtension.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/6/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import UIKit

extension UIColor {
    
    func getHexStringFromColor() -> String {
        let components = CGColorGetComponents(self.CGColor)
        
        let r = Float(components[0] * 255)
        let g = Float(components[1] * 255)
        let b = Float(components[2] * 255)
        
        let hexString = String(NSString(format:"#%2X%2X%2X", lroundf(r), lroundf(g), lroundf(b)))
        
        return hexString
        
    }
    
    func generateRandomColor() -> UIColor {
        // Not full range to avoid collision with tweaked colors
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256  // from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 89) / 256 + 0.35 // 0.5 to 0.85, away from white
        let brightness : CGFloat = CGFloat(arc4random() % 89) / 256 + 0.35 // 0.5 to 0.85, away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    func isLightColor() -> Bool {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        
        self.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.getRed(nil, green: &green, blue: nil, alpha: nil)
        self.getRed(nil, green: nil, blue: &blue, alpha: nil)
        
        let lumaRed = 0.2126 * Float(red)
        let lumaGreen = 0.7152 * Float(green)
        let lumaBlue = 0.0722 * Float(blue)
        let luma = Float(lumaRed + lumaGreen + lumaBlue)
        
        return luma >= 0.6
    }

}
