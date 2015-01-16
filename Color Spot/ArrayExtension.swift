//
//  ArrayExtension.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/3/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import Foundation

extension Array {
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

