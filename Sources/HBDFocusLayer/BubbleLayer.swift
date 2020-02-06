//
//  BubbleLayer.swift
//  animationTest
//
//  Created by Hugo Bosc-Ducros on 28/03/2018.
//  Copyright © 2018 Hugo Bosc-Ducros. All rights reserved.
//

import UIKit

public class Pipo:NSObject {
    public var price:Float
    override public init() {
        self.price = 0
        super.init()
    }
}

class BubbleLayer: CAShapeLayer {
    
    enum BubbleLayerOrientation {
        case top, bottom, left, right
    }
    
    var orientation:BubbleLayerOrientation
    
    init(frame:CGRect, cornerRadius:CGFloat, orientation:BubbleLayerOrientation) {
        self.orientation = orientation
        super.init()
        let path = UIBezierPath(roundedRect:frame, cornerRadius: cornerRadius)
        path.append(self.makeTrianglePath(frame: frame, orientation: orientation))
        self.path = path.cgPath
        self.fillColor = UIColor.green.cgColor
        var labelFrame = frame
        labelFrame.origin += CGPoint(x: 4, y: 4)
        labelFrame.size -= CGSize(width: 8, height: 8)
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        //label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "pipopipou tatito tit tatitou tata titi toto ioedodo ekdoekd"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        //let rect = label.textRect(forBounds: self.bounds, limitedToNumberOfLines: 0)
        let text = label.attributedText
    
        
        let textLayer = CATextLayer(layer: self)
        textLayer.frame = labelFrame
        //textLayer.fontSize = 15
        //textLayer.anchorPoint = CGPoint(x: frame.center.x, y: frame.center.y)
        textLayer.isWrapped = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.string = text
        //self.mask = textLayer
        self.addSublayer(textLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeTrianglePath(frame:CGRect,orientation:BubbleLayerOrientation) -> UIBezierPath {
        let path = UIBezierPath()
        let firstPoint:CGPoint
        let secondPoint:CGPoint
        let thirdtPoint:CGPoint
        switch orientation {
        case .bottom:
            firstPoint = CGPoint(x: frame.center.x - 10, y: frame.origin.y)
            secondPoint = CGPoint(x: frame.center.x, y: frame.origin.y - 10)
            thirdtPoint = CGPoint(x: frame.center.x + 10, y: frame.origin.y)
        case .top:
            firstPoint = CGPoint(x: frame.center.x - 10, y: frame.origin.y + frame.height)
            secondPoint = CGPoint(x: frame.center.x, y: frame.origin.y + frame.height + 10)
            thirdtPoint = CGPoint(x: frame.center.x + 10, y: frame.origin.y + frame.height)
        case .right:
            firstPoint = CGPoint(x: frame.origin.x, y: frame.center.y - 10)
            secondPoint = CGPoint(x: frame.origin.x - 10, y: frame.center.y)
            thirdtPoint = CGPoint(x: frame.origin.x, y: frame.center.y + 10)
        case .left:
            firstPoint = CGPoint(x: frame.origin.x + frame.width, y: frame.center.y - 10)
            secondPoint = CGPoint(x: frame.origin.x + frame.width + 10, y: frame.center.y)
            thirdtPoint = CGPoint(x: frame.origin.x + frame.width, y: frame.center.y + 10)
        }
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdtPoint)
        return path
    }
    
}
