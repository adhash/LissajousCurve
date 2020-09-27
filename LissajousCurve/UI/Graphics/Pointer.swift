//
//  Pointer.swift
//  LissajousCurve
//
//  Created by wojtek on 22/09/2020.
//  Copyright © 2020 wojtek. All rights reserved.
//

import UIKit

class Pointer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.yellow.cgColor)
            context.addEllipse(in: rect)
            context.fillPath()
        }
        
    }
}
