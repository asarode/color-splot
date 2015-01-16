//
//  CGColorExtension.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/6/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import UIKit

extension CGColor {
    func equals(other: CGColor) -> Bool {
        let components1 = CGColorGetComponents(self)
        let components2 = CGColorGetComponents(other)
        
        return components1[0] == components2[0] && components1[1] == components2[1] && components1[2] == components2[2]
    }
}
