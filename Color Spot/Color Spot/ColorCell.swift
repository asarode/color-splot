//
//  ColorCell.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/3/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    func styleCollectionCell(tweakedColor: UIColor) {
        self.backgroundColor = tweakedColor
        self.layer.borderWidth = 1
        self.layer.borderColor = tweakedColor.CGColor
        self.layer.cornerRadius = self.frame.width / 2
    }

    
}
