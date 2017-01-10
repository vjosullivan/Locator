//
//  VerticalButton.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class VerticalButton: UIButton {
    
    func titleRectForContentRect(bounds: CGRect) -> CGRect {
        var frame = super.titleRect(forContentRect: bounds)
        
        frame.origin.y -= (frame.size.width - frame.size.height) / 2;
        frame.size.height = frame.size.width;
    
        return frame;
    }
}
