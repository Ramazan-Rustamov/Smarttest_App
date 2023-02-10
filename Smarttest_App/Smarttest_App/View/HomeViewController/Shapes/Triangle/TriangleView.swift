//
//  TriangleView.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 09.02.23.
//

import UIKit

class TriangleView : UIView {
    
    private let context: CGContext? = UIGraphicsGetCurrentContext()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        context.setFillColor(UIColor.yellow.cgColor)
        
        context.fillPath()
    }
    
    @objc override func setBackgroundColour(to colour: UIColor) {
        context?.setFillColor(colour.cgColor)
    }
}

extension UIView {
    @objc func setBackgroundColour(to colour: UIColor) {
        backgroundColor = colour
    }
}
