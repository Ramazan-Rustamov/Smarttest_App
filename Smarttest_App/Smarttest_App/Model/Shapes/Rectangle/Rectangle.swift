//
//  Rectangle.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 09.02.23.
//

import UIKit

struct Rectangle: Shape {
    
    var title: String = "Rectangle"
    var size: CGSize = .init(width: 0, height: 0)
    var origin: CGPoint = .init(x: 0, y: 0)
    var type: Shapes = .rectangle
    var colour: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    mutating func setRectangle(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
}
