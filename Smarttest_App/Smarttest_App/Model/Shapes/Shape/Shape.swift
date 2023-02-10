//
//  Shape.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 09.02.23.
//

import UIKit

enum Shapes: String {
    case square = "Square"
    case rectangle = "Rectangle"
    case triangle = "Triangle"
}

protocol Shape {
    var title: String { get set }
    var origin: CGPoint { get set }
    var size: CGSize { get set }
    var colour: CGColor { get set }
    var type: Shapes { get }
    
    mutating func setRectangle(origin: CGPoint, size: CGSize)
    static func convertTitleToType(title: String) -> Shapes
}

extension Shape {
    static func convertTitleToType(title: String) -> Shapes {
        switch title {
        case "Square":
            return .square
        case "Rectangle":
            return .rectangle
        case "Triangle":
            return .triangle
        default:
            return .square
        }
    }
}
